"""
Revenue Forecasting – Prophet Model
====================================
Data    : data.csv  (daily revenue, Jan–Dec 2025)
Target  : Forecast total revenue for the next 3 months (Jan–Mar 2026)
Model   : Prophet  |  Multiplicative seasonality  |  Vietnam holidays
Output  : forecast_plot.png, components_plot.png, monthly_forecast_bar.png
          prophet_revenue_model.json
"""

import warnings
warnings.filterwarnings("ignore")

import matplotlib
matplotlib.use("Agg")  # non-interactive backend – safe for headless environments

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
from prophet import Prophet
from prophet.serialize import model_to_json

# ─────────────────────────────────────────────────────────────
# 1.  Load & prepare data
# ─────────────────────────────────────────────────────────────
df = pd.read_csv("data.csv", header=None, names=["ds", "y"])
df["ds"] = pd.to_datetime(df["ds"])
df["y"]  = df["y"] / 1e9          # Convert to tỷ VNĐ (easier to read)

print("=" * 65)
print("  PROPHET REVENUE FORECAST – Q1/2026")
print("=" * 65)
print(f"\n📂 Data range   : {df['ds'].min().date()} → {df['ds'].max().date()}")
print(f"📊 Total rows   : {len(df)} ngày")
print(f"📈 Revenue/day  : {df['y'].min():.2f} – {df['y'].max():.2f} tỷ VNĐ")
print(f"📉 Mean revenue : {df['y'].mean():.2f} tỷ VNĐ/ngày")

# ─────────────────────────────────────────────────────────────
# 2.  Build & fit Prophet model
# ─────────────────────────────────────────────────────────────
m = Prophet(
    seasonality_mode         = "multiplicative",  # revenue scales with trend
    yearly_seasonality       = True,
    weekly_seasonality       = True,
    daily_seasonality        = False,
    changepoint_prior_scale  = 0.1,   # moderate flexibility for trend
    seasonality_prior_scale  = 10,    # allow strong seasonal patterns
    holidays_prior_scale     = 10,    # holiday effects
    interval_width           = 0.95,  # 95% confidence interval
)

# Built-in Vietnamese public holidays
m.add_country_holidays(country_name="VN")

print("\n🔧 Fitting model …")
m.fit(df)
print(f"✅ Model fitted")
print(f"🏖️  Holidays loaded ({len(m.train_holiday_names)}): "
      f"{', '.join(m.train_holiday_names.tolist())}")

# ─────────────────────────────────────────────────────────────
# 3.  Forecast next 3 months  (Jan 31 + Feb 28 + Mar 31 = 90 days)
# ─────────────────────────────────────────────────────────────
future   = m.make_future_dataframe(periods=90, freq="D")
forecast = m.predict(future)

# Extract only the future portion
fcast = forecast[forecast["ds"] > df["ds"].max()].copy()
fcast["yhat"]       = fcast["yhat"].clip(lower=0)
fcast["yhat_lower"] = fcast["yhat_lower"].clip(lower=0)
fcast["yhat_upper"] = fcast["yhat_upper"].clip(lower=0)

print(f"\n📅 Forecast window: {fcast['ds'].min().date()} → {fcast['ds'].max().date()}")
print(f"   ({len(fcast)} ngày)")

# ─────────────────────────────────────────────────────────────
# 4.  Aggregate by month / quarter / year
# ─────────────────────────────────────────────────────────────
fcast["month_p"]   = fcast["ds"].dt.to_period("M")
fcast["quarter_p"] = fcast["ds"].dt.to_period("Q")
fcast["year"]      = fcast["ds"].dt.year

AGG = {"yhat": "sum", "yhat_lower": "sum", "yhat_upper": "sum"}

monthly = (fcast.groupby("month_p",   sort=True).agg(AGG).reset_index()
               .rename(columns={"month_p": "Tháng",
                                "yhat": "Dự báo (tỷ)", "yhat_lower": "Lower 95%", "yhat_upper": "Upper 95%"}))

quarterly = (fcast.groupby("quarter_p", sort=True).agg(AGG).reset_index()
                 .rename(columns={"quarter_p": "Quý",
                                  "yhat": "Dự báo (tỷ)", "yhat_lower": "Lower 95%", "yhat_upper": "Upper 95%"}))

yearly = (fcast.groupby("year", sort=True).agg(AGG).reset_index()
              .rename(columns={"year": "Năm",
                               "yhat": "Dự báo (tỷ)", "yhat_lower": "Lower 95%", "yhat_upper": "Upper 95%"}))

total    = fcast["yhat"].sum()
total_lo = fcast["yhat_lower"].sum()
total_hi = fcast["yhat_upper"].sum()

# ── Pretty-print helper ────────────────────────────────────────
def print_table(df_in, id_col):
    df_p = df_in.copy()
    df_p[id_col] = df_p[id_col].astype(str)
    for col in ["Dự báo (tỷ)", "Lower 95%", "Upper 95%"]:
        df_p[col] = df_p[col].map(lambda x: f"{x:>12,.2f}")
    print(df_p.to_string(index=False))

print("\n" + "=" * 65)
print("  KẾT QUẢ DỰ BÁO DOANH THU – 3 THÁNG TIẾP THEO")
print("=" * 65)

print("\n📅 Theo Tháng:")
print_table(monthly,  "Tháng")

print("\n📊 Theo Quý:")
print_table(quarterly, "Quý")

print("\n📆 Theo Năm:")
print_table(yearly,   "Năm")

print("\n" + "─" * 65)
print(f"  TỔNG Q1/2026 : {total:>12,.2f} tỷ VNĐ")
print(f"  KTC 95%       : [{total_lo:,.2f}  –  {total_hi:,.2f}] tỷ VNĐ")
print("─" * 65)

# ─────────────────────────────────────────────────────────────
# 5.  Plots
# ─────────────────────────────────────────────────────────────
FORECAST_START = pd.Timestamp("2026-01-01")

# 5a. Full forecast line chart
fig1 = m.plot(forecast, figsize=(15, 6))
ax1  = fig1.axes[0]
ax1.set_title("Dự báo Doanh thu Hàng ngày – Prophet (Multiplicative)", fontsize=14, pad=12)
ax1.set_xlabel("Ngày")
ax1.set_ylabel("Doanh thu (tỷ VNĐ)")
ax1.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"{x:,.0f}"))
ax1.axvline(FORECAST_START, color="red", linestyle="--", lw=1.8, alpha=0.85,
            label="Bắt đầu dự báo (01/01/2026)")
ax1.legend(loc="upper left", fontsize=10)
fig1.tight_layout()
fig1.savefig("forecast_plot.png", dpi=150)
plt.close(fig1)

# 5b. Component decomposition
fig2 = m.plot_components(forecast, figsize=(14, 12))
fig2.suptitle("Phân tích Thành phần – Trend / Holiday / Seasonality", fontsize=14)
fig2.tight_layout()
fig2.savefig("components_plot.png", dpi=150)
plt.close(fig2)

# 5c. Monthly bar chart for the 3-month forecast
m_vals   = monthly["Dự báo (tỷ)"].values
m_labels = monthly["Tháng"].astype(str).tolist()
m_lo_err = m_vals - monthly["Lower 95%"].values
m_hi_err = monthly["Upper 95%"].values - m_vals

fig3, ax3 = plt.subplots(figsize=(9, 5))
colors = ["#4C72B0", "#DD8452", "#55A868"]
bars = ax3.bar(
    m_labels, m_vals,
    color=colors,
    yerr=[m_lo_err, m_hi_err],
    capsize=12, alpha=0.88,
    ecolor="gray", error_kw={"linewidth": 2}
)
for bar, val in zip(bars, m_vals):
    ax3.text(
        bar.get_x() + bar.get_width() / 2,
        bar.get_height() + m_hi_err.max() * 0.04,
        f"{val:,.1f} tỷ",
        ha="center", va="bottom", fontsize=11, fontweight="bold"
    )
ax3.set_title("Tổng Doanh thu Dự báo theo Tháng (Q1/2026)", fontsize=13)
ax3.set_ylabel("Doanh thu (tỷ VNĐ)")
ax3.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"{x:,.0f}"))
ax3.set_ylim(0, max(monthly["Upper 95%"].values) * 1.20)
ax3.grid(axis="y", alpha=0.3)
ax3.annotate(
    f"Tổng 3 tháng: {total:,.1f} tỷ  |  KTC 95%: [{total_lo:,.1f} – {total_hi:,.1f}] tỷ",
    xy=(0.5, -0.12), xycoords="axes fraction",
    ha="center", fontsize=9, color="gray"
)
fig3.tight_layout()
fig3.savefig("monthly_forecast_bar.png", dpi=150)
plt.close(fig3)

print("\n✅ Charts saved:")
print("   forecast_plot.png         – full timeline forecast")
print("   components_plot.png       – trend / holiday / seasonality breakdown")
print("   monthly_forecast_bar.png  – 3-month bar chart")

# ─────────────────────────────────────────────────────────────
# 6.  Save model  (JSON – recommended by Prophet docs)
# ─────────────────────────────────────────────────────────────
MODEL_PATH = "prophet_revenue_model.json"
with open(MODEL_PATH, "w", encoding="utf-8") as f:
    f.write(model_to_json(m))

print(f"\n✅ Model saved → {MODEL_PATH}")
print("\n   Tải lại model trong lần sau:")
print("   ─────────────────────────────────────────────────")
print("   from prophet.serialize import model_from_json")
print(f'   with open("{MODEL_PATH}") as f:')
print("       m = model_from_json(f.read())")
print("   ─────────────────────────────────────────────────")
