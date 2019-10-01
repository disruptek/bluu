
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Workload Monitor
## version: 2018-08-31-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## APIs for workload monitoring
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "workloadmonitor-Microsoft.WorkloadMonitor"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567880 = ref object of OpenApiRestCall_567658
proc url_OperationsList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567881(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568055 = query.getOrDefault("api-version")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_568055 != nil:
    section.add "api-version", valid_568055
  var valid_568056 = query.getOrDefault("$skiptoken")
  valid_568056 = validateParameter(valid_568056, JString, required = false,
                                 default = nil)
  if valid_568056 != nil:
    section.add "$skiptoken", valid_568056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568079: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568079.validator(path, query, header, formData, body)
  let scheme = call_568079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568079.url(scheme.get, call_568079.host, call_568079.base,
                         call_568079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568079, url, valid)

proc call*(call_568150: Call_OperationsList_567880;
          apiVersion: string = "2018-08-31-preview"; Skiptoken: string = ""): Recallable =
  ## operationsList
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  var query_568151 = newJObject()
  add(query_568151, "api-version", newJString(apiVersion))
  add(query_568151, "$skiptoken", newJString(Skiptoken))
  result = call_568150.call(nil, query_568151, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.WorkloadMonitor/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_ComponentsSummaryList_568191 = ref object of OpenApiRestCall_567658
proc url_ComponentsSummaryList_568193(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.WorkloadMonitor/componentsSummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsSummaryList_568192(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568208 = path.getOrDefault("subscriptionId")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "subscriptionId", valid_568208
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sort the result on one or more properties.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $top: JString
  ##       : Limit the result to the specified number of rows.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $apply: JString
  ##         : Apply aggregation.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  var valid_568209 = query.getOrDefault("$orderby")
  valid_568209 = validateParameter(valid_568209, JString, required = false,
                                 default = nil)
  if valid_568209 != nil:
    section.add "$orderby", valid_568209
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568210 = query.getOrDefault("api-version")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_568210 != nil:
    section.add "api-version", valid_568210
  var valid_568211 = query.getOrDefault("$expand")
  valid_568211 = validateParameter(valid_568211, JString, required = false,
                                 default = nil)
  if valid_568211 != nil:
    section.add "$expand", valid_568211
  var valid_568212 = query.getOrDefault("$top")
  valid_568212 = validateParameter(valid_568212, JString, required = false,
                                 default = nil)
  if valid_568212 != nil:
    section.add "$top", valid_568212
  var valid_568213 = query.getOrDefault("$select")
  valid_568213 = validateParameter(valid_568213, JString, required = false,
                                 default = nil)
  if valid_568213 != nil:
    section.add "$select", valid_568213
  var valid_568214 = query.getOrDefault("$skiptoken")
  valid_568214 = validateParameter(valid_568214, JString, required = false,
                                 default = nil)
  if valid_568214 != nil:
    section.add "$skiptoken", valid_568214
  var valid_568215 = query.getOrDefault("$apply")
  valid_568215 = validateParameter(valid_568215, JString, required = false,
                                 default = nil)
  if valid_568215 != nil:
    section.add "$apply", valid_568215
  var valid_568216 = query.getOrDefault("$filter")
  valid_568216 = validateParameter(valid_568216, JString, required = false,
                                 default = nil)
  if valid_568216 != nil:
    section.add "$filter", valid_568216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_ComponentsSummaryList_568191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_ComponentsSummaryList_568191; subscriptionId: string;
          Orderby: string = ""; apiVersion: string = "2018-08-31-preview";
          Expand: string = ""; Top: string = ""; Select: string = "";
          Skiptoken: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## componentsSummaryList
  ##   Orderby: string
  ##          : Sort the result on one or more properties.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: string
  ##      : Limit the result to the specified number of rows.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Apply: string
  ##        : Apply aggregation.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  add(query_568220, "$orderby", newJString(Orderby))
  add(query_568220, "api-version", newJString(apiVersion))
  add(query_568220, "$expand", newJString(Expand))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  add(query_568220, "$top", newJString(Top))
  add(query_568220, "$select", newJString(Select))
  add(query_568220, "$skiptoken", newJString(Skiptoken))
  add(query_568220, "$apply", newJString(Apply))
  add(query_568220, "$filter", newJString(Filter))
  result = call_568218.call(path_568219, query_568220, nil, nil, nil)

var componentsSummaryList* = Call_ComponentsSummaryList_568191(
    name: "componentsSummaryList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.WorkloadMonitor/componentsSummary",
    validator: validate_ComponentsSummaryList_568192, base: "",
    url: url_ComponentsSummaryList_568193, schemes: {Scheme.Https})
type
  Call_MonitorInstancesSummaryList_568221 = ref object of OpenApiRestCall_567658
proc url_MonitorInstancesSummaryList_568223(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/monitorInstancesSummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitorInstancesSummaryList_568222(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568224 = path.getOrDefault("subscriptionId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "subscriptionId", valid_568224
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sort the result on one or more properties.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $top: JString
  ##       : Limit the result to the specified number of rows.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $apply: JString
  ##         : Apply aggregation.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  var valid_568225 = query.getOrDefault("$orderby")
  valid_568225 = validateParameter(valid_568225, JString, required = false,
                                 default = nil)
  if valid_568225 != nil:
    section.add "$orderby", valid_568225
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_568226 != nil:
    section.add "api-version", valid_568226
  var valid_568227 = query.getOrDefault("$expand")
  valid_568227 = validateParameter(valid_568227, JString, required = false,
                                 default = nil)
  if valid_568227 != nil:
    section.add "$expand", valid_568227
  var valid_568228 = query.getOrDefault("$top")
  valid_568228 = validateParameter(valid_568228, JString, required = false,
                                 default = nil)
  if valid_568228 != nil:
    section.add "$top", valid_568228
  var valid_568229 = query.getOrDefault("$select")
  valid_568229 = validateParameter(valid_568229, JString, required = false,
                                 default = nil)
  if valid_568229 != nil:
    section.add "$select", valid_568229
  var valid_568230 = query.getOrDefault("$skiptoken")
  valid_568230 = validateParameter(valid_568230, JString, required = false,
                                 default = nil)
  if valid_568230 != nil:
    section.add "$skiptoken", valid_568230
  var valid_568231 = query.getOrDefault("$apply")
  valid_568231 = validateParameter(valid_568231, JString, required = false,
                                 default = nil)
  if valid_568231 != nil:
    section.add "$apply", valid_568231
  var valid_568232 = query.getOrDefault("$filter")
  valid_568232 = validateParameter(valid_568232, JString, required = false,
                                 default = nil)
  if valid_568232 != nil:
    section.add "$filter", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_MonitorInstancesSummaryList_568221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_MonitorInstancesSummaryList_568221;
          subscriptionId: string; Orderby: string = "";
          apiVersion: string = "2018-08-31-preview"; Expand: string = "";
          Top: string = ""; Select: string = ""; Skiptoken: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## monitorInstancesSummaryList
  ##   Orderby: string
  ##          : Sort the result on one or more properties.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: string
  ##      : Limit the result to the specified number of rows.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Apply: string
  ##        : Apply aggregation.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(query_568236, "$orderby", newJString(Orderby))
  add(query_568236, "api-version", newJString(apiVersion))
  add(query_568236, "$expand", newJString(Expand))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  add(query_568236, "$top", newJString(Top))
  add(query_568236, "$select", newJString(Select))
  add(query_568236, "$skiptoken", newJString(Skiptoken))
  add(query_568236, "$apply", newJString(Apply))
  add(query_568236, "$filter", newJString(Filter))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var monitorInstancesSummaryList* = Call_MonitorInstancesSummaryList_568221(
    name: "monitorInstancesSummaryList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.WorkloadMonitor/monitorInstancesSummary",
    validator: validate_MonitorInstancesSummaryList_568222, base: "",
    url: url_MonitorInstancesSummaryList_568223, schemes: {Scheme.Https})
type
  Call_ComponentsListByResource_568237 = ref object of OpenApiRestCall_567658
proc url_ComponentsListByResource_568239(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/components")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsListByResource_568238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568240 = path.getOrDefault("resourceType")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceType", valid_568240
  var valid_568241 = path.getOrDefault("resourceGroupName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "resourceGroupName", valid_568241
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  var valid_568243 = path.getOrDefault("resourceName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "resourceName", valid_568243
  var valid_568244 = path.getOrDefault("resourceNamespace")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "resourceNamespace", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sort the result on one or more properties.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $top: JString
  ##       : Limit the result to the specified number of rows.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $apply: JString
  ##         : Apply aggregation.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  var valid_568245 = query.getOrDefault("$orderby")
  valid_568245 = validateParameter(valid_568245, JString, required = false,
                                 default = nil)
  if valid_568245 != nil:
    section.add "$orderby", valid_568245
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568246 = query.getOrDefault("api-version")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_568246 != nil:
    section.add "api-version", valid_568246
  var valid_568247 = query.getOrDefault("$expand")
  valid_568247 = validateParameter(valid_568247, JString, required = false,
                                 default = nil)
  if valid_568247 != nil:
    section.add "$expand", valid_568247
  var valid_568248 = query.getOrDefault("$top")
  valid_568248 = validateParameter(valid_568248, JString, required = false,
                                 default = nil)
  if valid_568248 != nil:
    section.add "$top", valid_568248
  var valid_568249 = query.getOrDefault("$select")
  valid_568249 = validateParameter(valid_568249, JString, required = false,
                                 default = nil)
  if valid_568249 != nil:
    section.add "$select", valid_568249
  var valid_568250 = query.getOrDefault("$skiptoken")
  valid_568250 = validateParameter(valid_568250, JString, required = false,
                                 default = nil)
  if valid_568250 != nil:
    section.add "$skiptoken", valid_568250
  var valid_568251 = query.getOrDefault("$apply")
  valid_568251 = validateParameter(valid_568251, JString, required = false,
                                 default = nil)
  if valid_568251 != nil:
    section.add "$apply", valid_568251
  var valid_568252 = query.getOrDefault("$filter")
  valid_568252 = validateParameter(valid_568252, JString, required = false,
                                 default = nil)
  if valid_568252 != nil:
    section.add "$filter", valid_568252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568253: Call_ComponentsListByResource_568237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_ComponentsListByResource_568237; resourceType: string;
          resourceGroupName: string; subscriptionId: string; resourceName: string;
          resourceNamespace: string; Orderby: string = "";
          apiVersion: string = "2018-08-31-preview"; Expand: string = "";
          Top: string = ""; Select: string = ""; Skiptoken: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## componentsListByResource
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   Orderby: string
  ##          : Sort the result on one or more properties.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: string
  ##      : Limit the result to the specified number of rows.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Apply: string
  ##        : Apply aggregation.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  add(path_568255, "resourceType", newJString(resourceType))
  add(query_568256, "$orderby", newJString(Orderby))
  add(path_568255, "resourceGroupName", newJString(resourceGroupName))
  add(query_568256, "api-version", newJString(apiVersion))
  add(query_568256, "$expand", newJString(Expand))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  add(query_568256, "$top", newJString(Top))
  add(path_568255, "resourceName", newJString(resourceName))
  add(query_568256, "$select", newJString(Select))
  add(path_568255, "resourceNamespace", newJString(resourceNamespace))
  add(query_568256, "$skiptoken", newJString(Skiptoken))
  add(query_568256, "$apply", newJString(Apply))
  add(query_568256, "$filter", newJString(Filter))
  result = call_568254.call(path_568255, query_568256, nil, nil, nil)

var componentsListByResource* = Call_ComponentsListByResource_568237(
    name: "componentsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/components",
    validator: validate_ComponentsListByResource_568238, base: "",
    url: url_ComponentsListByResource_568239, schemes: {Scheme.Https})
type
  Call_ComponentsGet_568257 = ref object of OpenApiRestCall_567658
proc url_ComponentsGet_568259(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "componentId" in path, "`componentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/components/"),
               (kind: VariableSegment, value: "componentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsGet_568258(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   componentId: JString (required)
  ##              : Component Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568260 = path.getOrDefault("resourceType")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "resourceType", valid_568260
  var valid_568261 = path.getOrDefault("componentId")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "componentId", valid_568261
  var valid_568262 = path.getOrDefault("resourceGroupName")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "resourceGroupName", valid_568262
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  var valid_568264 = path.getOrDefault("resourceName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceName", valid_568264
  var valid_568265 = path.getOrDefault("resourceNamespace")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "resourceNamespace", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_568266 != nil:
    section.add "api-version", valid_568266
  var valid_568267 = query.getOrDefault("$expand")
  valid_568267 = validateParameter(valid_568267, JString, required = false,
                                 default = nil)
  if valid_568267 != nil:
    section.add "$expand", valid_568267
  var valid_568268 = query.getOrDefault("$select")
  valid_568268 = validateParameter(valid_568268, JString, required = false,
                                 default = nil)
  if valid_568268 != nil:
    section.add "$select", valid_568268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568269: Call_ComponentsGet_568257; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568269.validator(path, query, header, formData, body)
  let scheme = call_568269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568269.url(scheme.get, call_568269.host, call_568269.base,
                         call_568269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568269, url, valid)

proc call*(call_568270: Call_ComponentsGet_568257; resourceType: string;
          componentId: string; resourceGroupName: string; subscriptionId: string;
          resourceName: string; resourceNamespace: string;
          apiVersion: string = "2018-08-31-preview"; Expand: string = "";
          Select: string = ""): Recallable =
  ## componentsGet
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   componentId: string (required)
  ##              : Component Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  var path_568271 = newJObject()
  var query_568272 = newJObject()
  add(path_568271, "resourceType", newJString(resourceType))
  add(path_568271, "componentId", newJString(componentId))
  add(path_568271, "resourceGroupName", newJString(resourceGroupName))
  add(query_568272, "api-version", newJString(apiVersion))
  add(query_568272, "$expand", newJString(Expand))
  add(path_568271, "subscriptionId", newJString(subscriptionId))
  add(path_568271, "resourceName", newJString(resourceName))
  add(query_568272, "$select", newJString(Select))
  add(path_568271, "resourceNamespace", newJString(resourceNamespace))
  result = call_568270.call(path_568271, query_568272, nil, nil, nil)

var componentsGet* = Call_ComponentsGet_568257(name: "componentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/components/{componentId}",
    validator: validate_ComponentsGet_568258, base: "", url: url_ComponentsGet_568259,
    schemes: {Scheme.Https})
type
  Call_MonitorInstancesListByResource_568273 = ref object of OpenApiRestCall_567658
proc url_MonitorInstancesListByResource_568275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/monitorInstances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitorInstancesListByResource_568274(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568276 = path.getOrDefault("resourceType")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "resourceType", valid_568276
  var valid_568277 = path.getOrDefault("resourceGroupName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "resourceGroupName", valid_568277
  var valid_568278 = path.getOrDefault("subscriptionId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "subscriptionId", valid_568278
  var valid_568279 = path.getOrDefault("resourceName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "resourceName", valid_568279
  var valid_568280 = path.getOrDefault("resourceNamespace")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "resourceNamespace", valid_568280
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sort the result on one or more properties.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $top: JString
  ##       : Limit the result to the specified number of rows.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $apply: JString
  ##         : Apply aggregation.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  var valid_568281 = query.getOrDefault("$orderby")
  valid_568281 = validateParameter(valid_568281, JString, required = false,
                                 default = nil)
  if valid_568281 != nil:
    section.add "$orderby", valid_568281
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  var valid_568283 = query.getOrDefault("$expand")
  valid_568283 = validateParameter(valid_568283, JString, required = false,
                                 default = nil)
  if valid_568283 != nil:
    section.add "$expand", valid_568283
  var valid_568284 = query.getOrDefault("$top")
  valid_568284 = validateParameter(valid_568284, JString, required = false,
                                 default = nil)
  if valid_568284 != nil:
    section.add "$top", valid_568284
  var valid_568285 = query.getOrDefault("$select")
  valid_568285 = validateParameter(valid_568285, JString, required = false,
                                 default = nil)
  if valid_568285 != nil:
    section.add "$select", valid_568285
  var valid_568286 = query.getOrDefault("$skiptoken")
  valid_568286 = validateParameter(valid_568286, JString, required = false,
                                 default = nil)
  if valid_568286 != nil:
    section.add "$skiptoken", valid_568286
  var valid_568287 = query.getOrDefault("$apply")
  valid_568287 = validateParameter(valid_568287, JString, required = false,
                                 default = nil)
  if valid_568287 != nil:
    section.add "$apply", valid_568287
  var valid_568288 = query.getOrDefault("$filter")
  valid_568288 = validateParameter(valid_568288, JString, required = false,
                                 default = nil)
  if valid_568288 != nil:
    section.add "$filter", valid_568288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568289: Call_MonitorInstancesListByResource_568273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568289.validator(path, query, header, formData, body)
  let scheme = call_568289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568289.url(scheme.get, call_568289.host, call_568289.base,
                         call_568289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568289, url, valid)

proc call*(call_568290: Call_MonitorInstancesListByResource_568273;
          resourceType: string; resourceGroupName: string; subscriptionId: string;
          resourceName: string; resourceNamespace: string; Orderby: string = "";
          apiVersion: string = "2018-08-31-preview"; Expand: string = "";
          Top: string = ""; Select: string = ""; Skiptoken: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## monitorInstancesListByResource
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   Orderby: string
  ##          : Sort the result on one or more properties.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: string
  ##      : Limit the result to the specified number of rows.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Apply: string
  ##        : Apply aggregation.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  var path_568291 = newJObject()
  var query_568292 = newJObject()
  add(path_568291, "resourceType", newJString(resourceType))
  add(query_568292, "$orderby", newJString(Orderby))
  add(path_568291, "resourceGroupName", newJString(resourceGroupName))
  add(query_568292, "api-version", newJString(apiVersion))
  add(query_568292, "$expand", newJString(Expand))
  add(path_568291, "subscriptionId", newJString(subscriptionId))
  add(query_568292, "$top", newJString(Top))
  add(path_568291, "resourceName", newJString(resourceName))
  add(query_568292, "$select", newJString(Select))
  add(path_568291, "resourceNamespace", newJString(resourceNamespace))
  add(query_568292, "$skiptoken", newJString(Skiptoken))
  add(query_568292, "$apply", newJString(Apply))
  add(query_568292, "$filter", newJString(Filter))
  result = call_568290.call(path_568291, query_568292, nil, nil, nil)

var monitorInstancesListByResource* = Call_MonitorInstancesListByResource_568273(
    name: "monitorInstancesListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitorInstances",
    validator: validate_MonitorInstancesListByResource_568274, base: "",
    url: url_MonitorInstancesListByResource_568275, schemes: {Scheme.Https})
type
  Call_MonitorInstancesGet_568293 = ref object of OpenApiRestCall_567658
proc url_MonitorInstancesGet_568295(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "monitorInstanceId" in path,
        "`monitorInstanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/monitorInstances/"),
               (kind: VariableSegment, value: "monitorInstanceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitorInstancesGet_568294(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   monitorInstanceId: JString (required)
  ##                    : MonitorInstance Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568296 = path.getOrDefault("resourceType")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "resourceType", valid_568296
  var valid_568297 = path.getOrDefault("resourceGroupName")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "resourceGroupName", valid_568297
  var valid_568298 = path.getOrDefault("subscriptionId")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "subscriptionId", valid_568298
  var valid_568299 = path.getOrDefault("resourceName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "resourceName", valid_568299
  var valid_568300 = path.getOrDefault("resourceNamespace")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "resourceNamespace", valid_568300
  var valid_568301 = path.getOrDefault("monitorInstanceId")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "monitorInstanceId", valid_568301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568302 = query.getOrDefault("api-version")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_568302 != nil:
    section.add "api-version", valid_568302
  var valid_568303 = query.getOrDefault("$expand")
  valid_568303 = validateParameter(valid_568303, JString, required = false,
                                 default = nil)
  if valid_568303 != nil:
    section.add "$expand", valid_568303
  var valid_568304 = query.getOrDefault("$select")
  valid_568304 = validateParameter(valid_568304, JString, required = false,
                                 default = nil)
  if valid_568304 != nil:
    section.add "$select", valid_568304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568305: Call_MonitorInstancesGet_568293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568305.validator(path, query, header, formData, body)
  let scheme = call_568305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568305.url(scheme.get, call_568305.host, call_568305.base,
                         call_568305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568305, url, valid)

proc call*(call_568306: Call_MonitorInstancesGet_568293; resourceType: string;
          resourceGroupName: string; subscriptionId: string; resourceName: string;
          resourceNamespace: string; monitorInstanceId: string;
          apiVersion: string = "2018-08-31-preview"; Expand: string = "";
          Select: string = ""): Recallable =
  ## monitorInstancesGet
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   monitorInstanceId: string (required)
  ##                    : MonitorInstance Id.
  var path_568307 = newJObject()
  var query_568308 = newJObject()
  add(path_568307, "resourceType", newJString(resourceType))
  add(path_568307, "resourceGroupName", newJString(resourceGroupName))
  add(query_568308, "api-version", newJString(apiVersion))
  add(query_568308, "$expand", newJString(Expand))
  add(path_568307, "subscriptionId", newJString(subscriptionId))
  add(path_568307, "resourceName", newJString(resourceName))
  add(query_568308, "$select", newJString(Select))
  add(path_568307, "resourceNamespace", newJString(resourceNamespace))
  add(path_568307, "monitorInstanceId", newJString(monitorInstanceId))
  result = call_568306.call(path_568307, query_568308, nil, nil, nil)

var monitorInstancesGet* = Call_MonitorInstancesGet_568293(
    name: "monitorInstancesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitorInstances/{monitorInstanceId}",
    validator: validate_MonitorInstancesGet_568294, base: "",
    url: url_MonitorInstancesGet_568295, schemes: {Scheme.Https})
type
  Call_MonitorsListByResource_568309 = ref object of OpenApiRestCall_567658
proc url_MonitorsListByResource_568311(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/monitors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitorsListByResource_568310(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568312 = path.getOrDefault("resourceType")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "resourceType", valid_568312
  var valid_568313 = path.getOrDefault("resourceGroupName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "resourceGroupName", valid_568313
  var valid_568314 = path.getOrDefault("subscriptionId")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "subscriptionId", valid_568314
  var valid_568315 = path.getOrDefault("resourceName")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "resourceName", valid_568315
  var valid_568316 = path.getOrDefault("resourceNamespace")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "resourceNamespace", valid_568316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568317 = query.getOrDefault("api-version")
  valid_568317 = validateParameter(valid_568317, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_568317 != nil:
    section.add "api-version", valid_568317
  var valid_568318 = query.getOrDefault("$skiptoken")
  valid_568318 = validateParameter(valid_568318, JString, required = false,
                                 default = nil)
  if valid_568318 != nil:
    section.add "$skiptoken", valid_568318
  var valid_568319 = query.getOrDefault("$filter")
  valid_568319 = validateParameter(valid_568319, JString, required = false,
                                 default = nil)
  if valid_568319 != nil:
    section.add "$filter", valid_568319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568320: Call_MonitorsListByResource_568309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568320.validator(path, query, header, formData, body)
  let scheme = call_568320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568320.url(scheme.get, call_568320.host, call_568320.base,
                         call_568320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568320, url, valid)

proc call*(call_568321: Call_MonitorsListByResource_568309; resourceType: string;
          resourceGroupName: string; subscriptionId: string; resourceName: string;
          resourceNamespace: string; apiVersion: string = "2018-08-31-preview";
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## monitorsListByResource
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  var path_568322 = newJObject()
  var query_568323 = newJObject()
  add(path_568322, "resourceType", newJString(resourceType))
  add(path_568322, "resourceGroupName", newJString(resourceGroupName))
  add(query_568323, "api-version", newJString(apiVersion))
  add(path_568322, "subscriptionId", newJString(subscriptionId))
  add(path_568322, "resourceName", newJString(resourceName))
  add(path_568322, "resourceNamespace", newJString(resourceNamespace))
  add(query_568323, "$skiptoken", newJString(Skiptoken))
  add(query_568323, "$filter", newJString(Filter))
  result = call_568321.call(path_568322, query_568323, nil, nil, nil)

var monitorsListByResource* = Call_MonitorsListByResource_568309(
    name: "monitorsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitors",
    validator: validate_MonitorsListByResource_568310, base: "",
    url: url_MonitorsListByResource_568311, schemes: {Scheme.Https})
type
  Call_MonitorsGet_568324 = ref object of OpenApiRestCall_567658
proc url_MonitorsGet_568326(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "monitorId" in path, "`monitorId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/monitors/"),
               (kind: VariableSegment, value: "monitorId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitorsGet_568325(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   monitorId: JString (required)
  ##            : Monitor Id.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568327 = path.getOrDefault("resourceType")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "resourceType", valid_568327
  var valid_568328 = path.getOrDefault("resourceGroupName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "resourceGroupName", valid_568328
  var valid_568329 = path.getOrDefault("monitorId")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "monitorId", valid_568329
  var valid_568330 = path.getOrDefault("subscriptionId")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "subscriptionId", valid_568330
  var valid_568331 = path.getOrDefault("resourceName")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "resourceName", valid_568331
  var valid_568332 = path.getOrDefault("resourceNamespace")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "resourceNamespace", valid_568332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568333 = query.getOrDefault("api-version")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_568333 != nil:
    section.add "api-version", valid_568333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_MonitorsGet_568324; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_MonitorsGet_568324; resourceType: string;
          resourceGroupName: string; monitorId: string; subscriptionId: string;
          resourceName: string; resourceNamespace: string;
          apiVersion: string = "2018-08-31-preview"): Recallable =
  ## monitorsGet
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   monitorId: string (required)
  ##            : Monitor Id.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  add(path_568336, "resourceType", newJString(resourceType))
  add(path_568336, "resourceGroupName", newJString(resourceGroupName))
  add(path_568336, "monitorId", newJString(monitorId))
  add(query_568337, "api-version", newJString(apiVersion))
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  add(path_568336, "resourceName", newJString(resourceName))
  add(path_568336, "resourceNamespace", newJString(resourceNamespace))
  result = call_568335.call(path_568336, query_568337, nil, nil, nil)

var monitorsGet* = Call_MonitorsGet_568324(name: "monitorsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitors/{monitorId}",
                                        validator: validate_MonitorsGet_568325,
                                        base: "", url: url_MonitorsGet_568326,
                                        schemes: {Scheme.Https})
type
  Call_MonitorsUpdate_568338 = ref object of OpenApiRestCall_567658
proc url_MonitorsUpdate_568340(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "monitorId" in path, "`monitorId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/monitors/"),
               (kind: VariableSegment, value: "monitorId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitorsUpdate_568339(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   monitorId: JString (required)
  ##            : Monitor Id.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568341 = path.getOrDefault("resourceType")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "resourceType", valid_568341
  var valid_568342 = path.getOrDefault("resourceGroupName")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "resourceGroupName", valid_568342
  var valid_568343 = path.getOrDefault("monitorId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "monitorId", valid_568343
  var valid_568344 = path.getOrDefault("subscriptionId")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "subscriptionId", valid_568344
  var valid_568345 = path.getOrDefault("resourceName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "resourceName", valid_568345
  var valid_568346 = path.getOrDefault("resourceNamespace")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "resourceNamespace", valid_568346
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568347 = query.getOrDefault("api-version")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_568347 != nil:
    section.add "api-version", valid_568347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Body of the Monitor PATCH object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568349: Call_MonitorsUpdate_568338; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568349.validator(path, query, header, formData, body)
  let scheme = call_568349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568349.url(scheme.get, call_568349.host, call_568349.base,
                         call_568349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568349, url, valid)

proc call*(call_568350: Call_MonitorsUpdate_568338; resourceType: string;
          resourceGroupName: string; monitorId: string; subscriptionId: string;
          resourceName: string; resourceNamespace: string; body: JsonNode;
          apiVersion: string = "2018-08-31-preview"): Recallable =
  ## monitorsUpdate
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   monitorId: string (required)
  ##            : Monitor Id.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   body: JObject (required)
  ##       : Body of the Monitor PATCH object.
  var path_568351 = newJObject()
  var query_568352 = newJObject()
  var body_568353 = newJObject()
  add(path_568351, "resourceType", newJString(resourceType))
  add(path_568351, "resourceGroupName", newJString(resourceGroupName))
  add(path_568351, "monitorId", newJString(monitorId))
  add(query_568352, "api-version", newJString(apiVersion))
  add(path_568351, "subscriptionId", newJString(subscriptionId))
  add(path_568351, "resourceName", newJString(resourceName))
  add(path_568351, "resourceNamespace", newJString(resourceNamespace))
  if body != nil:
    body_568353 = body
  result = call_568350.call(path_568351, query_568352, nil, nil, body_568353)

var monitorsUpdate* = Call_MonitorsUpdate_568338(name: "monitorsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitors/{monitorId}",
    validator: validate_MonitorsUpdate_568339, base: "", url: url_MonitorsUpdate_568340,
    schemes: {Scheme.Https})
type
  Call_NotificationSettingsListByResource_568354 = ref object of OpenApiRestCall_567658
proc url_NotificationSettingsListByResource_568356(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/notificationSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationSettingsListByResource_568355(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568357 = path.getOrDefault("resourceType")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "resourceType", valid_568357
  var valid_568358 = path.getOrDefault("resourceGroupName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "resourceGroupName", valid_568358
  var valid_568359 = path.getOrDefault("subscriptionId")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "subscriptionId", valid_568359
  var valid_568360 = path.getOrDefault("resourceName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "resourceName", valid_568360
  var valid_568361 = path.getOrDefault("resourceNamespace")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "resourceNamespace", valid_568361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568362 = query.getOrDefault("api-version")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_568362 != nil:
    section.add "api-version", valid_568362
  var valid_568363 = query.getOrDefault("$skiptoken")
  valid_568363 = validateParameter(valid_568363, JString, required = false,
                                 default = nil)
  if valid_568363 != nil:
    section.add "$skiptoken", valid_568363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568364: Call_NotificationSettingsListByResource_568354;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_NotificationSettingsListByResource_568354;
          resourceType: string; resourceGroupName: string; subscriptionId: string;
          resourceName: string; resourceNamespace: string;
          apiVersion: string = "2018-08-31-preview"; Skiptoken: string = ""): Recallable =
  ## notificationSettingsListByResource
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  var path_568366 = newJObject()
  var query_568367 = newJObject()
  add(path_568366, "resourceType", newJString(resourceType))
  add(path_568366, "resourceGroupName", newJString(resourceGroupName))
  add(query_568367, "api-version", newJString(apiVersion))
  add(path_568366, "subscriptionId", newJString(subscriptionId))
  add(path_568366, "resourceName", newJString(resourceName))
  add(path_568366, "resourceNamespace", newJString(resourceNamespace))
  add(query_568367, "$skiptoken", newJString(Skiptoken))
  result = call_568365.call(path_568366, query_568367, nil, nil, nil)

var notificationSettingsListByResource* = Call_NotificationSettingsListByResource_568354(
    name: "notificationSettingsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/notificationSettings",
    validator: validate_NotificationSettingsListByResource_568355, base: "",
    url: url_NotificationSettingsListByResource_568356, schemes: {Scheme.Https})
type
  Call_NotificationSettingsUpdate_568382 = ref object of OpenApiRestCall_567658
proc url_NotificationSettingsUpdate_568384(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "notificationSettingName" in path,
        "`notificationSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/notificationSettings/"),
               (kind: VariableSegment, value: "notificationSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationSettingsUpdate_568383(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   notificationSettingName: JString (required)
  ##                          : Default string modeled as parameter for URL to work correctly.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568385 = path.getOrDefault("resourceType")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "resourceType", valid_568385
  var valid_568386 = path.getOrDefault("resourceGroupName")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "resourceGroupName", valid_568386
  var valid_568387 = path.getOrDefault("subscriptionId")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "subscriptionId", valid_568387
  var valid_568388 = path.getOrDefault("resourceName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "resourceName", valid_568388
  var valid_568389 = path.getOrDefault("resourceNamespace")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "resourceNamespace", valid_568389
  var valid_568390 = path.getOrDefault("notificationSettingName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = newJString("default"))
  if valid_568390 != nil:
    section.add "notificationSettingName", valid_568390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568391 = query.getOrDefault("api-version")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_568391 != nil:
    section.add "api-version", valid_568391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Body of the NotificationSetting PUT object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_NotificationSettingsUpdate_568382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_NotificationSettingsUpdate_568382;
          resourceType: string; resourceGroupName: string; subscriptionId: string;
          resourceName: string; resourceNamespace: string; body: JsonNode;
          apiVersion: string = "2018-08-31-preview";
          notificationSettingName: string = "default"): Recallable =
  ## notificationSettingsUpdate
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   body: JObject (required)
  ##       : Body of the NotificationSetting PUT object.
  ##   notificationSettingName: string (required)
  ##                          : Default string modeled as parameter for URL to work correctly.
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  var body_568397 = newJObject()
  add(path_568395, "resourceType", newJString(resourceType))
  add(path_568395, "resourceGroupName", newJString(resourceGroupName))
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "subscriptionId", newJString(subscriptionId))
  add(path_568395, "resourceName", newJString(resourceName))
  add(path_568395, "resourceNamespace", newJString(resourceNamespace))
  if body != nil:
    body_568397 = body
  add(path_568395, "notificationSettingName", newJString(notificationSettingName))
  result = call_568394.call(path_568395, query_568396, nil, nil, body_568397)

var notificationSettingsUpdate* = Call_NotificationSettingsUpdate_568382(
    name: "notificationSettingsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/notificationSettings/{notificationSettingName}",
    validator: validate_NotificationSettingsUpdate_568383, base: "",
    url: url_NotificationSettingsUpdate_568384, schemes: {Scheme.Https})
type
  Call_NotificationSettingsGet_568368 = ref object of OpenApiRestCall_567658
proc url_NotificationSettingsGet_568370(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "notificationSettingName" in path,
        "`notificationSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/notificationSettings/"),
               (kind: VariableSegment, value: "notificationSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationSettingsGet_568369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   notificationSettingName: JString (required)
  ##                          : Default string modeled as parameter for URL to work correctly.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568371 = path.getOrDefault("resourceType")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "resourceType", valid_568371
  var valid_568372 = path.getOrDefault("resourceGroupName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "resourceGroupName", valid_568372
  var valid_568373 = path.getOrDefault("subscriptionId")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "subscriptionId", valid_568373
  var valid_568374 = path.getOrDefault("resourceName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "resourceName", valid_568374
  var valid_568375 = path.getOrDefault("resourceNamespace")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "resourceNamespace", valid_568375
  var valid_568376 = path.getOrDefault("notificationSettingName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = newJString("default"))
  if valid_568376 != nil:
    section.add "notificationSettingName", valid_568376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568377 = query.getOrDefault("api-version")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_568377 != nil:
    section.add "api-version", valid_568377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568378: Call_NotificationSettingsGet_568368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_568378.validator(path, query, header, formData, body)
  let scheme = call_568378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568378.url(scheme.get, call_568378.host, call_568378.base,
                         call_568378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568378, url, valid)

proc call*(call_568379: Call_NotificationSettingsGet_568368; resourceType: string;
          resourceGroupName: string; subscriptionId: string; resourceName: string;
          resourceNamespace: string; apiVersion: string = "2018-08-31-preview";
          notificationSettingName: string = "default"): Recallable =
  ## notificationSettingsGet
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   notificationSettingName: string (required)
  ##                          : Default string modeled as parameter for URL to work correctly.
  var path_568380 = newJObject()
  var query_568381 = newJObject()
  add(path_568380, "resourceType", newJString(resourceType))
  add(path_568380, "resourceGroupName", newJString(resourceGroupName))
  add(query_568381, "api-version", newJString(apiVersion))
  add(path_568380, "subscriptionId", newJString(subscriptionId))
  add(path_568380, "resourceName", newJString(resourceName))
  add(path_568380, "resourceNamespace", newJString(resourceNamespace))
  add(path_568380, "notificationSettingName", newJString(notificationSettingName))
  result = call_568379.call(path_568380, query_568381, nil, nil, nil)

var notificationSettingsGet* = Call_NotificationSettingsGet_568368(
    name: "notificationSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/notificationSettings/{notificationSettingName}",
    validator: validate_NotificationSettingsGet_568369, base: "",
    url: url_NotificationSettingsGet_568370, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
