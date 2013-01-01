Base = require '../lib/base'

class CloudWatch extends Base

  constructor: (@namespace, @instanceID) ->

  post: (metricName, unit, value, cbErr, cbSuccess) ->

    params = 
       Namespace: @namepsace
      'MetricData.member.1.MetricName': metricName
      'MetricData.member.1.Unit': unit
      'MetricData.member.1.Value': value
      'MetricData.member.1.Dimensions.member.1.Name': 'InstanceID'
      'MetricData.member.1.Dimensions.member.1.Value': @instanceID

    try
      @cloudwatch.request 'PutMetricData', params, (response) ->
        cbSuccess response
    catch err
      cbErr err

module.exports = CloudWatch