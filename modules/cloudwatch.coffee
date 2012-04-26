fs = require 'fs' 
cloudwatchApi = require 'node-cloudwatch'

Module = {}

class Cloudwatch 

  constructor: (utilities) ->

    Module = this
    Module.utilities = utilities  
    Module.cloudwatchApi = new cloudwatchApi.AmazonCloudwatchClient()

  post: (metricName, unit, value) ->
   
    params = 
      Namespace: utilities.getCloudwatchNamespace
      'MetricData.member.1.MetricName': metricName
      'MetricData.member.1.Unit': unit
      'MetricData.member.1.Value': value
      'MetricData.member.1.Dimensions.member.1.Name': 'InstanceID'
      'MetricData.member.1.Dimensions.member.1.Value': utilities.getInstanceId
 
    console.log 'Cloudwatch Namespace: ' + Module.utilities.getCloudwatchNamespace
    console.log 'InstanceId: ' + Module.utilities.getInstanceId
    console.log 'MetricName: ' + metricName
    console.log 'Unit: ' + unit
    console.log 'Value: '+ value
  
    # Always want to log what would be submitted to the CloudWatch API
    return unless Module.utilities.isCloudwatchEnabled is true
  
    try
      Module.cloudwatchApi.request 'PutMetricData', params, (response) ->
      
        console.log 'CloudWatch response: ' + response.toString
      
    catch error
      console.log 'CloudWatch API error: ' + error
 
exports.Cloudwatch = Cloudwatch