function getAllowedMetrics() {
  const allowedMetrics = new Set();
  Database.benchmarks.forEach((benchmark) => {
    benchmark.benchmarks.forEach((instance) => {
      Object.entries(instance.results).forEach(([key, value]) => {
        allowedMetrics.add(key);
      });
    });
  });
  return allowedMetrics;
}

function displayGraph(targetDivID, graphID, type = "full", filter = "") {
  if (!["full", "compact"].includes(type)) {
    throw Error("Unknown chart type");
  }

  // Include benchmark data JSON to generate graphs.
  const allBenchmarks = Database.benchmarks.sort(
    (a, b) => `${a.date}.${a.commit}` > `${b.date}.${b.commit}`,
  );
  const graph = Database.graphs.find((g) => g.id == graphID);
  if (!graph) {
    throw new Error("Invalid graph ID");
  }
  // Group by series.
  const xAxis = [];
  const series = new Map();
  const processResult = (path, data, process) => {
    Object.entries(data).forEach(([key, value]) => {
      if (typeof value === "object") {
        processResult(path + "/" + key, value, process);
      } else {
        // Number
        process(path + "/" + key, value);
      }
    });
  };

  // Get list all series and fill it in.
  allBenchmarks.forEach((benchmark, count) => {
    // Process a day/commit
    xAxis.push(benchmark.date + "." + benchmark.commit);

    // Get all series.
    benchmark.benchmarks.forEach((instance) => {
      let instanceKey = instance.path.join("/");
      if (!instanceKey.startsWith(graph["benchmark-path-prefix"])) {
        return;
      }
      instanceKey = instanceKey.slice(
        graph["benchmark-path-prefix"].length + 1,
      );

      processResult(instanceKey, instance.results, (path, value) => {
        // Filter out paths that do not fit the filter
        if (filter && !path.includes(filter)) {
          return;
        }
        if (!series.has(path)) {
          series.set(path, Array(count).fill(null));
        }
        series.get(path).push(value);
      });
    });
  });

  let customColor = undefined;

  if (type === "compact") {
    // Kind of "normalize" the series, dividing by the average.
    series.forEach((serie, key) => {
      let count = 0;
      let mean = 0.0;
      serie.forEach((el) => {
        if (el != null) {
          mean += el;
          count += 1;
        }
      });
      mean = mean / count;

      //const std = Math.sqrt(input.map(x => Math.pow(x - mean, 2)).reduce((a, b) => a + b) / n)
      series.set(
        key,
        serie.map((v) => {
          if (v != null) {
            return v / mean; // Devide by the mean.
          }
          return null;
        }),
      );
    });
    // Combine all into a single, averaged serie.
    const outputSerie = [];
    for (let i = 0; i < allBenchmarks.length; i++) {
      let count = 0;
      let sum = 0;
      series.forEach((serie, key) => {
        if (serie[i] != null) {
          count += 1;
          sum += serie[i];
        }
      });
      let point = null;
      if (count >= 1) {
        point = Math.round((sum * 1000) / count) / 10; // Round to 3 decimals.
      }
      outputSerie.push(point);
    }
    series.clear();
    series.set("Average", outputSerie);

    // Detect whether we went down or not on the last 10 benchmarks.
    const lastElementsCount = 3;
    const totalConsideredCount = 10;
    const lastElements = outputSerie.slice(-lastElementsCount);
    const comparedTo = outputSerie.slice(
      -totalConsideredCount,
      -lastElementsCount,
    );
    const avgLast = lastElements.reduce((a, b) => a + b) / lastElements.length;
    const avgComparedTo =
      comparedTo.reduce((a, b) => a + b) / comparedTo.length;
    const trend = avgLast - avgComparedTo;

    if (trend > 10) {
      customColor = "#E20000";
    } else if (trend < -10) {
      customColor = "#00E200";
    }
  }

  var options = {
    series: Array.from(series.entries()).map(([key, value]) => ({
      name: key,
      data: value,
    })),
    chart: {
      foreColor: "var(--text-bright)",
      background: "var(--background)",
      height: type === "compact" ? 200 : 600,
      type: "line",
      zoom: {
        enabled: false,
      },
      toolbar: {
        show: false,
      },
      animations: {
        enabled: false,
      },
    },
    tooltip: {
      theme: "dark",
      y: {
        formatter: (value, opts) => (type === "compact" ? value + "%" : value),
      },
    },
    dataLabels: {
      enabled: false,
    },
    stroke: {
      curve: "straight",
      width: 2,
    },
    theme: {
      palette: "palette4",
    },
    fill:
      type === "compact"
        ? {
            type: "gradient",
            gradient: {
              shade: "dark",
              gradientToColors: ["#4ecdc4"],
              shadeIntensity: 1,
              type: "horizontal",
              opacityFrom: 1,
              opacityTo: 1,
              stops: [0, 100],
            },
          }
        : {},
    colors:
      type === "compact"
        ? customColor
          ? [customColor]
          : ["#4ecdc4"]
        : undefined,
    xaxis: {
      categories: xAxis,
      labels: {
        show: type !== "compact",
      },
    },
    yaxis: {
      tickAmount: 4,
      min: type === "compact" ? 0 : undefined,
      max: type === "compact" ? 200 : undefined,
    },
    legend: {
      show: type !== "compact",
    },
  };

  var chart = new ApexCharts(document.querySelector(targetDivID), options);
  chart.render();
}
