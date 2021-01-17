$(document).on('turbolinks:load', function() {
  var ctx = document.getElementById('bar_chart').getContext('2d');
  var chart = new Chart(ctx, {
      // The type of chart we want to create
    type: 'bar',

    // The data for our dataset
    data: {
        labels: ['iteration 1'],
        datasets: [{
            label: '',
            backgroundColor: 'blue',
            borderColor: 'blue',
            data: [parseInt($('#bar_chart').data('time'))],
            borderSkipped: 'bottom'
        }]
    },

    // Configuration options go here
    options: {
      scales: {
        yAxes: [{
          scaleLabel: {
            display: true,
            labelString: 'Time (S)',
            fontSize: '20'
          },
          ticks: {
            beginAtZero: true,
            fontSize: '20',
            suggestedMax: $('#bar_chart').data('max')
          }
        }],
        xAxes: [{
          scaleLabel: {
            display: true,
            labelString: 'Iterations',
            fontSize: '20'
          },
          ticks: {
            beginAtZero: true,
            fontSize: '20'
          }
        }]
      },
      legend: {
        display: false
      },
      tooltips: {
        callbacks: {
          label: function(tooltipItem) {
            return tooltipItem.yLabel;
          }
        }
      }
    }
  });
})