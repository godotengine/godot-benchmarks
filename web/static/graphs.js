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
		(a, b) => `${a.date}.${a.commit}` > `${b.date}.${b.commit}` ? 1 : -1,
	);
	const graph = Database.graphs.find((g) => g.id == graphID);
	if (!graph) {
		throw new Error("Invalid graph ID");
	}
	// Group by series.
	const xAxis = [];
	const commits = [];
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
		xAxis.push(Date.parse(benchmark.date));
		commits.push(benchmark.commit);

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

	// Normalize each series:
	// - The last n samples are used as 'reference'.
	// - The median defines the value 1.0.
	series.forEach((serie, key) => {
		const NUM_VALUES_USED_FOR_REFERENCE = 10;
		let values = [];
		for (let i = serie.length - 1; i >= 0; i--) {
			let el = serie[i];
			if (el != null) {
				values.push(el);
				if (values.length >= NUM_VALUES_USED_FOR_REFERENCE) {
					break;
				}
			}
		}
		values.sort();
		let median = values[Math.floor(NUM_VALUES_USED_FOR_REFERENCE / 2)];

		series.set(
			key,
			serie.map((v) => {
				if (v != null) {
					return v / median;
				}
				return null;
			}),
		);
	});

	if (type === "compact") {
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
				point = sum / count;
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
				enabled: type !== 'compact',
			},
			toolbar: {
				show: type !== 'compact',
			},
			animations: {
				enabled: false,
			},
		},
		tooltip: {
			theme: "dark",
			shared: false,
			x: {
				formatter: function(value, opts) {
					const commit = commits[opts.dataPointIndex];
					return '' + new Date(value).toISOString().substring(0, 10) + " (" + commit + ")";
				},
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
			type: 'datetime',
			categories: xAxis,
			labels: {
				show: type !== "compact",
			},
		},
		yaxis: {
			tickAmount: type === "compact" ? 4 : 8,
			showAlways: true,
			min: 0.0,
			max: 2,
			// TODO Somehow broken :(
			// logarithmic: true,
			// logBase: 10,
			decimalsInFloat: 2,
		},
		legend: {
			show: type !== "compact",
		},
	};

	var chart = new ApexCharts(document.querySelector(targetDivID), options);
	chart.render();
}
