
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "streamanalytics-outputs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OutputsListByStreamingJob_567879 = ref object of OpenApiRestCall_567657
proc url_OutputsListByStreamingJob_567881(protocol: Scheme; host: string;
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

proc validate_OutputsListByStreamingJob_567880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the outputs under the specified streaming job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568055 = path.getOrDefault("resourceGroupName")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "resourceGroupName", valid_568055
  var valid_568056 = path.getOrDefault("subscriptionId")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "subscriptionId", valid_568056
  var valid_568057 = path.getOrDefault("jobName")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "jobName", valid_568057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : The $select OData query parameter. This is a comma-separated list of structural properties to include in the response, or "*" to include all properties. By default, all properties are returned except diagnostics. Currently only accepts '*' as a valid value.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568058 = query.getOrDefault("api-version")
  valid_568058 = validateParameter(valid_568058, JString, required = true,
                                 default = nil)
  if valid_568058 != nil:
    section.add "api-version", valid_568058
  var valid_568059 = query.getOrDefault("$select")
  valid_568059 = validateParameter(valid_568059, JString, required = false,
                                 default = nil)
  if valid_568059 != nil:
    section.add "$select", valid_568059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568082: Call_OutputsListByStreamingJob_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the outputs under the specified streaming job.
  ## 
  let valid = call_568082.validator(path, query, header, formData, body)
  let scheme = call_568082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568082.url(scheme.get, call_568082.host, call_568082.base,
                         call_568082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568082, url, valid)

proc call*(call_568153: Call_OutputsListByStreamingJob_567879;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; Select: string = ""): Recallable =
  ## outputsListByStreamingJob
  ## Lists all of the outputs under the specified streaming job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  ##   Select: string
  ##         : The $select OData query parameter. This is a comma-separated list of structural properties to include in the response, or "*" to include all properties. By default, all properties are returned except diagnostics. Currently only accepts '*' as a valid value.
  var path_568154 = newJObject()
  var query_568156 = newJObject()
  add(path_568154, "resourceGroupName", newJString(resourceGroupName))
  add(query_568156, "api-version", newJString(apiVersion))
  add(path_568154, "subscriptionId", newJString(subscriptionId))
  add(path_568154, "jobName", newJString(jobName))
  add(query_568156, "$select", newJString(Select))
  result = call_568153.call(path_568154, query_568156, nil, nil, nil)

var outputsListByStreamingJob* = Call_OutputsListByStreamingJob_567879(
    name: "outputsListByStreamingJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/outputs",
    validator: validate_OutputsListByStreamingJob_567880, base: "",
    url: url_OutputsListByStreamingJob_567881, schemes: {Scheme.Https})
type
  Call_OutputsCreateOrReplace_568207 = ref object of OpenApiRestCall_567657
proc url_OutputsCreateOrReplace_568209(protocol: Scheme; host: string; base: string;
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

proc validate_OutputsCreateOrReplace_568208(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an output or replaces an already existing output under an existing streaming job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  ##   outputName: JString (required)
  ##             : The name of the output.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568227 = path.getOrDefault("resourceGroupName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "resourceGroupName", valid_568227
  var valid_568228 = path.getOrDefault("subscriptionId")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "subscriptionId", valid_568228
  var valid_568229 = path.getOrDefault("jobName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "jobName", valid_568229
  var valid_568230 = path.getOrDefault("outputName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "outputName", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the output. Omit this value to always overwrite the current output. Specify the last-seen ETag value to prevent accidentally overwriting concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new output to be created, but to prevent updating an existing output. Other values will result in a 412 Pre-condition Failed response.
  section = newJObject()
  var valid_568232 = header.getOrDefault("If-Match")
  valid_568232 = validateParameter(valid_568232, JString, required = false,
                                 default = nil)
  if valid_568232 != nil:
    section.add "If-Match", valid_568232
  var valid_568233 = header.getOrDefault("If-None-Match")
  valid_568233 = validateParameter(valid_568233, JString, required = false,
                                 default = nil)
  if valid_568233 != nil:
    section.add "If-None-Match", valid_568233
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

proc call*(call_568235: Call_OutputsCreateOrReplace_568207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an output or replaces an already existing output under an existing streaming job.
  ## 
  let valid = call_568235.validator(path, query, header, formData, body)
  let scheme = call_568235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568235.url(scheme.get, call_568235.host, call_568235.base,
                         call_568235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568235, url, valid)

proc call*(call_568236: Call_OutputsCreateOrReplace_568207;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; output: JsonNode; outputName: string): Recallable =
  ## outputsCreateOrReplace
  ## Creates an output or replaces an already existing output under an existing streaming job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  ##   output: JObject (required)
  ##         : The definition of the output that will be used to create a new output or replace the existing one under the streaming job.
  ##   outputName: string (required)
  ##             : The name of the output.
  var path_568237 = newJObject()
  var query_568238 = newJObject()
  var body_568239 = newJObject()
  add(path_568237, "resourceGroupName", newJString(resourceGroupName))
  add(query_568238, "api-version", newJString(apiVersion))
  add(path_568237, "subscriptionId", newJString(subscriptionId))
  add(path_568237, "jobName", newJString(jobName))
  if output != nil:
    body_568239 = output
  add(path_568237, "outputName", newJString(outputName))
  result = call_568236.call(path_568237, query_568238, nil, nil, body_568239)

var outputsCreateOrReplace* = Call_OutputsCreateOrReplace_568207(
    name: "outputsCreateOrReplace", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/outputs/{outputName}",
    validator: validate_OutputsCreateOrReplace_568208, base: "",
    url: url_OutputsCreateOrReplace_568209, schemes: {Scheme.Https})
type
  Call_OutputsGet_568195 = ref object of OpenApiRestCall_567657
proc url_OutputsGet_568197(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_OutputsGet_568196(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details about the specified output.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  ##   outputName: JString (required)
  ##             : The name of the output.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568198 = path.getOrDefault("resourceGroupName")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "resourceGroupName", valid_568198
  var valid_568199 = path.getOrDefault("subscriptionId")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "subscriptionId", valid_568199
  var valid_568200 = path.getOrDefault("jobName")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "jobName", valid_568200
  var valid_568201 = path.getOrDefault("outputName")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "outputName", valid_568201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568202 = query.getOrDefault("api-version")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "api-version", valid_568202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568203: Call_OutputsGet_568195; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details about the specified output.
  ## 
  let valid = call_568203.validator(path, query, header, formData, body)
  let scheme = call_568203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568203.url(scheme.get, call_568203.host, call_568203.base,
                         call_568203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568203, url, valid)

proc call*(call_568204: Call_OutputsGet_568195; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          outputName: string): Recallable =
  ## outputsGet
  ## Gets details about the specified output.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  ##   outputName: string (required)
  ##             : The name of the output.
  var path_568205 = newJObject()
  var query_568206 = newJObject()
  add(path_568205, "resourceGroupName", newJString(resourceGroupName))
  add(query_568206, "api-version", newJString(apiVersion))
  add(path_568205, "subscriptionId", newJString(subscriptionId))
  add(path_568205, "jobName", newJString(jobName))
  add(path_568205, "outputName", newJString(outputName))
  result = call_568204.call(path_568205, query_568206, nil, nil, nil)

var outputsGet* = Call_OutputsGet_568195(name: "outputsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/outputs/{outputName}",
                                      validator: validate_OutputsGet_568196,
                                      base: "", url: url_OutputsGet_568197,
                                      schemes: {Scheme.Https})
type
  Call_OutputsUpdate_568252 = ref object of OpenApiRestCall_567657
proc url_OutputsUpdate_568254(protocol: Scheme; host: string; base: string;
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

proc validate_OutputsUpdate_568253(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing output under an existing streaming job. This can be used to partially update (ie. update one or two properties) an output without affecting the rest the job or output definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  ##   outputName: JString (required)
  ##             : The name of the output.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("subscriptionId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "subscriptionId", valid_568256
  var valid_568257 = path.getOrDefault("jobName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "jobName", valid_568257
  var valid_568258 = path.getOrDefault("outputName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "outputName", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the output. Omit this value to always overwrite the current output. Specify the last-seen ETag value to prevent accidentally overwriting concurrent changes.
  section = newJObject()
  var valid_568260 = header.getOrDefault("If-Match")
  valid_568260 = validateParameter(valid_568260, JString, required = false,
                                 default = nil)
  if valid_568260 != nil:
    section.add "If-Match", valid_568260
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

proc call*(call_568262: Call_OutputsUpdate_568252; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing output under an existing streaming job. This can be used to partially update (ie. update one or two properties) an output without affecting the rest the job or output definition.
  ## 
  let valid = call_568262.validator(path, query, header, formData, body)
  let scheme = call_568262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568262.url(scheme.get, call_568262.host, call_568262.base,
                         call_568262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568262, url, valid)

proc call*(call_568263: Call_OutputsUpdate_568252; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          output: JsonNode; outputName: string): Recallable =
  ## outputsUpdate
  ## Updates an existing output under an existing streaming job. This can be used to partially update (ie. update one or two properties) an output without affecting the rest the job or output definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  ##   output: JObject (required)
  ##         : An Output object. The properties specified here will overwrite the corresponding properties in the existing output (ie. Those properties will be updated). Any properties that are set to null here will mean that the corresponding property in the existing output will remain the same and not change as a result of this PATCH operation.
  ##   outputName: string (required)
  ##             : The name of the output.
  var path_568264 = newJObject()
  var query_568265 = newJObject()
  var body_568266 = newJObject()
  add(path_568264, "resourceGroupName", newJString(resourceGroupName))
  add(query_568265, "api-version", newJString(apiVersion))
  add(path_568264, "subscriptionId", newJString(subscriptionId))
  add(path_568264, "jobName", newJString(jobName))
  if output != nil:
    body_568266 = output
  add(path_568264, "outputName", newJString(outputName))
  result = call_568263.call(path_568264, query_568265, nil, nil, body_568266)

var outputsUpdate* = Call_OutputsUpdate_568252(name: "outputsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/outputs/{outputName}",
    validator: validate_OutputsUpdate_568253, base: "", url: url_OutputsUpdate_568254,
    schemes: {Scheme.Https})
type
  Call_OutputsDelete_568240 = ref object of OpenApiRestCall_567657
proc url_OutputsDelete_568242(protocol: Scheme; host: string; base: string;
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

proc validate_OutputsDelete_568241(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an output from the streaming job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  ##   outputName: JString (required)
  ##             : The name of the output.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568243 = path.getOrDefault("resourceGroupName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "resourceGroupName", valid_568243
  var valid_568244 = path.getOrDefault("subscriptionId")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "subscriptionId", valid_568244
  var valid_568245 = path.getOrDefault("jobName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "jobName", valid_568245
  var valid_568246 = path.getOrDefault("outputName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "outputName", valid_568246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568247 = query.getOrDefault("api-version")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "api-version", valid_568247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568248: Call_OutputsDelete_568240; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an output from the streaming job.
  ## 
  let valid = call_568248.validator(path, query, header, formData, body)
  let scheme = call_568248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568248.url(scheme.get, call_568248.host, call_568248.base,
                         call_568248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568248, url, valid)

proc call*(call_568249: Call_OutputsDelete_568240; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          outputName: string): Recallable =
  ## outputsDelete
  ## Deletes an output from the streaming job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  ##   outputName: string (required)
  ##             : The name of the output.
  var path_568250 = newJObject()
  var query_568251 = newJObject()
  add(path_568250, "resourceGroupName", newJString(resourceGroupName))
  add(query_568251, "api-version", newJString(apiVersion))
  add(path_568250, "subscriptionId", newJString(subscriptionId))
  add(path_568250, "jobName", newJString(jobName))
  add(path_568250, "outputName", newJString(outputName))
  result = call_568249.call(path_568250, query_568251, nil, nil, nil)

var outputsDelete* = Call_OutputsDelete_568240(name: "outputsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/outputs/{outputName}",
    validator: validate_OutputsDelete_568241, base: "", url: url_OutputsDelete_568242,
    schemes: {Scheme.Https})
type
  Call_OutputsTest_568267 = ref object of OpenApiRestCall_567657
proc url_OutputsTest_568269(protocol: Scheme; host: string; base: string;
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

proc validate_OutputsTest_568268(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Tests whether an output’s datasource is reachable and usable by the Azure Stream Analytics service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  ##   outputName: JString (required)
  ##             : The name of the output.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568270 = path.getOrDefault("resourceGroupName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "resourceGroupName", valid_568270
  var valid_568271 = path.getOrDefault("subscriptionId")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "subscriptionId", valid_568271
  var valid_568272 = path.getOrDefault("jobName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "jobName", valid_568272
  var valid_568273 = path.getOrDefault("outputName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "outputName", valid_568273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568274 = query.getOrDefault("api-version")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "api-version", valid_568274
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

proc call*(call_568276: Call_OutputsTest_568267; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Tests whether an output’s datasource is reachable and usable by the Azure Stream Analytics service.
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_OutputsTest_568267; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          outputName: string; output: JsonNode = nil): Recallable =
  ## outputsTest
  ## Tests whether an output’s datasource is reachable and usable by the Azure Stream Analytics service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  ##   output: JObject
  ##         : If the output specified does not already exist, this parameter must contain the full output definition intended to be tested. If the output specified already exists, this parameter can be left null to test the existing output as is or if specified, the properties specified will overwrite the corresponding properties in the existing output (exactly like a PATCH operation) and the resulting output will be tested.
  ##   outputName: string (required)
  ##             : The name of the output.
  var path_568278 = newJObject()
  var query_568279 = newJObject()
  var body_568280 = newJObject()
  add(path_568278, "resourceGroupName", newJString(resourceGroupName))
  add(query_568279, "api-version", newJString(apiVersion))
  add(path_568278, "subscriptionId", newJString(subscriptionId))
  add(path_568278, "jobName", newJString(jobName))
  if output != nil:
    body_568280 = output
  add(path_568278, "outputName", newJString(outputName))
  result = call_568277.call(path_568278, query_568279, nil, nil, body_568280)

var outputsTest* = Call_OutputsTest_568267(name: "outputsTest",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/outputs/{outputName}/test",
                                        validator: validate_OutputsTest_568268,
                                        base: "", url: url_OutputsTest_568269,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
