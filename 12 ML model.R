library(minpack.lm)

scurve = function(x, center, width) {
    1 / (1 + exp(-(x - center) / width))
}

nls_model = nlsLM(
    trips ~ exp(
        const +
            b_weekday * weekday_non_holiday +
            b_expansion * (date > "2015-08-25")
    ) +
        b_weather * scurve(
            max_temperature + b_precip * precipitation + b_snow * snow_depth,
            weather_scurve_center,
            weather_scurve_width
        ),
    data = filter(weather_data, date >= "2013-08-01"),
    start = list(const = 9,
                 b_weekday = 1,
                 b_expansion = 1,
                 b_weather = 25000,
                 b_precip = -20, b_snow = -2,
                 weather_scurve_center = 40,
                 weather_scurve_width = 20))

summary(nls_model)

# Parameters:
#                         Estimate Std. Error t value Pr(>|t|)
# const                  7.893      1.816e-01  43.457  < 2e-16
# b_weekday              1.058      1.205e-01   8.786  < 2e-16
# b_expansion            0.982      5.688e-02  17.268  < 2e-16
# b_weather              29613      8.914e+02  33.219  < 2e-16
# b_precip              -23.55      1.191e+00 -19.768  < 2e-16
# b_snow                 -1.37      2.948e-01  -4.633 4.17e-06
# weather_scurve_center  52.95      7.599e-01  69.678  < 2e-16
# weather_scurve_width   11.34      7.117e-01  15.935  < 2e-16
# ---
# Residual standard error: 4158 on 844 degrees of freedom
# Number of iterations to convergence: 11