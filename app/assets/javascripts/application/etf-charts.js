$(document).ready(function() {
  if( $("#JS-etf-close-prices-chart").length > 0 ) {
    c3.generate({
      bindto: '#JS-etf-close-prices-chart',
      data: {
        x: 'dates',
        type: 'line',
        json: {
          dates: gon.dates,
          "Adjusted Close": gon.close_prices
        }
      },
      axis: {
        x: {
          type: 'timeseries',
          tick: {
            fit: true,
            format: '%Y-%m-%d'
          }
        },
        y: {
          tick: {
            fit: false,
            format: function(val) {
              return '$' + val.toFixed(2);
            }
          },
          label: {
            text: 'Adjusted Close Price',
            position: 'outer-middle'
          }
        }
      },
      legend: {
        show: false
      }
    });
  }
});
