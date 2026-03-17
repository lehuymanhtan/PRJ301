"""
retrain.py
===========
Retrain the Prophet model with new data appended to the original history.

⚠️  Prophet does NOT support incremental/online learning.
    The model must be fully retrained from scratch each time.
    This script combines all historical data and fits a new model.

Usage:
    python retrain.py new_data_jan2026.csv new_data_feb2026.csv ...

New data files must have the same format as data.csv:
    column 1 – date  (YYYY-MM-DD)
    column 2 – daily revenue (raw value, same unit as original data)

The old model is backed up before being overwritten.
"""

import warnings
warnings.filterwarnings("ignore")

import sys
import shutil
import matplotlib
matplotlib.use("Agg")

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
from prophet import Prophet
from prophet.serialize import model_to_json

# ─────────────────────────────────────────────────────────────
# CONFIG
# ─────────────────────────────────────────────────────────────
ORIGINAL_DATA  = "data.csv"
MODEL_PATH     = "prophet_revenue_model.json"
FORECAST_MONTHS = 3          # months to forecast after retraining

# ─────────────────────────────────────────────────────────────
# 1.  Read new data files from command line args
#     e.g.  python retrain.py jan2026.csv feb2026.csv
# ─────────────────────────────────────────────────────────────
new_files = sys.argv[1:]
if not new_files:
    print("⚠️  No new data files provided.")
    print("Usage: python retrain.py file1.csv file2.csv ...")
    print("\nNew file format (no header):")
    print("   2026-01-01,1500000000")
    print("   2026-01-02,2300000000")
    sys.exit(1)

# ─────────────────────────────────────────────────────────────
# 2.  Load & combine all data
# ─────────────────────────────────────────────────────────────
def load_csv(path):
    df = pd.read_csv(path, header=None, names=["ds", "y"])
    df["ds"] = pd.to_datetime(df["ds"])
    df["y"]  = df["y"] / 1e9
    return df

df_original = load_csv(ORIGINAL_DATA)
print(f"📂 Original data : {len(df_original)} rows "
      f"({df_original['ds'].min().date()} → {df_original['ds'].max().date()})")

new_frames = []
for f in new_files:
    df_new = load_csv(f)
    print(f"📂 New data file : {f}  →  {len(df_new)} rows "
          f"({df_new['ds'].min().date()} → {df_new['ds'].max().date()})")
    new_frames.append(df_new)

df_all = pd.concat([df_original] + new_frames, ignore_index=True)
df_all = df_all.drop_duplicates(subset="ds").sort_values("ds").reset_index(drop=True)

print(f"\n✅ Combined dataset : {len(df_all)} rows "
      f"({df_all['ds'].min().date()} → {df_all['ds'].max().date()})")

# ─────────────────────────────────────────────────────────────
# 3.  Backup old model
# ─────────────────────────────────────────────────────────────
backup_path = MODEL_PATH.replace(".json", "_backup.json")
shutil.copy(MODEL_PATH, backup_path)
print(f"🗄️  Old model backed up → {backup_path}")

# ─────────────────────────────────────────────────────────────
# 4.  Retrain – same hyperparameters as original
# ─────────────────────────────────────────────────────────────
print("\n🔧 Retraining model on full dataset …")

m = Prophet(
    seasonality_mode         = "multiplicative",
    yearly_seasonality       = True,
    weekly_seasonality       = True,
    daily_seasonality        = False,
    changepoint_prior_scale  = 0.1,
    seasonality_prior_scale  = 10,
    holidays_prior_scale     = 10,
    interval_width           = 0.95,
)
m.add_country_holidays(country_name="VN")
m.fit(df_all)

print(f"✅ Retrain complete  ({len(df_all)} rows used)")
print(f"🏖️  Holidays: {', '.join(m.train_holiday_names.tolist())}")

# ─────────────────────────────────────────────────────────────
# 5.  Forecast next N months
# ─────────────────────────────────────────────────────────────
last_date    = df_all["ds"].max()
future       = m.make_future_dataframe(periods=FORECAST_MONTHS * 31, freq="D")
forecast     = m.predict(future)

fcast = forecast[forecast["ds"] > last_date].copy()
cutoff = last_date + pd.DateOffset(months=FORECAST_MONTHS)
fcast  = fcast[fcast["ds"] < cutoff]

fcast["yhat"]       = fcast["yhat"].clip(lower=0)
fcast["yhat_lower"] = fcast["yhat_lower"].clip(lower=0)
fcast["yhat_upper"] = fcast["yhat_upper"].clip(lower=0)

# ─────────────────────────────────────────────────────────────
# 6.  Print summary
# ─────────────────────────────────────────────────────────────
AGG = {"yhat": "sum", "yhat_lower": "sum", "yhat_upper": "sum"}
monthly = (fcast.groupby(fcast["ds"].dt.to_period("M"), sort=True)
               .agg(AGG).reset_index()
               .rename(columns={"ds": "Tháng",
                                "yhat": "Dự báo (tỷ)",
                                "yhat_lower": "Lower 95%",
                                "yhat_upper": "Upper 95%"}))

total    = fcast["yhat"].sum()
total_lo = fcast["yhat_lower"].sum()
total_hi = fcast["yhat_upper"].sum()

print("\n" + "=" * 60)
print(f"  DỰ BÁO SAU RETRAIN – {FORECAST_MONTHS} THÁNG TIẾP THEO")
print("=" * 60)
df_p = monthly.copy()
df_p["Tháng"] = df_p["Tháng"].astype(str)
for col in ["Dự báo (tỷ)", "Lower 95%", "Upper 95%"]:
    df_p[col] = df_p[col].map(lambda x: f"{x:>12,.2f}")
print(df_p.to_string(index=False))
print("─" * 60)
print(f"  TỔNG      : {total:>12,.2f} tỷ VNĐ")
print(f"  KTC 95%   :  [{total_lo:,.2f}  –  {total_hi:,.2f}] tỷ VNĐ")
print("─" * 60)

# ─────────────────────────────────────────────────────────────
# 7.  Save updated model (overwrites old)
# ─────────────────────────────────────────────────────────────
with open(MODEL_PATH, "w", encoding="utf-8") as f:
    f.write(model_to_json(m))
print(f"\n✅ Updated model saved → {MODEL_PATH}")

# ─────────────────────────────────────────────────────────────
# 8.  Chart
# ─────────────────────────────────────────────────────────────
fig = m.plot(forecast, figsize=(15, 6))
ax  = fig.axes[0]
ax.set_title("Dự báo Doanh thu sau Retrain", fontsize=14)
ax.set_xlabel("Ngày")
ax.set_ylabel("Doanh thu (tỷ VNĐ)")
ax.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"{x:,.0f}"))
ax.axvline(last_date + pd.Timedelta(days=1), color="red",
           linestyle="--", lw=1.8, alpha=0.85, label="Bắt đầu dự báo")
ax.legend(loc="upper left")
fig.tight_layout()
fig.savefig("retrain_forecast_plot.png", dpi=150)
plt.close(fig)
print("✅ Chart saved → retrain_forecast_plot.png")
