"""
Shared paths, metadata helpers, model load/save, and plotting utilities.
All paths are resolved relative to the project root (model/).
"""
import json
import warnings
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import pandas as pd
from datetime import datetime
from pathlib import Path
from typing import Optional

warnings.filterwarnings("ignore")

# ── Project paths ──────────────────────────────────────────────
# server/core/prophet_utils.py  →  .parent.parent.parent  =  model/
BASE_DIR           = Path(__file__).resolve().parent.parent.parent
METADATA_FILE      = BASE_DIR / "model_metadata.json"
TRAINED_MODELS_DIR = BASE_DIR / "trained_models"
OUTPUTS_DIR        = BASE_DIR / "outputs"
ORIGINAL_DATA      = BASE_DIR / "data.csv"
CURRENT_DATA       = BASE_DIR / "data_current.csv"

# Ensure output directories exist at import time
TRAINED_MODELS_DIR.mkdir(exist_ok=True)
OUTPUTS_DIR.mkdir(exist_ok=True)


# ── Metadata ──────────────────────────────────────────────────
def get_metadata() -> dict:
    """Return current model metadata; bootstrap from data.csv on first run."""
    if METADATA_FILE.exists():
        return json.loads(METADATA_FILE.read_text(encoding="utf-8"))

    # First-time bootstrap using original data.csv + default model
    df = _load_csv(ORIGINAL_DATA)
    meta = {
        "last_trained_date": df["ds"].max().strftime("%Y-%m-%d"),
        "model_filename": "prophet_revenue_model.json",
        "training_rows": len(df),
        "trained_at": datetime.now().isoformat(),
    }
    save_metadata(meta)
    return meta


def save_metadata(meta: dict) -> None:
    METADATA_FILE.write_text(
        json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8"
    )


# ── Data ──────────────────────────────────────────────────────
def _load_csv(path: Path) -> pd.DataFrame:
    df = pd.read_csv(path, header=None, names=["ds", "y"])
    df["ds"] = pd.to_datetime(df["ds"])
    df["y"]  = df["y"] / 1e9      # raw VNĐ → tỷ VNĐ
    return df


def get_current_data() -> pd.DataFrame:
    """Load the latest combined training dataset."""
    src = CURRENT_DATA if CURRENT_DATA.exists() else ORIGINAL_DATA
    return _load_csv(src)


def load_csv_bytes(content: bytes) -> pd.DataFrame:
    import io
    df = pd.read_csv(io.BytesIO(content), header=None, names=["ds", "y"])
    df["ds"] = pd.to_datetime(df["ds"])
    df["y"]  = df["y"] / 1e9
    return df


# ── Model ─────────────────────────────────────────────────────
def load_model(model_filename: Optional[str] = None):
    from prophet.serialize import model_from_json

    if model_filename is None:
        model_filename = get_metadata()["model_filename"]

    path = BASE_DIR / model_filename
    with open(path, encoding="utf-8") as f:
        return model_from_json(f.read())


def save_model(m, model_path: Path) -> None:
    from prophet.serialize import model_to_json

    model_path.parent.mkdir(parents=True, exist_ok=True)
    model_path.write_text(model_to_json(m), encoding="utf-8")


def build_model():
    """Return a fresh Prophet model with the project's standard hyperparameters."""
    from prophet import Prophet

    m = Prophet(
        seasonality_mode        = "multiplicative",
        yearly_seasonality      = True,
        weekly_seasonality      = True,
        daily_seasonality       = False,
        changepoint_prior_scale = 0.1,
        seasonality_prior_scale = 10,
        holidays_prior_scale    = 10,
        interval_width          = 0.95,
    )
    m.add_country_holidays(country_name="VN")
    return m


# ── Plotting ──────────────────────────────────────────────────
_FMT = mticker.FuncFormatter(lambda x, _: f"{x:,.0f}")
_COLORS = [
    "#4C72B0", "#DD8452", "#55A868", "#C44E52", "#8172B2",
    "#937860", "#DA8BC3", "#8C8C8C", "#CCB974", "#64B5CD",
]


def save_plots(m, forecast: pd.DataFrame, output_dir: Path,
               last_hist_date: pd.Timestamp) -> None:
    """Save full-timeline forecast plot and component decomposition plot."""
    # 1. Full forecast line
    fig = m.plot(forecast, figsize=(15, 6))
    ax  = fig.axes[0]
    ax.set_title("Dự báo Doanh thu 3 Tháng tới – Prophet", fontsize=14)
    ax.set_xlabel("Ngày")
    ax.set_ylabel("Doanh thu (tỷ VNĐ)")
    ax.yaxis.set_major_formatter(_FMT)
    ax.axvline(last_hist_date + pd.Timedelta(days=1), color="red",
               linestyle="--", lw=1.8, alpha=0.85, label="Bắt đầu dự báo")
    ax.legend(loc="upper left")
    fig.tight_layout()
    fig.savefig(output_dir / "forecast_plot.png", dpi=150)
    plt.close(fig)

    # 2. Components
    fig2 = m.plot_components(forecast, figsize=(14, 12))
    fig2.suptitle("Phân tích Thành phần – Trend / Holiday / Seasonality", fontsize=14)
    fig2.tight_layout()
    fig2.savefig(output_dir / "components_plot.png", dpi=150)
    plt.close(fig2)


def save_monthly_bar(monthly: pd.DataFrame, total: float,
                     total_lo: float, total_hi: float,
                     output_dir: Path) -> None:
    """Save a bar chart of monthly forecast with error bars."""
    m_labels = monthly["Tháng"].astype(str).tolist()
    m_vals   = monthly["Dự báo (tỷ)"].values
    m_lo_err = m_vals - monthly["Lower 95%"].values
    m_hi_err = monthly["Upper 95%"].values - m_vals

    fig, ax = plt.subplots(figsize=(max(9, len(m_labels) * 2.5), 5))
    bars = ax.bar(
        m_labels, m_vals,
        color=[_COLORS[i % len(_COLORS)] for i in range(len(m_labels))],
        yerr=[m_lo_err, m_hi_err],
        capsize=10, alpha=0.88,
        ecolor="gray", error_kw={"linewidth": 2},
    )
    for bar, val in zip(bars, m_vals):
        ax.text(
            bar.get_x() + bar.get_width() / 2,
            bar.get_height() + max(m_hi_err) * 0.04,
            f"{val:,.1f} tỷ",
            ha="center", va="bottom", fontsize=10, fontweight="bold",
        )

    ax.set_title("Tổng Doanh thu Dự báo theo Tháng", fontsize=13)
    ax.set_ylabel("Doanh thu (tỷ VNĐ)")
    ax.yaxis.set_major_formatter(_FMT)
    ax.set_ylim(0, max(monthly["Upper 95%"].values) * 1.20)
    ax.grid(axis="y", alpha=0.3)
    ax.annotate(
        f"Tổng: {total:,.1f} tỷ  |  KTC 95%: [{total_lo:,.1f} – {total_hi:,.1f}] tỷ",
        xy=(0.5, -0.12), xycoords="axes fraction",
        ha="center", fontsize=9, color="gray",
    )
    fig.tight_layout()
    fig.savefig(output_dir / "monthly_bar.png", dpi=150)
    plt.close(fig)
