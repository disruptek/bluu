
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
  macServiceName = "streamanalytics-streamingjobs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567879 = ref object of OpenApiRestCall_567657
proc url_OperationsList_567881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567880(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Stream Analytics related operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_OperationsList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Stream Analytics related operations.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_OperationsList_567879; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Stream Analytics related operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var operationsList* = Call_OperationsList_567879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.StreamAnalytics/operations",
    validator: validate_OperationsList_567880, base: "", url: url_OperationsList_567881,
    schemes: {Scheme.Https})
type
  Call_StreamingJobsList_568175 = ref object of OpenApiRestCall_567657
proc url_StreamingJobsList_568177(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingJobsList_568176(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all of the streaming jobs in the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568193 = path.getOrDefault("subscriptionId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "subscriptionId", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand OData query parameter. This is a comma-separated list of additional streaming job properties to include in the response, beyond the default set returned when this parameter is absent. The default set is all streaming job properties other than 'inputs', 'transformation', 'outputs', and 'functions'.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568194 = query.getOrDefault("$expand")
  valid_568194 = validateParameter(valid_568194, JString, required = false,
                                 default = nil)
  if valid_568194 != nil:
    section.add "$expand", valid_568194
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568195 = query.getOrDefault("api-version")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "api-version", valid_568195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568196: Call_StreamingJobsList_568175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the streaming jobs in the given subscription.
  ## 
  let valid = call_568196.validator(path, query, header, formData, body)
  let scheme = call_568196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568196.url(scheme.get, call_568196.host, call_568196.base,
                         call_568196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568196, url, valid)

proc call*(call_568197: Call_StreamingJobsList_568175; apiVersion: string;
          subscriptionId: string; Expand: string = ""): Recallable =
  ## streamingJobsList
  ## Lists all of the streaming jobs in the given subscription.
  ##   Expand: string
  ##         : The $expand OData query parameter. This is a comma-separated list of additional streaming job properties to include in the response, beyond the default set returned when this parameter is absent. The default set is all streaming job properties other than 'inputs', 'transformation', 'outputs', and 'functions'.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568198 = newJObject()
  var query_568199 = newJObject()
  add(query_568199, "$expand", newJString(Expand))
  add(query_568199, "api-version", newJString(apiVersion))
  add(path_568198, "subscriptionId", newJString(subscriptionId))
  result = call_568197.call(path_568198, query_568199, nil, nil, nil)

var streamingJobsList* = Call_StreamingJobsList_568175(name: "streamingJobsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.StreamAnalytics/streamingjobs",
    validator: validate_StreamingJobsList_568176, base: "",
    url: url_StreamingJobsList_568177, schemes: {Scheme.Https})
type
  Call_StreamingJobsListByResourceGroup_568200 = ref object of OpenApiRestCall_567657
proc url_StreamingJobsListByResourceGroup_568202(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingJobsListByResourceGroup_568201(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the streaming jobs in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568203 = path.getOrDefault("resourceGroupName")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "resourceGroupName", valid_568203
  var valid_568204 = path.getOrDefault("subscriptionId")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "subscriptionId", valid_568204
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand OData query parameter. This is a comma-separated list of additional streaming job properties to include in the response, beyond the default set returned when this parameter is absent. The default set is all streaming job properties other than 'inputs', 'transformation', 'outputs', and 'functions'.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568205 = query.getOrDefault("$expand")
  valid_568205 = validateParameter(valid_568205, JString, required = false,
                                 default = nil)
  if valid_568205 != nil:
    section.add "$expand", valid_568205
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568207: Call_StreamingJobsListByResourceGroup_568200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the streaming jobs in the specified resource group.
  ## 
  let valid = call_568207.validator(path, query, header, formData, body)
  let scheme = call_568207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568207.url(scheme.get, call_568207.host, call_568207.base,
                         call_568207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568207, url, valid)

proc call*(call_568208: Call_StreamingJobsListByResourceGroup_568200;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""): Recallable =
  ## streamingJobsListByResourceGroup
  ## Lists all of the streaming jobs in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   Expand: string
  ##         : The $expand OData query parameter. This is a comma-separated list of additional streaming job properties to include in the response, beyond the default set returned when this parameter is absent. The default set is all streaming job properties other than 'inputs', 'transformation', 'outputs', and 'functions'.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568209 = newJObject()
  var query_568210 = newJObject()
  add(path_568209, "resourceGroupName", newJString(resourceGroupName))
  add(query_568210, "$expand", newJString(Expand))
  add(query_568210, "api-version", newJString(apiVersion))
  add(path_568209, "subscriptionId", newJString(subscriptionId))
  result = call_568208.call(path_568209, query_568210, nil, nil, nil)

var streamingJobsListByResourceGroup* = Call_StreamingJobsListByResourceGroup_568200(
    name: "streamingJobsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs",
    validator: validate_StreamingJobsListByResourceGroup_568201, base: "",
    url: url_StreamingJobsListByResourceGroup_568202, schemes: {Scheme.Https})
type
  Call_StreamingJobsCreateOrReplace_568223 = ref object of OpenApiRestCall_567657
proc url_StreamingJobsCreateOrReplace_568225(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingJobsCreateOrReplace_568224(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a streaming job or replaces an already existing streaming job.
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568246 = query.getOrDefault("api-version")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "api-version", valid_568246
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the streaming job. Omit this value to always overwrite the current record set. Specify the last-seen ETag value to prevent accidentally overwriting concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new streaming job to be created, but to prevent updating an existing record set. Other values will result in a 412 Pre-condition Failed response.
  section = newJObject()
  var valid_568247 = header.getOrDefault("If-Match")
  valid_568247 = validateParameter(valid_568247, JString, required = false,
                                 default = nil)
  if valid_568247 != nil:
    section.add "If-Match", valid_568247
  var valid_568248 = header.getOrDefault("If-None-Match")
  valid_568248 = validateParameter(valid_568248, JString, required = false,
                                 default = nil)
  if valid_568248 != nil:
    section.add "If-None-Match", valid_568248
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   streamingJob: JObject (required)
  ##               : The definition of the streaming job that will be used to create a new streaming job or replace the existing one.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568250: Call_StreamingJobsCreateOrReplace_568223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a streaming job or replaces an already existing streaming job.
  ## 
  let valid = call_568250.validator(path, query, header, formData, body)
  let scheme = call_568250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568250.url(scheme.get, call_568250.host, call_568250.base,
                         call_568250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568250, url, valid)

proc call*(call_568251: Call_StreamingJobsCreateOrReplace_568223;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; streamingJob: JsonNode): Recallable =
  ## streamingJobsCreateOrReplace
  ## Creates a streaming job or replaces an already existing streaming job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  ##   streamingJob: JObject (required)
  ##               : The definition of the streaming job that will be used to create a new streaming job or replace the existing one.
  var path_568252 = newJObject()
  var query_568253 = newJObject()
  var body_568254 = newJObject()
  add(path_568252, "resourceGroupName", newJString(resourceGroupName))
  add(query_568253, "api-version", newJString(apiVersion))
  add(path_568252, "subscriptionId", newJString(subscriptionId))
  add(path_568252, "jobName", newJString(jobName))
  if streamingJob != nil:
    body_568254 = streamingJob
  result = call_568251.call(path_568252, query_568253, nil, nil, body_568254)

var streamingJobsCreateOrReplace* = Call_StreamingJobsCreateOrReplace_568223(
    name: "streamingJobsCreateOrReplace", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}",
    validator: validate_StreamingJobsCreateOrReplace_568224, base: "",
    url: url_StreamingJobsCreateOrReplace_568225, schemes: {Scheme.Https})
type
  Call_StreamingJobsGet_568211 = ref object of OpenApiRestCall_567657
proc url_StreamingJobsGet_568213(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingJobsGet_568212(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets details about the specified streaming job.
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
  var valid_568214 = path.getOrDefault("resourceGroupName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "resourceGroupName", valid_568214
  var valid_568215 = path.getOrDefault("subscriptionId")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "subscriptionId", valid_568215
  var valid_568216 = path.getOrDefault("jobName")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "jobName", valid_568216
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand OData query parameter. This is a comma-separated list of additional streaming job properties to include in the response, beyond the default set returned when this parameter is absent. The default set is all streaming job properties other than 'inputs', 'transformation', 'outputs', and 'functions'.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568217 = query.getOrDefault("$expand")
  valid_568217 = validateParameter(valid_568217, JString, required = false,
                                 default = nil)
  if valid_568217 != nil:
    section.add "$expand", valid_568217
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_StreamingJobsGet_568211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details about the specified streaming job.
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_StreamingJobsGet_568211; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          Expand: string = ""): Recallable =
  ## streamingJobsGet
  ## Gets details about the specified streaming job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   Expand: string
  ##         : The $expand OData query parameter. This is a comma-separated list of additional streaming job properties to include in the response, beyond the default set returned when this parameter is absent. The default set is all streaming job properties other than 'inputs', 'transformation', 'outputs', and 'functions'.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(path_568221, "resourceGroupName", newJString(resourceGroupName))
  add(query_568222, "$expand", newJString(Expand))
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "subscriptionId", newJString(subscriptionId))
  add(path_568221, "jobName", newJString(jobName))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var streamingJobsGet* = Call_StreamingJobsGet_568211(name: "streamingJobsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}",
    validator: validate_StreamingJobsGet_568212, base: "",
    url: url_StreamingJobsGet_568213, schemes: {Scheme.Https})
type
  Call_StreamingJobsUpdate_568266 = ref object of OpenApiRestCall_567657
proc url_StreamingJobsUpdate_568268(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingJobsUpdate_568267(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates an existing streaming job. This can be used to partially update (ie. update one or two properties) a streaming job without affecting the rest the job definition.
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
  var valid_568269 = path.getOrDefault("resourceGroupName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "resourceGroupName", valid_568269
  var valid_568270 = path.getOrDefault("subscriptionId")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "subscriptionId", valid_568270
  var valid_568271 = path.getOrDefault("jobName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "jobName", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the streaming job. Omit this value to always overwrite the current record set. Specify the last-seen ETag value to prevent accidentally overwriting concurrent changes.
  section = newJObject()
  var valid_568273 = header.getOrDefault("If-Match")
  valid_568273 = validateParameter(valid_568273, JString, required = false,
                                 default = nil)
  if valid_568273 != nil:
    section.add "If-Match", valid_568273
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   streamingJob: JObject (required)
  ##               : A streaming job object. The properties specified here will overwrite the corresponding properties in the existing streaming job (ie. Those properties will be updated). Any properties that are set to null here will mean that the corresponding property in the existing input will remain the same and not change as a result of this PATCH operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568275: Call_StreamingJobsUpdate_568266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing streaming job. This can be used to partially update (ie. update one or two properties) a streaming job without affecting the rest the job definition.
  ## 
  let valid = call_568275.validator(path, query, header, formData, body)
  let scheme = call_568275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568275.url(scheme.get, call_568275.host, call_568275.base,
                         call_568275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568275, url, valid)

proc call*(call_568276: Call_StreamingJobsUpdate_568266; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          streamingJob: JsonNode): Recallable =
  ## streamingJobsUpdate
  ## Updates an existing streaming job. This can be used to partially update (ie. update one or two properties) a streaming job without affecting the rest the job definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  ##   streamingJob: JObject (required)
  ##               : A streaming job object. The properties specified here will overwrite the corresponding properties in the existing streaming job (ie. Those properties will be updated). Any properties that are set to null here will mean that the corresponding property in the existing input will remain the same and not change as a result of this PATCH operation.
  var path_568277 = newJObject()
  var query_568278 = newJObject()
  var body_568279 = newJObject()
  add(path_568277, "resourceGroupName", newJString(resourceGroupName))
  add(query_568278, "api-version", newJString(apiVersion))
  add(path_568277, "subscriptionId", newJString(subscriptionId))
  add(path_568277, "jobName", newJString(jobName))
  if streamingJob != nil:
    body_568279 = streamingJob
  result = call_568276.call(path_568277, query_568278, nil, nil, body_568279)

var streamingJobsUpdate* = Call_StreamingJobsUpdate_568266(
    name: "streamingJobsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}",
    validator: validate_StreamingJobsUpdate_568267, base: "",
    url: url_StreamingJobsUpdate_568268, schemes: {Scheme.Https})
type
  Call_StreamingJobsDelete_568255 = ref object of OpenApiRestCall_567657
proc url_StreamingJobsDelete_568257(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "jobName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingJobsDelete_568256(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a streaming job.
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
  var valid_568258 = path.getOrDefault("resourceGroupName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "resourceGroupName", valid_568258
  var valid_568259 = path.getOrDefault("subscriptionId")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "subscriptionId", valid_568259
  var valid_568260 = path.getOrDefault("jobName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "jobName", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568261 = query.getOrDefault("api-version")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "api-version", valid_568261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568262: Call_StreamingJobsDelete_568255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a streaming job.
  ## 
  let valid = call_568262.validator(path, query, header, formData, body)
  let scheme = call_568262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568262.url(scheme.get, call_568262.host, call_568262.base,
                         call_568262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568262, url, valid)

proc call*(call_568263: Call_StreamingJobsDelete_568255; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string): Recallable =
  ## streamingJobsDelete
  ## Deletes a streaming job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_568264 = newJObject()
  var query_568265 = newJObject()
  add(path_568264, "resourceGroupName", newJString(resourceGroupName))
  add(query_568265, "api-version", newJString(apiVersion))
  add(path_568264, "subscriptionId", newJString(subscriptionId))
  add(path_568264, "jobName", newJString(jobName))
  result = call_568263.call(path_568264, query_568265, nil, nil, nil)

var streamingJobsDelete* = Call_StreamingJobsDelete_568255(
    name: "streamingJobsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}",
    validator: validate_StreamingJobsDelete_568256, base: "",
    url: url_StreamingJobsDelete_568257, schemes: {Scheme.Https})
type
  Call_StreamingJobsStart_568280 = ref object of OpenApiRestCall_567657
proc url_StreamingJobsStart_568282(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingJobsStart_568281(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Starts a streaming job. Once a job is started it will start processing input events and produce output.
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
  var valid_568283 = path.getOrDefault("resourceGroupName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "resourceGroupName", valid_568283
  var valid_568284 = path.getOrDefault("subscriptionId")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "subscriptionId", valid_568284
  var valid_568285 = path.getOrDefault("jobName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "jobName", valid_568285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568286 = query.getOrDefault("api-version")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "api-version", valid_568286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   startJobParameters: JObject
  ##                     : Parameters applicable to a start streaming job operation.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568288: Call_StreamingJobsStart_568280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a streaming job. Once a job is started it will start processing input events and produce output.
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_StreamingJobsStart_568280; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string;
          startJobParameters: JsonNode = nil): Recallable =
  ## streamingJobsStart
  ## Starts a streaming job. Once a job is started it will start processing input events and produce output.
  ##   startJobParameters: JObject
  ##                     : Parameters applicable to a start streaming job operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  var body_568292 = newJObject()
  if startJobParameters != nil:
    body_568292 = startJobParameters
  add(path_568290, "resourceGroupName", newJString(resourceGroupName))
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "subscriptionId", newJString(subscriptionId))
  add(path_568290, "jobName", newJString(jobName))
  result = call_568289.call(path_568290, query_568291, nil, nil, body_568292)

var streamingJobsStart* = Call_StreamingJobsStart_568280(
    name: "streamingJobsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/start",
    validator: validate_StreamingJobsStart_568281, base: "",
    url: url_StreamingJobsStart_568282, schemes: {Scheme.Https})
type
  Call_StreamingJobsStop_568293 = ref object of OpenApiRestCall_567657
proc url_StreamingJobsStop_568295(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StreamingJobsStop_568294(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Stops a running streaming job. This will cause a running streaming job to stop processing input events and producing output.
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
  var valid_568296 = path.getOrDefault("resourceGroupName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "resourceGroupName", valid_568296
  var valid_568297 = path.getOrDefault("subscriptionId")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "subscriptionId", valid_568297
  var valid_568298 = path.getOrDefault("jobName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "jobName", valid_568298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568299 = query.getOrDefault("api-version")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "api-version", valid_568299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_StreamingJobsStop_568293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a running streaming job. This will cause a running streaming job to stop processing input events and producing output.
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_StreamingJobsStop_568293; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; jobName: string): Recallable =
  ## streamingJobsStop
  ## Stops a running streaming job. This will cause a running streaming job to stop processing input events and producing output.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_568302 = newJObject()
  var query_568303 = newJObject()
  add(path_568302, "resourceGroupName", newJString(resourceGroupName))
  add(query_568303, "api-version", newJString(apiVersion))
  add(path_568302, "subscriptionId", newJString(subscriptionId))
  add(path_568302, "jobName", newJString(jobName))
  result = call_568301.call(path_568302, query_568303, nil, nil, nil)

var streamingJobsStop* = Call_StreamingJobsStop_568293(name: "streamingJobsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/stop",
    validator: validate_StreamingJobsStop_568294, base: "",
    url: url_StreamingJobsStop_568295, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
