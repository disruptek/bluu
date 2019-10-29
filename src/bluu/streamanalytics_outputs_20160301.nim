
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: StreamAnalyticsManagementClient
## version: 2016-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "streamanalytics-outputs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OutputsListByStreamingJob_563777 = ref object of OpenApiRestCall_563555
proc url_OutputsListByStreamingJob_563779(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/outputs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OutputsListByStreamingJob_563778(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the outputs under the specified streaming job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  var valid_563956 = path.getOrDefault("resourceGroupName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "resourceGroupName", valid_563956
  var valid_563957 = path.getOrDefault("jobName")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "jobName", valid_563957
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : The $select OData query parameter. This is a comma-separated list of structural properties to include in the response, or "*" to include all properties. By default, all properties are returned except diagnostics. Currently only accepts '*' as a valid value.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563958 = query.getOrDefault("api-version")
  valid_563958 = validateParameter(valid_563958, JString, required = true,
                                 default = nil)
  if valid_563958 != nil:
    section.add "api-version", valid_563958
  var valid_563959 = query.getOrDefault("$select")
  valid_563959 = validateParameter(valid_563959, JString, required = false,
                                 default = nil)
  if valid_563959 != nil:
    section.add "$select", valid_563959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563982: Call_OutputsListByStreamingJob_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the outputs under the specified streaming job.
  ## 
  let valid = call_563982.validator(path, query, header, formData, body)
  let scheme = call_563982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563982.url(scheme.get, call_563982.host, call_563982.base,
                         call_563982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563982, url, valid)

proc call*(call_564053: Call_OutputsListByStreamingJob_563777; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; jobName: string;
          Select: string = ""): Recallable =
  ## outputsListByStreamingJob
  ## Lists all of the outputs under the specified streaming job.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : The $select OData query parameter. This is a comma-separated list of structural properties to include in the response, or "*" to include all properties. By default, all properties are returned except diagnostics. Currently only accepts '*' as a valid value.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_564054 = newJObject()
  var query_564056 = newJObject()
  add(query_564056, "api-version", newJString(apiVersion))
  add(query_564056, "$select", newJString(Select))
  add(path_564054, "subscriptionId", newJString(subscriptionId))
  add(path_564054, "resourceGroupName", newJString(resourceGroupName))
  add(path_564054, "jobName", newJString(jobName))
  result = call_564053.call(path_564054, query_564056, nil, nil, nil)

var outputsListByStreamingJob* = Call_OutputsListByStreamingJob_563777(
    name: "outputsListByStreamingJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/outputs",
    validator: validate_OutputsListByStreamingJob_563778, base: "",
    url: url_OutputsListByStreamingJob_563779, schemes: {Scheme.Https})
type
  Call_OutputsCreateOrReplace_564107 = ref object of OpenApiRestCall_563555
proc url_OutputsCreateOrReplace_564109(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "outputName" in path, "`outputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/outputs/"),
               (kind: VariableSegment, value: "outputName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OutputsCreateOrReplace_564108(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an output or replaces an already existing output under an existing streaming job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   outputName: JString (required)
  ##             : The name of the output.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564127 = path.getOrDefault("subscriptionId")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "subscriptionId", valid_564127
  var valid_564128 = path.getOrDefault("outputName")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "outputName", valid_564128
  var valid_564129 = path.getOrDefault("resourceGroupName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "resourceGroupName", valid_564129
  var valid_564130 = path.getOrDefault("jobName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "jobName", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564131 = query.getOrDefault("api-version")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "api-version", valid_564131
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new output to be created, but to prevent updating an existing output. Other values will result in a 412 Pre-condition Failed response.
  ##   If-Match: JString
  ##           : The ETag of the output. Omit this value to always overwrite the current output. Specify the last-seen ETag value to prevent accidentally overwriting concurrent changes.
  section = newJObject()
  var valid_564132 = header.getOrDefault("If-None-Match")
  valid_564132 = validateParameter(valid_564132, JString, required = false,
                                 default = nil)
  if valid_564132 != nil:
    section.add "If-None-Match", valid_564132
  var valid_564133 = header.getOrDefault("If-Match")
  valid_564133 = validateParameter(valid_564133, JString, required = false,
                                 default = nil)
  if valid_564133 != nil:
    section.add "If-Match", valid_564133
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   output: JObject (required)
  ##         : The definition of the output that will be used to create a new output or replace the existing one under the streaming job.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_OutputsCreateOrReplace_564107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an output or replaces an already existing output under an existing streaming job.
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_OutputsCreateOrReplace_564107; apiVersion: string;
          subscriptionId: string; outputName: string; output: JsonNode;
          resourceGroupName: string; jobName: string): Recallable =
  ## outputsCreateOrReplace
  ## Creates an output or replaces an already existing output under an existing streaming job.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   outputName: string (required)
  ##             : The name of the output.
  ##   output: JObject (required)
  ##         : The definition of the output that will be used to create a new output or replace the existing one under the streaming job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  var body_564139 = newJObject()
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  add(path_564137, "outputName", newJString(outputName))
  if output != nil:
    body_564139 = output
  add(path_564137, "resourceGroupName", newJString(resourceGroupName))
  add(path_564137, "jobName", newJString(jobName))
  result = call_564136.call(path_564137, query_564138, nil, nil, body_564139)

var outputsCreateOrReplace* = Call_OutputsCreateOrReplace_564107(
    name: "outputsCreateOrReplace", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/outputs/{outputName}",
    validator: validate_OutputsCreateOrReplace_564108, base: "",
    url: url_OutputsCreateOrReplace_564109, schemes: {Scheme.Https})
type
  Call_OutputsGet_564095 = ref object of OpenApiRestCall_563555
proc url_OutputsGet_564097(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "outputName" in path, "`outputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/outputs/"),
               (kind: VariableSegment, value: "outputName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OutputsGet_564096(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details about the specified output.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   outputName: JString (required)
  ##             : The name of the output.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564098 = path.getOrDefault("subscriptionId")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "subscriptionId", valid_564098
  var valid_564099 = path.getOrDefault("outputName")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "outputName", valid_564099
  var valid_564100 = path.getOrDefault("resourceGroupName")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "resourceGroupName", valid_564100
  var valid_564101 = path.getOrDefault("jobName")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "jobName", valid_564101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564102 = query.getOrDefault("api-version")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "api-version", valid_564102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564103: Call_OutputsGet_564095; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details about the specified output.
  ## 
  let valid = call_564103.validator(path, query, header, formData, body)
  let scheme = call_564103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564103.url(scheme.get, call_564103.host, call_564103.base,
                         call_564103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564103, url, valid)

proc call*(call_564104: Call_OutputsGet_564095; apiVersion: string;
          subscriptionId: string; outputName: string; resourceGroupName: string;
          jobName: string): Recallable =
  ## outputsGet
  ## Gets details about the specified output.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   outputName: string (required)
  ##             : The name of the output.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_564105 = newJObject()
  var query_564106 = newJObject()
  add(query_564106, "api-version", newJString(apiVersion))
  add(path_564105, "subscriptionId", newJString(subscriptionId))
  add(path_564105, "outputName", newJString(outputName))
  add(path_564105, "resourceGroupName", newJString(resourceGroupName))
  add(path_564105, "jobName", newJString(jobName))
  result = call_564104.call(path_564105, query_564106, nil, nil, nil)

var outputsGet* = Call_OutputsGet_564095(name: "outputsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/outputs/{outputName}",
                                      validator: validate_OutputsGet_564096,
                                      base: "", url: url_OutputsGet_564097,
                                      schemes: {Scheme.Https})
type
  Call_OutputsUpdate_564152 = ref object of OpenApiRestCall_563555
proc url_OutputsUpdate_564154(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "outputName" in path, "`outputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/outputs/"),
               (kind: VariableSegment, value: "outputName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OutputsUpdate_564153(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing output under an existing streaming job. This can be used to partially update (ie. update one or two properties) an output without affecting the rest the job or output definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   outputName: JString (required)
  ##             : The name of the output.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564155 = path.getOrDefault("subscriptionId")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "subscriptionId", valid_564155
  var valid_564156 = path.getOrDefault("outputName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "outputName", valid_564156
  var valid_564157 = path.getOrDefault("resourceGroupName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "resourceGroupName", valid_564157
  var valid_564158 = path.getOrDefault("jobName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "jobName", valid_564158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564159 = query.getOrDefault("api-version")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "api-version", valid_564159
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the output. Omit this value to always overwrite the current output. Specify the last-seen ETag value to prevent accidentally overwriting concurrent changes.
  section = newJObject()
  var valid_564160 = header.getOrDefault("If-Match")
  valid_564160 = validateParameter(valid_564160, JString, required = false,
                                 default = nil)
  if valid_564160 != nil:
    section.add "If-Match", valid_564160
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   output: JObject (required)
  ##         : An Output object. The properties specified here will overwrite the corresponding properties in the existing output (ie. Those properties will be updated). Any properties that are set to null here will mean that the corresponding property in the existing output will remain the same and not change as a result of this PATCH operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564162: Call_OutputsUpdate_564152; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing output under an existing streaming job. This can be used to partially update (ie. update one or two properties) an output without affecting the rest the job or output definition.
  ## 
  let valid = call_564162.validator(path, query, header, formData, body)
  let scheme = call_564162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564162.url(scheme.get, call_564162.host, call_564162.base,
                         call_564162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564162, url, valid)

proc call*(call_564163: Call_OutputsUpdate_564152; apiVersion: string;
          subscriptionId: string; outputName: string; output: JsonNode;
          resourceGroupName: string; jobName: string): Recallable =
  ## outputsUpdate
  ## Updates an existing output under an existing streaming job. This can be used to partially update (ie. update one or two properties) an output without affecting the rest the job or output definition.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   outputName: string (required)
  ##             : The name of the output.
  ##   output: JObject (required)
  ##         : An Output object. The properties specified here will overwrite the corresponding properties in the existing output (ie. Those properties will be updated). Any properties that are set to null here will mean that the corresponding property in the existing output will remain the same and not change as a result of this PATCH operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_564164 = newJObject()
  var query_564165 = newJObject()
  var body_564166 = newJObject()
  add(query_564165, "api-version", newJString(apiVersion))
  add(path_564164, "subscriptionId", newJString(subscriptionId))
  add(path_564164, "outputName", newJString(outputName))
  if output != nil:
    body_564166 = output
  add(path_564164, "resourceGroupName", newJString(resourceGroupName))
  add(path_564164, "jobName", newJString(jobName))
  result = call_564163.call(path_564164, query_564165, nil, nil, body_564166)

var outputsUpdate* = Call_OutputsUpdate_564152(name: "outputsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/outputs/{outputName}",
    validator: validate_OutputsUpdate_564153, base: "", url: url_OutputsUpdate_564154,
    schemes: {Scheme.Https})
type
  Call_OutputsDelete_564140 = ref object of OpenApiRestCall_563555
proc url_OutputsDelete_564142(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "outputName" in path, "`outputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/outputs/"),
               (kind: VariableSegment, value: "outputName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OutputsDelete_564141(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an output from the streaming job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   outputName: JString (required)
  ##             : The name of the output.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564143 = path.getOrDefault("subscriptionId")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "subscriptionId", valid_564143
  var valid_564144 = path.getOrDefault("outputName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "outputName", valid_564144
  var valid_564145 = path.getOrDefault("resourceGroupName")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "resourceGroupName", valid_564145
  var valid_564146 = path.getOrDefault("jobName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "jobName", valid_564146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564147 = query.getOrDefault("api-version")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "api-version", valid_564147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564148: Call_OutputsDelete_564140; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an output from the streaming job.
  ## 
  let valid = call_564148.validator(path, query, header, formData, body)
  let scheme = call_564148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564148.url(scheme.get, call_564148.host, call_564148.base,
                         call_564148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564148, url, valid)

proc call*(call_564149: Call_OutputsDelete_564140; apiVersion: string;
          subscriptionId: string; outputName: string; resourceGroupName: string;
          jobName: string): Recallable =
  ## outputsDelete
  ## Deletes an output from the streaming job.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   outputName: string (required)
  ##             : The name of the output.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_564150 = newJObject()
  var query_564151 = newJObject()
  add(query_564151, "api-version", newJString(apiVersion))
  add(path_564150, "subscriptionId", newJString(subscriptionId))
  add(path_564150, "outputName", newJString(outputName))
  add(path_564150, "resourceGroupName", newJString(resourceGroupName))
  add(path_564150, "jobName", newJString(jobName))
  result = call_564149.call(path_564150, query_564151, nil, nil, nil)

var outputsDelete* = Call_OutputsDelete_564140(name: "outputsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/outputs/{outputName}",
    validator: validate_OutputsDelete_564141, base: "", url: url_OutputsDelete_564142,
    schemes: {Scheme.Https})
type
  Call_OutputsTest_564167 = ref object of OpenApiRestCall_563555
proc url_OutputsTest_564169(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "outputName" in path, "`outputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/outputs/"),
               (kind: VariableSegment, value: "outputName"),
               (kind: ConstantSegment, value: "/test")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OutputsTest_564168(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Tests whether an output’s datasource is reachable and usable by the Azure Stream Analytics service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   outputName: JString (required)
  ##             : The name of the output.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564170 = path.getOrDefault("subscriptionId")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "subscriptionId", valid_564170
  var valid_564171 = path.getOrDefault("outputName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "outputName", valid_564171
  var valid_564172 = path.getOrDefault("resourceGroupName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "resourceGroupName", valid_564172
  var valid_564173 = path.getOrDefault("jobName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "jobName", valid_564173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564174 = query.getOrDefault("api-version")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "api-version", valid_564174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   output: JObject
  ##         : If the output specified does not already exist, this parameter must contain the full output definition intended to be tested. If the output specified already exists, this parameter can be left null to test the existing output as is or if specified, the properties specified will overwrite the corresponding properties in the existing output (exactly like a PATCH operation) and the resulting output will be tested.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564176: Call_OutputsTest_564167; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Tests whether an output’s datasource is reachable and usable by the Azure Stream Analytics service.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_OutputsTest_564167; apiVersion: string;
          subscriptionId: string; outputName: string; resourceGroupName: string;
          jobName: string; output: JsonNode = nil): Recallable =
  ## outputsTest
  ## Tests whether an output’s datasource is reachable and usable by the Azure Stream Analytics service.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   outputName: string (required)
  ##             : The name of the output.
  ##   output: JObject
  ##         : If the output specified does not already exist, this parameter must contain the full output definition intended to be tested. If the output specified already exists, this parameter can be left null to test the existing output as is or if specified, the properties specified will overwrite the corresponding properties in the existing output (exactly like a PATCH operation) and the resulting output will be tested.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  var body_564180 = newJObject()
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "subscriptionId", newJString(subscriptionId))
  add(path_564178, "outputName", newJString(outputName))
  if output != nil:
    body_564180 = output
  add(path_564178, "resourceGroupName", newJString(resourceGroupName))
  add(path_564178, "jobName", newJString(jobName))
  result = call_564177.call(path_564178, query_564179, nil, nil, body_564180)

var outputsTest* = Call_OutputsTest_564167(name: "outputsTest",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/outputs/{outputName}/test",
                                        validator: validate_OutputsTest_564168,
                                        base: "", url: url_OutputsTest_564169,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
