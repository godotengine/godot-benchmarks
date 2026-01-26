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

const godotReleaseDates = {
	"2024-08-15": "4.3",
	"2025-03-03": "4.4",
	"2025-09-15": "4.5",
	"2026-01-26": "4.6",
};

// Themes extracted using https://stackoverflow.com/questions/71721049/react-plotly-js-apply-dark-plotly-dark-theme
// Derives from plotly
const plotlyTemplatePlotly = {
	"data": {
		"barpolar": [{
			"marker": {
				"line": {"color": "#E5ECF6", "width": 0.5},
				"pattern": {"fillmode": "overlay", "size": 10, "solidity": 0.2}
			}, "type": "barpolar"
		}],
		"bar": [{
			"error_x": {"color": "#2a3f5f"},
			"error_y": {"color": "#2a3f5f"},
			"marker": {
				"line": {"color": "#E5ECF6", "width": 0.5},
				"pattern": {"fillmode": "overlay", "size": 10, "solidity": 0.2}
			},
			"type": "bar"
		}],
		"carpet": [{
			"aaxis": {
				"endlinecolor": "#2a3f5f",
				"gridcolor": "white",
				"linecolor": "white",
				"minorgridcolor": "white",
				"startlinecolor": "#2a3f5f"
			},
			"baxis": {
				"endlinecolor": "#2a3f5f",
				"gridcolor": "white",
				"linecolor": "white",
				"minorgridcolor": "white",
				"startlinecolor": "#2a3f5f"
			},
			"type": "carpet"
		}],
		"choropleth": [{"colorbar": {"outlinewidth": 0, "ticks": ""}, "type": "choropleth"}],
		"contourcarpet": [{"colorbar": {"outlinewidth": 0, "ticks": ""}, "type": "contourcarpet"}],
		"contour": [{
			"colorbar": {"outlinewidth": 0, "ticks": ""},
			"colorscale": [[0.0, "#0d0887"], [0.1111111111111111, "#46039f"], [0.2222222222222222, "#7201a8"], [0.3333333333333333, "#9c179e"], [0.4444444444444444, "#bd3786"], [0.5555555555555556, "#d8576b"], [0.6666666666666666, "#ed7953"], [0.7777777777777778, "#fb9f3a"], [0.8888888888888888, "#fdca26"], [1.0, "#f0f921"]],
			"type": "contour"
		}],
		"heatmapgl": [{
			"colorbar": {"outlinewidth": 0, "ticks": ""},
			"colorscale": [[0.0, "#0d0887"], [0.1111111111111111, "#46039f"], [0.2222222222222222, "#7201a8"], [0.3333333333333333, "#9c179e"], [0.4444444444444444, "#bd3786"], [0.5555555555555556, "#d8576b"], [0.6666666666666666, "#ed7953"], [0.7777777777777778, "#fb9f3a"], [0.8888888888888888, "#fdca26"], [1.0, "#f0f921"]],
			"type": "heatmapgl"
		}],
		"heatmap": [{
			"colorbar": {"outlinewidth": 0, "ticks": ""},
			"colorscale": [[0.0, "#0d0887"], [0.1111111111111111, "#46039f"], [0.2222222222222222, "#7201a8"], [0.3333333333333333, "#9c179e"], [0.4444444444444444, "#bd3786"], [0.5555555555555556, "#d8576b"], [0.6666666666666666, "#ed7953"], [0.7777777777777778, "#fb9f3a"], [0.8888888888888888, "#fdca26"], [1.0, "#f0f921"]],
			"type": "heatmap"
		}],
		"histogram2dcontour": [{
			"colorbar": {"outlinewidth": 0, "ticks": ""},
			"colorscale": [[0.0, "#0d0887"], [0.1111111111111111, "#46039f"], [0.2222222222222222, "#7201a8"], [0.3333333333333333, "#9c179e"], [0.4444444444444444, "#bd3786"], [0.5555555555555556, "#d8576b"], [0.6666666666666666, "#ed7953"], [0.7777777777777778, "#fb9f3a"], [0.8888888888888888, "#fdca26"], [1.0, "#f0f921"]],
			"type": "histogram2dcontour"
		}],
		"histogram2d": [{
			"colorbar": {"outlinewidth": 0, "ticks": ""},
			"colorscale": [[0.0, "#0d0887"], [0.1111111111111111, "#46039f"], [0.2222222222222222, "#7201a8"], [0.3333333333333333, "#9c179e"], [0.4444444444444444, "#bd3786"], [0.5555555555555556, "#d8576b"], [0.6666666666666666, "#ed7953"], [0.7777777777777778, "#fb9f3a"], [0.8888888888888888, "#fdca26"], [1.0, "#f0f921"]],
			"type": "histogram2d"
		}],
		"histogram": [{
			"marker": {"pattern": {"fillmode": "overlay", "size": 10, "solidity": 0.2}},
			"type": "histogram"
		}],
		"mesh3d": [{"colorbar": {"outlinewidth": 0, "ticks": ""}, "type": "mesh3d"}],
		"parcoords": [{"line": {"colorbar": {"outlinewidth": 0, "ticks": ""}}, "type": "parcoords"}],
		"pie": [{"automargin": true, "type": "pie"}],
		"scatter3d": [{
			"line": {"colorbar": {"outlinewidth": 0, "ticks": ""}},
			"marker": {"colorbar": {"outlinewidth": 0, "ticks": ""}},
			"type": "scatter3d"
		}],
		"scattercarpet": [{"marker": {"colorbar": {"outlinewidth": 0, "ticks": ""}}, "type": "scattercarpet"}],
		"scattergeo": [{"marker": {"colorbar": {"outlinewidth": 0, "ticks": ""}}, "type": "scattergeo"}],
		"scattergl": [{"marker": {"colorbar": {"outlinewidth": 0, "ticks": ""}}, "type": "scattergl"}],
		"scattermapbox": [{"marker": {"colorbar": {"outlinewidth": 0, "ticks": ""}}, "type": "scattermapbox"}],
		"scatterpolargl": [{"marker": {"colorbar": {"outlinewidth": 0, "ticks": ""}}, "type": "scatterpolargl"}],
		"scatterpolar": [{"marker": {"colorbar": {"outlinewidth": 0, "ticks": ""}}, "type": "scatterpolar"}],
		"scatter": [{"fillpattern": {"fillmode": "overlay", "size": 10, "solidity": 0.2}, "type": "scatter"}],
		"scatterternary": [{"marker": {"colorbar": {"outlinewidth": 0, "ticks": ""}}, "type": "scatterternary"}],
		"surface": [{
			"colorbar": {"outlinewidth": 0, "ticks": ""},
			"colorscale": [[0.0, "#0d0887"], [0.1111111111111111, "#46039f"], [0.2222222222222222, "#7201a8"], [0.3333333333333333, "#9c179e"], [0.4444444444444444, "#bd3786"], [0.5555555555555556, "#d8576b"], [0.6666666666666666, "#ed7953"], [0.7777777777777778, "#fb9f3a"], [0.8888888888888888, "#fdca26"], [1.0, "#f0f921"]],
			"type": "surface"
		}],
		"table": [{
			"cells": {"fill": {"color": "#EBF0F8"}, "line": {"color": "white"}},
			"header": {"fill": {"color": "#C8D4E3"}, "line": {"color": "white"}},
			"type": "table"
		}]
	}, "layout": {
		"annotationdefaults": {"arrowcolor": "#2a3f5f", "arrowhead": 0, "arrowwidth": 1},
		"autotypenumbers": "strict",
		"coloraxis": {"colorbar": {"outlinewidth": 0, "ticks": ""}},
		"colorscale": {
			"diverging": [[0, "#8e0152"], [0.1, "#c51b7d"], [0.2, "#de77ae"], [0.3, "#f1b6da"], [0.4, "#fde0ef"], [0.5, "#f7f7f7"], [0.6, "#e6f5d0"], [0.7, "#b8e186"], [0.8, "#7fbc41"], [0.9, "#4d9221"], [1, "#276419"]],
			"sequential": [[0.0, "#0d0887"], [0.1111111111111111, "#46039f"], [0.2222222222222222, "#7201a8"], [0.3333333333333333, "#9c179e"], [0.4444444444444444, "#bd3786"], [0.5555555555555556, "#d8576b"], [0.6666666666666666, "#ed7953"], [0.7777777777777778, "#fb9f3a"], [0.8888888888888888, "#fdca26"], [1.0, "#f0f921"]],
			"sequentialminus": [[0.0, "#0d0887"], [0.1111111111111111, "#46039f"], [0.2222222222222222, "#7201a8"], [0.3333333333333333, "#9c179e"], [0.4444444444444444, "#bd3786"], [0.5555555555555556, "#d8576b"], [0.6666666666666666, "#ed7953"], [0.7777777777777778, "#fb9f3a"], [0.8888888888888888, "#fdca26"], [1.0, "#f0f921"]]
		},
		"colorway": ["#636efa", "#EF553B", "#00cc96", "#ab63fa", "#FFA15A", "#19d3f3", "#FF6692", "#B6E880", "#FF97FF", "#FECB52"],
		"font": {"color": "#2a3f5f"},
		"geo": {
			"bgcolor": "white",
			"lakecolor": "white",
			"landcolor": "#E5ECF6",
			"showlakes": true,
			"showland": true,
			"subunitcolor": "white"
		},
		"hoverlabel": {"align": "left"},
		"hovermode": "closest",
		"mapbox": {"style": "light"},
		"paper_bgcolor": "white",
		"plot_bgcolor": "#E5ECF6",
		"polar": {
			"angularaxis": {"gridcolor": "white", "linecolor": "white", "ticks": ""},
			"bgcolor": "#E5ECF6",
			"radialaxis": {"gridcolor": "white", "linecolor": "white", "ticks": ""}
		},
		"scene": {
			"xaxis": {
				"backgroundcolor": "#E5ECF6",
				"gridcolor": "white",
				"gridwidth": 2,
				"linecolor": "white",
				"showbackground": true,
				"ticks": "",
				"zerolinecolor": "white"
			},
			"yaxis": {
				"backgroundcolor": "#E5ECF6",
				"gridcolor": "white",
				"gridwidth": 2,
				"linecolor": "white",
				"showbackground": true,
				"ticks": "",
				"zerolinecolor": "white"
			},
			"zaxis": {
				"backgroundcolor": "#E5ECF6",
				"gridcolor": "white",
				"gridwidth": 2,
				"linecolor": "white",
				"showbackground": true,
				"ticks": "",
				"zerolinecolor": "white"
			}
		},
		"shapedefaults": {"line": {"color": "#2a3f5f"}},
		"ternary": {
			"aaxis": {"gridcolor": "white", "linecolor": "white", "ticks": ""},
			"baxis": {"gridcolor": "white", "linecolor": "white", "ticks": ""},
			"bgcolor": "#E5ECF6",
			"caxis": {"gridcolor": "white", "linecolor": "white", "ticks": ""}
		},
		"title": {"x": 0.05},
		"xaxis": {
			"automargin": true,
			"gridcolor": "white",
			"linecolor": "white",
			"ticks": "",
			"title": {"standoff": 15},
			"zerolinecolor": "white",
			"zerolinewidth": 2
		},
		"yaxis": {
			"automargin": true,
			"gridcolor": "white",
			"linecolor": "white",
			"ticks": "",
			"title": {"standoff": 15},
			"zerolinecolor": "white",
			"zerolinewidth": 2
		}
	}
};

// Derives from plotly-dark.
const plotlyTemplatePlotlyDark = {
	"data": {
		"barpolar": [
			{
				"marker": {
					"line": {
						"color": "rgb(17,17,17)",
						"width": 0.5
					},
					"pattern": {
						"fillmode": "overlay",
						"size": 10,
						"solidity": 0.2
					}
				},
				"type": "barpolar"
			}
		],
		"bar": [
			{
				"error_x": {
					"color": "#f2f5fa"
				},
				"error_y": {
					"color": "#f2f5fa"
				},
				"marker": {
					"line": {
						"color": "rgb(17,17,17)",
						"width": 0.5
					},
					"pattern": {
						"fillmode": "overlay",
						"size": 10,
						"solidity": 0.2
					}
				},
				"type": "bar"
			}
		],
		"carpet": [
			{
				"aaxis": {
					"endlinecolor": "#A2B1C6",
					"gridcolor": "#506784",
					"linecolor": "#506784",
					"minorgridcolor": "#506784",
					"startlinecolor": "#A2B1C6"
				},
				"baxis": {
					"endlinecolor": "#A2B1C6",
					"gridcolor": "#506784",
					"linecolor": "#506784",
					"minorgridcolor": "#506784",
					"startlinecolor": "#A2B1C6"
				},
				"type": "carpet"
			}
		],
		"choropleth": [
			{
				"colorbar": {
					"outlinewidth": 0,
					"ticks": ""
				},
				"type": "choropleth"
			}
		],
		"contourcarpet": [
			{
				"colorbar": {
					"outlinewidth": 0,
					"ticks": ""
				},
				"type": "contourcarpet"
			}
		],
		"contour": [
			{
				"colorbar": {
					"outlinewidth": 0,
					"ticks": ""
				},
				"colorscale": [
					[
						0.0,
						"#0d0887"
					],
					[
						0.1111111111111111,
						"#46039f"
					],
					[
						0.2222222222222222,
						"#7201a8"
					],
					[
						0.3333333333333333,
						"#9c179e"
					],
					[
						0.4444444444444444,
						"#bd3786"
					],
					[
						0.5555555555555556,
						"#d8576b"
					],
					[
						0.6666666666666666,
						"#ed7953"
					],
					[
						0.7777777777777778,
						"#fb9f3a"
					],
					[
						0.8888888888888888,
						"#fdca26"
					],
					[
						1.0,
						"#f0f921"
					]
				],
				"type": "contour"
			}
		],
		"heatmapgl": [
			{
				"colorbar": {
					"outlinewidth": 0,
					"ticks": ""
				},
				"colorscale": [
					[
						0.0,
						"#0d0887"
					],
					[
						0.1111111111111111,
						"#46039f"
					],
					[
						0.2222222222222222,
						"#7201a8"
					],
					[
						0.3333333333333333,
						"#9c179e"
					],
					[
						0.4444444444444444,
						"#bd3786"
					],
					[
						0.5555555555555556,
						"#d8576b"
					],
					[
						0.6666666666666666,
						"#ed7953"
					],
					[
						0.7777777777777778,
						"#fb9f3a"
					],
					[
						0.8888888888888888,
						"#fdca26"
					],
					[
						1.0,
						"#f0f921"
					]
				],
				"type": "heatmapgl"
			}
		],
		"heatmap": [
			{
				"colorbar": {
					"outlinewidth": 0,
					"ticks": ""
				},
				"colorscale": [
					[
						0.0,
						"#0d0887"
					],
					[
						0.1111111111111111,
						"#46039f"
					],
					[
						0.2222222222222222,
						"#7201a8"
					],
					[
						0.3333333333333333,
						"#9c179e"
					],
					[
						0.4444444444444444,
						"#bd3786"
					],
					[
						0.5555555555555556,
						"#d8576b"
					],
					[
						0.6666666666666666,
						"#ed7953"
					],
					[
						0.7777777777777778,
						"#fb9f3a"
					],
					[
						0.8888888888888888,
						"#fdca26"
					],
					[
						1.0,
						"#f0f921"
					]
				],
				"type": "heatmap"
			}
		],
		"histogram2dcontour": [
			{
				"colorbar": {
					"outlinewidth": 0,
					"ticks": ""
				},
				"colorscale": [
					[
						0.0,
						"#0d0887"
					],
					[
						0.1111111111111111,
						"#46039f"
					],
					[
						0.2222222222222222,
						"#7201a8"
					],
					[
						0.3333333333333333,
						"#9c179e"
					],
					[
						0.4444444444444444,
						"#bd3786"
					],
					[
						0.5555555555555556,
						"#d8576b"
					],
					[
						0.6666666666666666,
						"#ed7953"
					],
					[
						0.7777777777777778,
						"#fb9f3a"
					],
					[
						0.8888888888888888,
						"#fdca26"
					],
					[
						1.0,
						"#f0f921"
					]
				],
				"type": "histogram2dcontour"
			}
		],
		"histogram2d": [
			{
				"colorbar": {
					"outlinewidth": 0,
					"ticks": ""
				},
				"colorscale": [
					[
						0.0,
						"#0d0887"
					],
					[
						0.1111111111111111,
						"#46039f"
					],
					[
						0.2222222222222222,
						"#7201a8"
					],
					[
						0.3333333333333333,
						"#9c179e"
					],
					[
						0.4444444444444444,
						"#bd3786"
					],
					[
						0.5555555555555556,
						"#d8576b"
					],
					[
						0.6666666666666666,
						"#ed7953"
					],
					[
						0.7777777777777778,
						"#fb9f3a"
					],
					[
						0.8888888888888888,
						"#fdca26"
					],
					[
						1.0,
						"#f0f921"
					]
				],
				"type": "histogram2d"
			}
		],
		"histogram": [
			{
				"marker": {
					"pattern": {
						"fillmode": "overlay",
						"size": 10,
						"solidity": 0.2
					}
				},
				"type": "histogram"
			}
		],
		"mesh3d": [
			{
				"colorbar": {
					"outlinewidth": 0,
					"ticks": ""
				},
				"type": "mesh3d"
			}
		],
		"parcoords": [
			{
				"line": {
					"colorbar": {
						"outlinewidth": 0,
						"ticks": ""
					}
				},
				"type": "parcoords"
			}
		],
		"pie": [
			{
				"automargin": true,
				"type": "pie"
			}
		],
		"scatter3d": [
			{
				"line": {
					"colorbar": {
						"outlinewidth": 0,
						"ticks": ""
					}
				},
				"marker": {
					"colorbar": {
						"outlinewidth": 0,
						"ticks": ""
					}
				},
				"type": "scatter3d"
			}
		],
		"scattercarpet": [
			{
				"marker": {
					"colorbar": {
						"outlinewidth": 0,
						"ticks": ""
					}
				},
				"type": "scattercarpet"
			}
		],
		"scattergeo": [
			{
				"marker": {
					"colorbar": {
						"outlinewidth": 0,
						"ticks": ""
					}
				},
				"type": "scattergeo"
			}
		],
		"scattergl": [
			{
				"marker": {
					"line": {
						"color": "#283442"
					}
				},
				"type": "scattergl"
			}
		],
		"scattermapbox": [
			{
				"marker": {
					"colorbar": {
						"outlinewidth": 0,
						"ticks": ""
					}
				},
				"type": "scattermapbox"
			}
		],
		"scatterpolargl": [
			{
				"marker": {
					"colorbar": {
						"outlinewidth": 0,
						"ticks": ""
					}
				},
				"type": "scatterpolargl"
			}
		],
		"scatterpolar": [
			{
				"marker": {
					"colorbar": {
						"outlinewidth": 0,
						"ticks": ""
					}
				},
				"type": "scatterpolar"
			}
		],
		"scatter": [
			{
				"marker": {
					"line": {
						"color": "#283442"
					}
				},
				"type": "scatter"
			}
		],
		"scatterternary": [
			{
				"marker": {
					"colorbar": {
						"outlinewidth": 0,
						"ticks": ""
					}
				},
				"type": "scatterternary"
			}
		],
		"surface": [
			{
				"colorbar": {
					"outlinewidth": 0,
					"ticks": ""
				},
				"colorscale": [
					[
						0.0,
						"#0d0887"
					],
					[
						0.1111111111111111,
						"#46039f"
					],
					[
						0.2222222222222222,
						"#7201a8"
					],
					[
						0.3333333333333333,
						"#9c179e"
					],
					[
						0.4444444444444444,
						"#bd3786"
					],
					[
						0.5555555555555556,
						"#d8576b"
					],
					[
						0.6666666666666666,
						"#ed7953"
					],
					[
						0.7777777777777778,
						"#fb9f3a"
					],
					[
						0.8888888888888888,
						"#fdca26"
					],
					[
						1.0,
						"#f0f921"
					]
				],
				"type": "surface"
			}
		],
		"table": [
			{
				"cells": {
					"fill": {
						"color": "#506784"
					},
					"line": {
						"color": "rgb(17,17,17)"
					}
				},
				"header": {
					"fill": {
						"color": "#2a3f5f"
					},
					"line": {
						"color": "rgb(17,17,17)"
					}
				},
				"type": "table"
			}
		]
	},
	"layout": {
		"annotationdefaults": {
			"arrowcolor": "#f2f5fa",
			"arrowhead": 0,
			"arrowwidth": 1
		},
		"autotypenumbers": "strict",
		"coloraxis": {
			"colorbar": {
				"outlinewidth": 0,
				"ticks": ""
			}
		},
		"colorscale": {
			"diverging": [
				[
					0,
					"#8e0152"
				],
				[
					0.1,
					"#c51b7d"
				],
				[
					0.2,
					"#de77ae"
				],
				[
					0.3,
					"#f1b6da"
				],
				[
					0.4,
					"#fde0ef"
				],
				[
					0.5,
					"#f7f7f7"
				],
				[
					0.6,
					"#e6f5d0"
				],
				[
					0.7,
					"#b8e186"
				],
				[
					0.8,
					"#7fbc41"
				],
				[
					0.9,
					"#4d9221"
				],
				[
					1,
					"#276419"
				]
			],
			"sequential": [
				[
					0.0,
					"#0d0887"
				],
				[
					0.1111111111111111,
					"#46039f"
				],
				[
					0.2222222222222222,
					"#7201a8"
				],
				[
					0.3333333333333333,
					"#9c179e"
				],
				[
					0.4444444444444444,
					"#bd3786"
				],
				[
					0.5555555555555556,
					"#d8576b"
				],
				[
					0.6666666666666666,
					"#ed7953"
				],
				[
					0.7777777777777778,
					"#fb9f3a"
				],
				[
					0.8888888888888888,
					"#fdca26"
				],
				[
					1.0,
					"#f0f921"
				]
			],
			"sequentialminus": [
				[
					0.0,
					"#0d0887"
				],
				[
					0.1111111111111111,
					"#46039f"
				],
				[
					0.2222222222222222,
					"#7201a8"
				],
				[
					0.3333333333333333,
					"#9c179e"
				],
				[
					0.4444444444444444,
					"#bd3786"
				],
				[
					0.5555555555555556,
					"#d8576b"
				],
				[
					0.6666666666666666,
					"#ed7953"
				],
				[
					0.7777777777777778,
					"#fb9f3a"
				],
				[
					0.8888888888888888,
					"#fdca26"
				],
				[
					1.0,
					"#f0f921"
				]
			]
		},
		"colorway": [
			"#636efa",
			"#EF553B",
			"#00cc96",
			"#ab63fa",
			"#FFA15A",
			"#19d3f3",
			"#FF6692",
			"#B6E880",
			"#FF97FF",
			"#FECB52"
		],
		"font": {
			"color": "#f2f5fa"
		},
		"geo": {
			"bgcolor": "rgb(17,17,17)",
			"lakecolor": "rgb(17,17,17)",
			"landcolor": "rgb(17,17,17)",
			"showlakes": true,
			"showland": true,
			"subunitcolor": "#506784"
		},
		"hoverlabel": {
			"align": "left"
		},
		"hovermode": "closest",
		"mapbox": {
			"style": "dark"
		},
		"paper_bgcolor": "rgb(17,17,17)",
		"plot_bgcolor": "rgb(17,17,17)",
		"polar": {
			"angularaxis": {
				"gridcolor": "#506784",
				"linecolor": "#506784",
				"ticks": ""
			},
			"bgcolor": "rgb(17,17,17)",
			"radialaxis": {
				"gridcolor": "#506784",
				"linecolor": "#506784",
				"ticks": ""
			}
		},
		"scene": {
			"xaxis": {
				"backgroundcolor": "rgb(17,17,17)",
				"gridcolor": "#506784",
				"gridwidth": 2,
				"linecolor": "#506784",
				"showbackground": true,
				"ticks": "",
				"zerolinecolor": "#C8D4E3"
			},
			"yaxis": {
				"backgroundcolor": "rgb(17,17,17)",
				"gridcolor": "#506784",
				"gridwidth": 2,
				"linecolor": "#506784",
				"showbackground": true,
				"ticks": "",
				"zerolinecolor": "#C8D4E3"
			},
			"zaxis": {
				"backgroundcolor": "rgb(17,17,17)",
				"gridcolor": "#506784",
				"gridwidth": 2,
				"linecolor": "#506784",
				"showbackground": true,
				"ticks": "",
				"zerolinecolor": "#C8D4E3"
			}
		},
		"shapedefaults": {
			"line": {
				"color": "#f2f5fa"
			}
		},
		"sliderdefaults": {
			"bgcolor": "#C8D4E3",
			"bordercolor": "rgb(17,17,17)",
			"borderwidth": 1,
			"tickwidth": 0
		},
		"ternary": {
			"aaxis": {
				"gridcolor": "#506784",
				"linecolor": "#506784",
				"ticks": ""
			},
			"baxis": {
				"gridcolor": "#506784",
				"linecolor": "#506784",
				"ticks": ""
			},
			"bgcolor": "rgb(17,17,17)",
			"caxis": {
				"gridcolor": "#506784",
				"linecolor": "#506784",
				"ticks": ""
			}
		},
		// "title": {
		// 	"x": 0.05
		// },
		"updatemenudefaults": {
			"bgcolor": "#506784",
			"borderwidth": 0
		},
		"xaxis": {
			"automargin": true,
			"gridcolor": "#283442",
			"linecolor": "#506784",
			"ticks": "",
			// "title": {
			// 	"standoff": 15
			// },
			"zerolinecolor": "#283442",
			"zerolinewidth": 2
		},
		"yaxis": {
			"automargin": true,
			"gridcolor": "#283442",
			"linecolor": "#506784",
			"ticks": "",
			"title": {
				"standoff": 15
			},
			"zerolinecolor": "#283442",
			"zerolinewidth": 2
		}
	}
};


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

	const totalBenchmarkCount = allBenchmarks.length;
	// Get list all series and fill it in.
	allBenchmarks.forEach((benchmark, index) => {
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
					series.set(path, Array(totalBenchmarkCount).fill(null));
				}
				series.get(path)[index] = value;
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
		let median = values[Math.floor(values.length / 2)];

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

	const prefersDark = (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches);
	const currentTemplate = prefersDark ? plotlyTemplatePlotlyDark : plotlyTemplatePlotly;

	let plotlySeries = [];
	if (type === "compact") {
		// Combine all into a single, averaged serie.
		const outputMedian = [];

		const outputLowerIQR = [];
		const outputUpperIQR = [];
		const outputMin = [];
		const outputMax = [];

		for (let i = 0; i < allBenchmarks.length; i++) {
			const values = [];

			// Collect non-null values for the current index
			series.forEach((serie) => {
				if (serie[i] != null) {
					values.push(serie[i]);
				}
			});

			if (values.length > 0) {
				// Sort values to calculate median and IQR
				values.sort((a, b) => a - b);
				const mid = Math.floor(values.length / 2);

				// Calculate median
				const median = values.length % 2 !== 0 ? values[mid] : (values[mid - 1] + values[mid]) / 2;
				outputMedian.push(median);

				// Calculate IQR
				const q1 = values[Math.floor((values.length / 4))];
				const q3 = values[Math.floor((3 * values.length) / 4)];
				outputLowerIQR.push(q1);
				outputUpperIQR.push(q3);

				// Min / Max
				outputMin.push(values[0]);
				outputMax.push(values.slice(-1)[0]);
			} else {
				// Handle case of no data for the point
				outputMedian.push(null);
				outputLowerIQR.push(null);
				outputUpperIQR.push(null);
				outputMin.push(null);
				outputMax.push(null);
			}
		}

		// Detect whether we went down or not on the last 10 benchmarks.
		const lastElementsCount = 3;
		const totalConsideredCount = 10;
		const lastElements = outputMedian.slice(-lastElementsCount);
		const comparedTo = outputMedian.slice(
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

		// Plot the interquartile range as a filled background.
		plotlySeries.push({
			x: xAxis.concat(xAxis.slice().reverse()), // x for upper followed by reversed x for lower
			y: outputUpperIQR.concat(outputLowerIQR.slice().reverse()), // y for upper followed by lower in reverse
			fill: 'toself',
			fillcolor: 'rgba(0,100,80,0.35)',
			line: {color: 'rgba(255,255,255,0)'},
			showlegend: false,
			hoverinfo: "none",
		}, {
			x: xAxis.concat(xAxis.slice().reverse()), // x for upper followed by reversed x for lower
			y: outputMax.concat(outputMin.slice().reverse()), // y for upper followed by lower in reverse
			fill: 'toself',
			fillcolor: 'rgba(0,100,80,0.2)',
			line: {color: 'rgba(255,255,255,0)'},
			showlegend: false,
			hoverinfo: "none",
		});

		// Plot the median.
		plotlySeries.push({
			x: xAxis,
			y: outputMedian,
			hovertext: Array.from(commits.map(commit => commit)),
			type: 'scatter',
			mode: 'lines',
			hoverinfo:"x+y+text",
			name: "Median",
			line: {
				color: customColor || "#4ecdc4",
			},
		});
	}
	else {
		// Sort by name such that each group has the full range of colors if need be.
		const seriesArray = [...series.entries()].sort((a, b) => a[0].localeCompare(b[0]));
		for (let i = 0; i < seriesArray.length; i++) {
			const [name, values] = seriesArray[i];
			const groupIndex = name.indexOf("/");
			const groupName = name.slice(0, groupIndex);

			plotlySeries.push({
				x: xAxis,
				y: values,
				hovertext: Array.from(commits.map(commit => commit + "<br>" + name)),
				type: 'scatter',
				mode: 'lines',
				hoverinfo:"x+y+text",
				name: name.slice(groupIndex + 1),
				legendgroup: groupName,
				legendgrouptitle: { text: groupName },
			})
		}
	}

	var layout = {
		title: '',
		plot_bgcolor: "var(--background)",
		paper_bgcolor: "var(--background)",
		font: {
			color: "var(--text-bright)"
		},
		xaxis: {
			type: 'date',
			showticklabels: type !== "compact",
		},
		yaxis: {
			type: "log",
			nticks: type === "compact" ? 4 : 8,
			range: type === "compact" ? [Math.log(0.4) / Math.log(10), Math.log(2.5) / Math.log(10)]
			: [Math.log(0.2) / Math.log(10), Math.log(5) / Math.log(10)],
			tickformat: '.2f'
		},
		showlegend: type !== 'compact',
		legend: {
			groupclick:"toggleitem",
		},
		hovermode: 'closest',
		transition: {
			duration: 0,
		},
		margin: {
			l: 10,
			r: 10,
			b: 10,
			t: 10,
			pad: 4
		},
		height: type === "compact" ? 150 : 500,
		template: currentTemplate,
		shapes: Object.entries(godotReleaseDates).map(([date, name]) => ({
			name,
			type: 'line',
			x0: date,
			y0: 0,
			x1: date,
			yref: 'paper',
			y1: 1,
			line: {
				color: 'grey',
				width: type === "compact" ? 1.0 : 1.5,
				dash: 'dot'
			}
		})),
		annotations: Object.entries(godotReleaseDates).map(([date, name]) => ({
			xanchor: 'right',
			x: date,
			y: 1,
			yref: 'paper',
			text: name + " ",
			showarrow: false,
		}))
	};

	// Initialize Plotly.js plot
	var targetDiv = document.querySelector(targetDivID);
	Plotly.newPlot(targetDiv, plotlySeries, layout);

	// Handle tooltip formatting
	// targetDiv.on('plotly_hover', function (data) {
	// 	var infotext = data.points.map(function (d) {
	// 		const commit = commits[d.pointIndex];
	// 		return (new Date(d.x)).toISOString().substring(0, 10) + " (" + commit + ")";
	// 	});
	//
	// 	Plotly.Fx.hover(targetDiv, {
	// 		text: infotext
	// 	});
	// });
}
