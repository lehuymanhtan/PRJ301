"""
load_and_predict.py
====================
Load saved Prophet model and forecast any future window.

Usage:
    python load_and_predict.py

Edit FORECAST_MONTHS at the top to change how far ahead to predict.
"""

import warnings
warnings.filterwarnings("ignore")

import matplotlib
matplotlib.use("Agg")

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
from prophet.serialize import model_from_json

# ─────────────────────────────────────────────────────────────
# CONFIG – change these as needed
# ─────────────────────────────────────────────────────────────
MODEL_PATH        = "prophet_revenue_model.json"
ORIGINAL_DATA     = "data.csv"          # used only to know where history ends
FORECAST_MONTHS   = 3                   # how many months ahead to forecast
OUTPUT_CHART      = "prediction_plot.png"

# ─────────────────────────────────────────────────────────────
# 1.  Load model
# ─────────────────────────────────────────────────────────────
with open(MODEL_PATH, encoding="utf-8") as f:
    m = model_from_json(f.read())

print(f"✅ Model loaded ← {MODEL_PATH}")

# ─────────────────────────────────────────────────────────────
# 2.  Determine forecast start  (day after last training date)
# ─────────────────────────────────────────────────────────────
df_hist = pd.read_csv(ORIGINAL_DATA, header=None, names=["ds", "y"])
df_hist["ds"] = pd.to_datetime(df_hist["ds"])
last_date = df_hist["ds"].max()

FORECAST_DAYS = FORECAST_MONTHS * 31   # safe upper bound; trimmed below
print(f"📅 History ends : {last_date.date()}")
print(f"🔮 Forecasting  : {FORECAST_MONTHS} months ahead")

# ─────────────────────────────────────────────────────────────
# 3.  Predict
# ─────────────────────────────────────────────────────────────
future   = m.make_future_dataframe(periods=FORECAST_DAYS, freq="D")
forecast = m.predict(future)

# Keep only future rows, exact calendar months
fcast = forecast[forecast["ds"] > last_date].copy()
cutoff = last_date + pd.DateOffset(months=FORECAST_MONTHS)
fcast  = fcast[fcast["ds"] < cutoff]

fcast["yhat"]       = fcast["yhat"].clip(lower=0)
fcast["yhat_lower"] = fcast["yhat_lower"].clip(lower=0)
fcast["yhat_upper"] = fcast["yhat_upper"].clip(lower=0)

# ─────────────────────────────────────────────────────────────
# 4.  Aggregate + print
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
print(f"  DỰ BÁO {FORECAST_MONTHS} THÁNG TIẾP THEO")
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
# 5.  Chart
# ─────────────────────────────────────────────────────────────
fig = m.plot(forecast, figsize=(15, 6))
ax  = fig.axes[0]
ax.set_title(f"Dự báo Doanh thu – {FORECAST_MONTHS} tháng tiếp theo", fontsize=14)
ax.set_xlabel("Ngày")
ax.set_ylabel("Doanh thu (tỷ VNĐ)")
ax.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"{x:,.0f}"))
ax.axvline(last_date + pd.Timedelta(days=1), color="red",
           linestyle="--", lw=1.8, alpha=0.85, label="Bắt đầu dự báo")
ax.legend(loc="upper left", fontsize=10)
fig.tight_layout()
fig.savefig(OUTPUT_CHART, dpi=150)
plt.close(fig)
print(f"\n✅ Chart saved → {OUTPUT_CHART}")
