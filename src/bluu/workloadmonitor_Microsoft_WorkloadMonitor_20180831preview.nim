
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "workloadmonitor-Microsoft.WorkloadMonitor"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
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
  var valid_563955 = query.getOrDefault("api-version")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_563955 != nil:
    section.add "api-version", valid_563955
  var valid_563956 = query.getOrDefault("$skiptoken")
  valid_563956 = validateParameter(valid_563956, JString, required = false,
                                 default = nil)
  if valid_563956 != nil:
    section.add "$skiptoken", valid_563956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563979: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_563979.validator(path, query, header, formData, body)
  let scheme = call_563979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563979.url(scheme.get, call_563979.host, call_563979.base,
                         call_563979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563979, url, valid)

proc call*(call_564050: Call_OperationsList_563778;
          apiVersion: string = "2018-08-31-preview"; Skiptoken: string = ""): Recallable =
  ## operationsList
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  var query_564051 = newJObject()
  add(query_564051, "api-version", newJString(apiVersion))
  add(query_564051, "$skiptoken", newJString(Skiptoken))
  result = call_564050.call(nil, query_564051, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.WorkloadMonitor/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_ComponentsSummaryList_564091 = ref object of OpenApiRestCall_563556
proc url_ComponentsSummaryList_564093(protocol: Scheme; host: string; base: string;
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

proc validate_ComponentsSummaryList_564092(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564108 = path.getOrDefault("subscriptionId")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "subscriptionId", valid_564108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JString
  ##       : Limit the result to the specified number of rows.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $orderby: JString
  ##           : Sort the result on one or more properties.
  ##   $apply: JString
  ##         : Apply aggregation.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564109 = query.getOrDefault("api-version")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_564109 != nil:
    section.add "api-version", valid_564109
  var valid_564110 = query.getOrDefault("$top")
  valid_564110 = validateParameter(valid_564110, JString, required = false,
                                 default = nil)
  if valid_564110 != nil:
    section.add "$top", valid_564110
  var valid_564111 = query.getOrDefault("$select")
  valid_564111 = validateParameter(valid_564111, JString, required = false,
                                 default = nil)
  if valid_564111 != nil:
    section.add "$select", valid_564111
  var valid_564112 = query.getOrDefault("$expand")
  valid_564112 = validateParameter(valid_564112, JString, required = false,
                                 default = nil)
  if valid_564112 != nil:
    section.add "$expand", valid_564112
  var valid_564113 = query.getOrDefault("$orderby")
  valid_564113 = validateParameter(valid_564113, JString, required = false,
                                 default = nil)
  if valid_564113 != nil:
    section.add "$orderby", valid_564113
  var valid_564114 = query.getOrDefault("$apply")
  valid_564114 = validateParameter(valid_564114, JString, required = false,
                                 default = nil)
  if valid_564114 != nil:
    section.add "$apply", valid_564114
  var valid_564115 = query.getOrDefault("$skiptoken")
  valid_564115 = validateParameter(valid_564115, JString, required = false,
                                 default = nil)
  if valid_564115 != nil:
    section.add "$skiptoken", valid_564115
  var valid_564116 = query.getOrDefault("$filter")
  valid_564116 = validateParameter(valid_564116, JString, required = false,
                                 default = nil)
  if valid_564116 != nil:
    section.add "$filter", valid_564116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_ComponentsSummaryList_564091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_ComponentsSummaryList_564091; subscriptionId: string;
          apiVersion: string = "2018-08-31-preview"; Top: string = "";
          Select: string = ""; Expand: string = ""; Orderby: string = "";
          Apply: string = ""; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## componentsSummaryList
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Top: string
  ##      : Limit the result to the specified number of rows.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Orderby: string
  ##          : Sort the result on one or more properties.
  ##   Apply: string
  ##        : Apply aggregation.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  var path_564119 = newJObject()
  var query_564120 = newJObject()
  add(query_564120, "api-version", newJString(apiVersion))
  add(query_564120, "$top", newJString(Top))
  add(query_564120, "$select", newJString(Select))
  add(query_564120, "$expand", newJString(Expand))
  add(path_564119, "subscriptionId", newJString(subscriptionId))
  add(query_564120, "$orderby", newJString(Orderby))
  add(query_564120, "$apply", newJString(Apply))
  add(query_564120, "$skiptoken", newJString(Skiptoken))
  add(query_564120, "$filter", newJString(Filter))
  result = call_564118.call(path_564119, query_564120, nil, nil, nil)

var componentsSummaryList* = Call_ComponentsSummaryList_564091(
    name: "componentsSummaryList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.WorkloadMonitor/componentsSummary",
    validator: validate_ComponentsSummaryList_564092, base: "",
    url: url_ComponentsSummaryList_564093, schemes: {Scheme.Https})
type
  Call_MonitorInstancesSummaryList_564121 = ref object of OpenApiRestCall_563556
proc url_MonitorInstancesSummaryList_564123(protocol: Scheme; host: string;
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

proc validate_MonitorInstancesSummaryList_564122(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564124 = path.getOrDefault("subscriptionId")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "subscriptionId", valid_564124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JString
  ##       : Limit the result to the specified number of rows.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $orderby: JString
  ##           : Sort the result on one or more properties.
  ##   $apply: JString
  ##         : Apply aggregation.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564125 = query.getOrDefault("api-version")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_564125 != nil:
    section.add "api-version", valid_564125
  var valid_564126 = query.getOrDefault("$top")
  valid_564126 = validateParameter(valid_564126, JString, required = false,
                                 default = nil)
  if valid_564126 != nil:
    section.add "$top", valid_564126
  var valid_564127 = query.getOrDefault("$select")
  valid_564127 = validateParameter(valid_564127, JString, required = false,
                                 default = nil)
  if valid_564127 != nil:
    section.add "$select", valid_564127
  var valid_564128 = query.getOrDefault("$expand")
  valid_564128 = validateParameter(valid_564128, JString, required = false,
                                 default = nil)
  if valid_564128 != nil:
    section.add "$expand", valid_564128
  var valid_564129 = query.getOrDefault("$orderby")
  valid_564129 = validateParameter(valid_564129, JString, required = false,
                                 default = nil)
  if valid_564129 != nil:
    section.add "$orderby", valid_564129
  var valid_564130 = query.getOrDefault("$apply")
  valid_564130 = validateParameter(valid_564130, JString, required = false,
                                 default = nil)
  if valid_564130 != nil:
    section.add "$apply", valid_564130
  var valid_564131 = query.getOrDefault("$skiptoken")
  valid_564131 = validateParameter(valid_564131, JString, required = false,
                                 default = nil)
  if valid_564131 != nil:
    section.add "$skiptoken", valid_564131
  var valid_564132 = query.getOrDefault("$filter")
  valid_564132 = validateParameter(valid_564132, JString, required = false,
                                 default = nil)
  if valid_564132 != nil:
    section.add "$filter", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_MonitorInstancesSummaryList_564121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_MonitorInstancesSummaryList_564121;
          subscriptionId: string; apiVersion: string = "2018-08-31-preview";
          Top: string = ""; Select: string = ""; Expand: string = ""; Orderby: string = "";
          Apply: string = ""; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## monitorInstancesSummaryList
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Top: string
  ##      : Limit the result to the specified number of rows.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Orderby: string
  ##          : Sort the result on one or more properties.
  ##   Apply: string
  ##        : Apply aggregation.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(query_564136, "$top", newJString(Top))
  add(query_564136, "$select", newJString(Select))
  add(query_564136, "$expand", newJString(Expand))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  add(query_564136, "$orderby", newJString(Orderby))
  add(query_564136, "$apply", newJString(Apply))
  add(query_564136, "$skiptoken", newJString(Skiptoken))
  add(query_564136, "$filter", newJString(Filter))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var monitorInstancesSummaryList* = Call_MonitorInstancesSummaryList_564121(
    name: "monitorInstancesSummaryList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.WorkloadMonitor/monitorInstancesSummary",
    validator: validate_MonitorInstancesSummaryList_564122, base: "",
    url: url_MonitorInstancesSummaryList_564123, schemes: {Scheme.Https})
type
  Call_ComponentsListByResource_564137 = ref object of OpenApiRestCall_563556
proc url_ComponentsListByResource_564139(protocol: Scheme; host: string;
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

proc validate_ComponentsListByResource_564138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564140 = path.getOrDefault("resourceType")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "resourceType", valid_564140
  var valid_564141 = path.getOrDefault("subscriptionId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "subscriptionId", valid_564141
  var valid_564142 = path.getOrDefault("resourceNamespace")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "resourceNamespace", valid_564142
  var valid_564143 = path.getOrDefault("resourceGroupName")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "resourceGroupName", valid_564143
  var valid_564144 = path.getOrDefault("resourceName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "resourceName", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JString
  ##       : Limit the result to the specified number of rows.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $orderby: JString
  ##           : Sort the result on one or more properties.
  ##   $apply: JString
  ##         : Apply aggregation.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564145 = query.getOrDefault("api-version")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_564145 != nil:
    section.add "api-version", valid_564145
  var valid_564146 = query.getOrDefault("$top")
  valid_564146 = validateParameter(valid_564146, JString, required = false,
                                 default = nil)
  if valid_564146 != nil:
    section.add "$top", valid_564146
  var valid_564147 = query.getOrDefault("$select")
  valid_564147 = validateParameter(valid_564147, JString, required = false,
                                 default = nil)
  if valid_564147 != nil:
    section.add "$select", valid_564147
  var valid_564148 = query.getOrDefault("$expand")
  valid_564148 = validateParameter(valid_564148, JString, required = false,
                                 default = nil)
  if valid_564148 != nil:
    section.add "$expand", valid_564148
  var valid_564149 = query.getOrDefault("$orderby")
  valid_564149 = validateParameter(valid_564149, JString, required = false,
                                 default = nil)
  if valid_564149 != nil:
    section.add "$orderby", valid_564149
  var valid_564150 = query.getOrDefault("$apply")
  valid_564150 = validateParameter(valid_564150, JString, required = false,
                                 default = nil)
  if valid_564150 != nil:
    section.add "$apply", valid_564150
  var valid_564151 = query.getOrDefault("$skiptoken")
  valid_564151 = validateParameter(valid_564151, JString, required = false,
                                 default = nil)
  if valid_564151 != nil:
    section.add "$skiptoken", valid_564151
  var valid_564152 = query.getOrDefault("$filter")
  valid_564152 = validateParameter(valid_564152, JString, required = false,
                                 default = nil)
  if valid_564152 != nil:
    section.add "$filter", valid_564152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564153: Call_ComponentsListByResource_564137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_ComponentsListByResource_564137; resourceType: string;
          subscriptionId: string; resourceNamespace: string;
          resourceGroupName: string; resourceName: string;
          apiVersion: string = "2018-08-31-preview"; Top: string = "";
          Select: string = ""; Expand: string = ""; Orderby: string = "";
          Apply: string = ""; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## componentsListByResource
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   Top: string
  ##      : Limit the result to the specified number of rows.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   Orderby: string
  ##          : Sort the result on one or more properties.
  ##   Apply: string
  ##        : Apply aggregation.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  add(query_564156, "api-version", newJString(apiVersion))
  add(path_564155, "resourceType", newJString(resourceType))
  add(query_564156, "$top", newJString(Top))
  add(query_564156, "$select", newJString(Select))
  add(query_564156, "$expand", newJString(Expand))
  add(path_564155, "subscriptionId", newJString(subscriptionId))
  add(path_564155, "resourceNamespace", newJString(resourceNamespace))
  add(query_564156, "$orderby", newJString(Orderby))
  add(query_564156, "$apply", newJString(Apply))
  add(query_564156, "$skiptoken", newJString(Skiptoken))
  add(path_564155, "resourceGroupName", newJString(resourceGroupName))
  add(query_564156, "$filter", newJString(Filter))
  add(path_564155, "resourceName", newJString(resourceName))
  result = call_564154.call(path_564155, query_564156, nil, nil, nil)

var componentsListByResource* = Call_ComponentsListByResource_564137(
    name: "componentsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/components",
    validator: validate_ComponentsListByResource_564138, base: "",
    url: url_ComponentsListByResource_564139, schemes: {Scheme.Https})
type
  Call_ComponentsGet_564157 = ref object of OpenApiRestCall_563556
proc url_ComponentsGet_564159(protocol: Scheme; host: string; base: string;
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

proc validate_ComponentsGet_564158(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   componentId: JString (required)
  ##              : Component Id.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564160 = path.getOrDefault("resourceType")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "resourceType", valid_564160
  var valid_564161 = path.getOrDefault("componentId")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "componentId", valid_564161
  var valid_564162 = path.getOrDefault("subscriptionId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "subscriptionId", valid_564162
  var valid_564163 = path.getOrDefault("resourceNamespace")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "resourceNamespace", valid_564163
  var valid_564164 = path.getOrDefault("resourceGroupName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "resourceGroupName", valid_564164
  var valid_564165 = path.getOrDefault("resourceName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "resourceName", valid_564165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_564166 != nil:
    section.add "api-version", valid_564166
  var valid_564167 = query.getOrDefault("$select")
  valid_564167 = validateParameter(valid_564167, JString, required = false,
                                 default = nil)
  if valid_564167 != nil:
    section.add "$select", valid_564167
  var valid_564168 = query.getOrDefault("$expand")
  valid_564168 = validateParameter(valid_564168, JString, required = false,
                                 default = nil)
  if valid_564168 != nil:
    section.add "$expand", valid_564168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564169: Call_ComponentsGet_564157; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_ComponentsGet_564157; resourceType: string;
          componentId: string; subscriptionId: string; resourceNamespace: string;
          resourceGroupName: string; resourceName: string;
          apiVersion: string = "2018-08-31-preview"; Select: string = "";
          Expand: string = ""): Recallable =
  ## componentsGet
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   componentId: string (required)
  ##              : Component Id.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564171 = newJObject()
  var query_564172 = newJObject()
  add(query_564172, "api-version", newJString(apiVersion))
  add(path_564171, "resourceType", newJString(resourceType))
  add(query_564172, "$select", newJString(Select))
  add(query_564172, "$expand", newJString(Expand))
  add(path_564171, "componentId", newJString(componentId))
  add(path_564171, "subscriptionId", newJString(subscriptionId))
  add(path_564171, "resourceNamespace", newJString(resourceNamespace))
  add(path_564171, "resourceGroupName", newJString(resourceGroupName))
  add(path_564171, "resourceName", newJString(resourceName))
  result = call_564170.call(path_564171, query_564172, nil, nil, nil)

var componentsGet* = Call_ComponentsGet_564157(name: "componentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/components/{componentId}",
    validator: validate_ComponentsGet_564158, base: "", url: url_ComponentsGet_564159,
    schemes: {Scheme.Https})
type
  Call_MonitorInstancesListByResource_564173 = ref object of OpenApiRestCall_563556
proc url_MonitorInstancesListByResource_564175(protocol: Scheme; host: string;
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

proc validate_MonitorInstancesListByResource_564174(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564176 = path.getOrDefault("resourceType")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "resourceType", valid_564176
  var valid_564177 = path.getOrDefault("subscriptionId")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "subscriptionId", valid_564177
  var valid_564178 = path.getOrDefault("resourceNamespace")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "resourceNamespace", valid_564178
  var valid_564179 = path.getOrDefault("resourceGroupName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "resourceGroupName", valid_564179
  var valid_564180 = path.getOrDefault("resourceName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "resourceName", valid_564180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JString
  ##       : Limit the result to the specified number of rows.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $orderby: JString
  ##           : Sort the result on one or more properties.
  ##   $apply: JString
  ##         : Apply aggregation.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564181 = query.getOrDefault("api-version")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_564181 != nil:
    section.add "api-version", valid_564181
  var valid_564182 = query.getOrDefault("$top")
  valid_564182 = validateParameter(valid_564182, JString, required = false,
                                 default = nil)
  if valid_564182 != nil:
    section.add "$top", valid_564182
  var valid_564183 = query.getOrDefault("$select")
  valid_564183 = validateParameter(valid_564183, JString, required = false,
                                 default = nil)
  if valid_564183 != nil:
    section.add "$select", valid_564183
  var valid_564184 = query.getOrDefault("$expand")
  valid_564184 = validateParameter(valid_564184, JString, required = false,
                                 default = nil)
  if valid_564184 != nil:
    section.add "$expand", valid_564184
  var valid_564185 = query.getOrDefault("$orderby")
  valid_564185 = validateParameter(valid_564185, JString, required = false,
                                 default = nil)
  if valid_564185 != nil:
    section.add "$orderby", valid_564185
  var valid_564186 = query.getOrDefault("$apply")
  valid_564186 = validateParameter(valid_564186, JString, required = false,
                                 default = nil)
  if valid_564186 != nil:
    section.add "$apply", valid_564186
  var valid_564187 = query.getOrDefault("$skiptoken")
  valid_564187 = validateParameter(valid_564187, JString, required = false,
                                 default = nil)
  if valid_564187 != nil:
    section.add "$skiptoken", valid_564187
  var valid_564188 = query.getOrDefault("$filter")
  valid_564188 = validateParameter(valid_564188, JString, required = false,
                                 default = nil)
  if valid_564188 != nil:
    section.add "$filter", valid_564188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564189: Call_MonitorInstancesListByResource_564173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564189.validator(path, query, header, formData, body)
  let scheme = call_564189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564189.url(scheme.get, call_564189.host, call_564189.base,
                         call_564189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564189, url, valid)

proc call*(call_564190: Call_MonitorInstancesListByResource_564173;
          resourceType: string; subscriptionId: string; resourceNamespace: string;
          resourceGroupName: string; resourceName: string;
          apiVersion: string = "2018-08-31-preview"; Top: string = "";
          Select: string = ""; Expand: string = ""; Orderby: string = "";
          Apply: string = ""; Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## monitorInstancesListByResource
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   Top: string
  ##      : Limit the result to the specified number of rows.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   Orderby: string
  ##          : Sort the result on one or more properties.
  ##   Apply: string
  ##        : Apply aggregation.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564191 = newJObject()
  var query_564192 = newJObject()
  add(query_564192, "api-version", newJString(apiVersion))
  add(path_564191, "resourceType", newJString(resourceType))
  add(query_564192, "$top", newJString(Top))
  add(query_564192, "$select", newJString(Select))
  add(query_564192, "$expand", newJString(Expand))
  add(path_564191, "subscriptionId", newJString(subscriptionId))
  add(path_564191, "resourceNamespace", newJString(resourceNamespace))
  add(query_564192, "$orderby", newJString(Orderby))
  add(query_564192, "$apply", newJString(Apply))
  add(query_564192, "$skiptoken", newJString(Skiptoken))
  add(path_564191, "resourceGroupName", newJString(resourceGroupName))
  add(query_564192, "$filter", newJString(Filter))
  add(path_564191, "resourceName", newJString(resourceName))
  result = call_564190.call(path_564191, query_564192, nil, nil, nil)

var monitorInstancesListByResource* = Call_MonitorInstancesListByResource_564173(
    name: "monitorInstancesListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitorInstances",
    validator: validate_MonitorInstancesListByResource_564174, base: "",
    url: url_MonitorInstancesListByResource_564175, schemes: {Scheme.Https})
type
  Call_MonitorInstancesGet_564193 = ref object of OpenApiRestCall_563556
proc url_MonitorInstancesGet_564195(protocol: Scheme; host: string; base: string;
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

proc validate_MonitorInstancesGet_564194(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   monitorInstanceId: JString (required)
  ##                    : MonitorInstance Id.
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `monitorInstanceId` field"
  var valid_564196 = path.getOrDefault("monitorInstanceId")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "monitorInstanceId", valid_564196
  var valid_564197 = path.getOrDefault("resourceType")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "resourceType", valid_564197
  var valid_564198 = path.getOrDefault("subscriptionId")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "subscriptionId", valid_564198
  var valid_564199 = path.getOrDefault("resourceNamespace")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "resourceNamespace", valid_564199
  var valid_564200 = path.getOrDefault("resourceGroupName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "resourceGroupName", valid_564200
  var valid_564201 = path.getOrDefault("resourceName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "resourceName", valid_564201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564202 = query.getOrDefault("api-version")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_564202 != nil:
    section.add "api-version", valid_564202
  var valid_564203 = query.getOrDefault("$select")
  valid_564203 = validateParameter(valid_564203, JString, required = false,
                                 default = nil)
  if valid_564203 != nil:
    section.add "$select", valid_564203
  var valid_564204 = query.getOrDefault("$expand")
  valid_564204 = validateParameter(valid_564204, JString, required = false,
                                 default = nil)
  if valid_564204 != nil:
    section.add "$expand", valid_564204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564205: Call_MonitorInstancesGet_564193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_MonitorInstancesGet_564193; monitorInstanceId: string;
          resourceType: string; subscriptionId: string; resourceNamespace: string;
          resourceGroupName: string; resourceName: string;
          apiVersion: string = "2018-08-31-preview"; Select: string = "";
          Expand: string = ""): Recallable =
  ## monitorInstancesGet
  ##   monitorInstanceId: string (required)
  ##                    : MonitorInstance Id.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  add(path_564207, "monitorInstanceId", newJString(monitorInstanceId))
  add(query_564208, "api-version", newJString(apiVersion))
  add(path_564207, "resourceType", newJString(resourceType))
  add(query_564208, "$select", newJString(Select))
  add(query_564208, "$expand", newJString(Expand))
  add(path_564207, "subscriptionId", newJString(subscriptionId))
  add(path_564207, "resourceNamespace", newJString(resourceNamespace))
  add(path_564207, "resourceGroupName", newJString(resourceGroupName))
  add(path_564207, "resourceName", newJString(resourceName))
  result = call_564206.call(path_564207, query_564208, nil, nil, nil)

var monitorInstancesGet* = Call_MonitorInstancesGet_564193(
    name: "monitorInstancesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitorInstances/{monitorInstanceId}",
    validator: validate_MonitorInstancesGet_564194, base: "",
    url: url_MonitorInstancesGet_564195, schemes: {Scheme.Https})
type
  Call_MonitorsListByResource_564209 = ref object of OpenApiRestCall_563556
proc url_MonitorsListByResource_564211(protocol: Scheme; host: string; base: string;
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

proc validate_MonitorsListByResource_564210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564212 = path.getOrDefault("resourceType")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "resourceType", valid_564212
  var valid_564213 = path.getOrDefault("subscriptionId")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "subscriptionId", valid_564213
  var valid_564214 = path.getOrDefault("resourceNamespace")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "resourceNamespace", valid_564214
  var valid_564215 = path.getOrDefault("resourceGroupName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "resourceGroupName", valid_564215
  var valid_564216 = path.getOrDefault("resourceName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "resourceName", valid_564216
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
  var valid_564217 = query.getOrDefault("api-version")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_564217 != nil:
    section.add "api-version", valid_564217
  var valid_564218 = query.getOrDefault("$skiptoken")
  valid_564218 = validateParameter(valid_564218, JString, required = false,
                                 default = nil)
  if valid_564218 != nil:
    section.add "$skiptoken", valid_564218
  var valid_564219 = query.getOrDefault("$filter")
  valid_564219 = validateParameter(valid_564219, JString, required = false,
                                 default = nil)
  if valid_564219 != nil:
    section.add "$filter", valid_564219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564220: Call_MonitorsListByResource_564209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_MonitorsListByResource_564209; resourceType: string;
          subscriptionId: string; resourceNamespace: string;
          resourceGroupName: string; resourceName: string;
          apiVersion: string = "2018-08-31-preview"; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## monitorsListByResource
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564222 = newJObject()
  var query_564223 = newJObject()
  add(query_564223, "api-version", newJString(apiVersion))
  add(path_564222, "resourceType", newJString(resourceType))
  add(path_564222, "subscriptionId", newJString(subscriptionId))
  add(path_564222, "resourceNamespace", newJString(resourceNamespace))
  add(query_564223, "$skiptoken", newJString(Skiptoken))
  add(path_564222, "resourceGroupName", newJString(resourceGroupName))
  add(query_564223, "$filter", newJString(Filter))
  add(path_564222, "resourceName", newJString(resourceName))
  result = call_564221.call(path_564222, query_564223, nil, nil, nil)

var monitorsListByResource* = Call_MonitorsListByResource_564209(
    name: "monitorsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitors",
    validator: validate_MonitorsListByResource_564210, base: "",
    url: url_MonitorsListByResource_564211, schemes: {Scheme.Https})
type
  Call_MonitorsGet_564224 = ref object of OpenApiRestCall_563556
proc url_MonitorsGet_564226(protocol: Scheme; host: string; base: string;
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

proc validate_MonitorsGet_564225(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   monitorId: JString (required)
  ##            : Monitor Id.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564227 = path.getOrDefault("resourceType")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "resourceType", valid_564227
  var valid_564228 = path.getOrDefault("subscriptionId")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "subscriptionId", valid_564228
  var valid_564229 = path.getOrDefault("resourceNamespace")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceNamespace", valid_564229
  var valid_564230 = path.getOrDefault("resourceGroupName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "resourceGroupName", valid_564230
  var valid_564231 = path.getOrDefault("monitorId")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "monitorId", valid_564231
  var valid_564232 = path.getOrDefault("resourceName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "resourceName", valid_564232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564233 = query.getOrDefault("api-version")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_564233 != nil:
    section.add "api-version", valid_564233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564234: Call_MonitorsGet_564224; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564234.validator(path, query, header, formData, body)
  let scheme = call_564234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564234.url(scheme.get, call_564234.host, call_564234.base,
                         call_564234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564234, url, valid)

proc call*(call_564235: Call_MonitorsGet_564224; resourceType: string;
          subscriptionId: string; resourceNamespace: string;
          resourceGroupName: string; monitorId: string; resourceName: string;
          apiVersion: string = "2018-08-31-preview"): Recallable =
  ## monitorsGet
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   monitorId: string (required)
  ##            : Monitor Id.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564236 = newJObject()
  var query_564237 = newJObject()
  add(query_564237, "api-version", newJString(apiVersion))
  add(path_564236, "resourceType", newJString(resourceType))
  add(path_564236, "subscriptionId", newJString(subscriptionId))
  add(path_564236, "resourceNamespace", newJString(resourceNamespace))
  add(path_564236, "resourceGroupName", newJString(resourceGroupName))
  add(path_564236, "monitorId", newJString(monitorId))
  add(path_564236, "resourceName", newJString(resourceName))
  result = call_564235.call(path_564236, query_564237, nil, nil, nil)

var monitorsGet* = Call_MonitorsGet_564224(name: "monitorsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitors/{monitorId}",
                                        validator: validate_MonitorsGet_564225,
                                        base: "", url: url_MonitorsGet_564226,
                                        schemes: {Scheme.Https})
type
  Call_MonitorsUpdate_564238 = ref object of OpenApiRestCall_563556
proc url_MonitorsUpdate_564240(protocol: Scheme; host: string; base: string;
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

proc validate_MonitorsUpdate_564239(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   monitorId: JString (required)
  ##            : Monitor Id.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564241 = path.getOrDefault("resourceType")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "resourceType", valid_564241
  var valid_564242 = path.getOrDefault("subscriptionId")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "subscriptionId", valid_564242
  var valid_564243 = path.getOrDefault("resourceNamespace")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "resourceNamespace", valid_564243
  var valid_564244 = path.getOrDefault("resourceGroupName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "resourceGroupName", valid_564244
  var valid_564245 = path.getOrDefault("monitorId")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "monitorId", valid_564245
  var valid_564246 = path.getOrDefault("resourceName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "resourceName", valid_564246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564247 = query.getOrDefault("api-version")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_564247 != nil:
    section.add "api-version", valid_564247
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

proc call*(call_564249: Call_MonitorsUpdate_564238; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564249.validator(path, query, header, formData, body)
  let scheme = call_564249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564249.url(scheme.get, call_564249.host, call_564249.base,
                         call_564249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564249, url, valid)

proc call*(call_564250: Call_MonitorsUpdate_564238; resourceType: string;
          subscriptionId: string; resourceNamespace: string;
          resourceGroupName: string; monitorId: string; body: JsonNode;
          resourceName: string; apiVersion: string = "2018-08-31-preview"): Recallable =
  ## monitorsUpdate
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   monitorId: string (required)
  ##            : Monitor Id.
  ##   body: JObject (required)
  ##       : Body of the Monitor PATCH object.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564251 = newJObject()
  var query_564252 = newJObject()
  var body_564253 = newJObject()
  add(query_564252, "api-version", newJString(apiVersion))
  add(path_564251, "resourceType", newJString(resourceType))
  add(path_564251, "subscriptionId", newJString(subscriptionId))
  add(path_564251, "resourceNamespace", newJString(resourceNamespace))
  add(path_564251, "resourceGroupName", newJString(resourceGroupName))
  add(path_564251, "monitorId", newJString(monitorId))
  if body != nil:
    body_564253 = body
  add(path_564251, "resourceName", newJString(resourceName))
  result = call_564250.call(path_564251, query_564252, nil, nil, body_564253)

var monitorsUpdate* = Call_MonitorsUpdate_564238(name: "monitorsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitors/{monitorId}",
    validator: validate_MonitorsUpdate_564239, base: "", url: url_MonitorsUpdate_564240,
    schemes: {Scheme.Https})
type
  Call_NotificationSettingsListByResource_564254 = ref object of OpenApiRestCall_563556
proc url_NotificationSettingsListByResource_564256(protocol: Scheme; host: string;
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

proc validate_NotificationSettingsListByResource_564255(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564257 = path.getOrDefault("resourceType")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "resourceType", valid_564257
  var valid_564258 = path.getOrDefault("subscriptionId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "subscriptionId", valid_564258
  var valid_564259 = path.getOrDefault("resourceNamespace")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "resourceNamespace", valid_564259
  var valid_564260 = path.getOrDefault("resourceGroupName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "resourceGroupName", valid_564260
  var valid_564261 = path.getOrDefault("resourceName")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "resourceName", valid_564261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564262 = query.getOrDefault("api-version")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_564262 != nil:
    section.add "api-version", valid_564262
  var valid_564263 = query.getOrDefault("$skiptoken")
  valid_564263 = validateParameter(valid_564263, JString, required = false,
                                 default = nil)
  if valid_564263 != nil:
    section.add "$skiptoken", valid_564263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564264: Call_NotificationSettingsListByResource_564254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564264.validator(path, query, header, formData, body)
  let scheme = call_564264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564264.url(scheme.get, call_564264.host, call_564264.base,
                         call_564264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564264, url, valid)

proc call*(call_564265: Call_NotificationSettingsListByResource_564254;
          resourceType: string; subscriptionId: string; resourceNamespace: string;
          resourceGroupName: string; resourceName: string;
          apiVersion: string = "2018-08-31-preview"; Skiptoken: string = ""): Recallable =
  ## notificationSettingsListByResource
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564266 = newJObject()
  var query_564267 = newJObject()
  add(query_564267, "api-version", newJString(apiVersion))
  add(path_564266, "resourceType", newJString(resourceType))
  add(path_564266, "subscriptionId", newJString(subscriptionId))
  add(path_564266, "resourceNamespace", newJString(resourceNamespace))
  add(query_564267, "$skiptoken", newJString(Skiptoken))
  add(path_564266, "resourceGroupName", newJString(resourceGroupName))
  add(path_564266, "resourceName", newJString(resourceName))
  result = call_564265.call(path_564266, query_564267, nil, nil, nil)

var notificationSettingsListByResource* = Call_NotificationSettingsListByResource_564254(
    name: "notificationSettingsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/notificationSettings",
    validator: validate_NotificationSettingsListByResource_564255, base: "",
    url: url_NotificationSettingsListByResource_564256, schemes: {Scheme.Https})
type
  Call_NotificationSettingsUpdate_564282 = ref object of OpenApiRestCall_563556
proc url_NotificationSettingsUpdate_564284(protocol: Scheme; host: string;
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

proc validate_NotificationSettingsUpdate_564283(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   notificationSettingName: JString (required)
  ##                          : Default string modeled as parameter for URL to work correctly.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564285 = path.getOrDefault("resourceType")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "resourceType", valid_564285
  var valid_564286 = path.getOrDefault("subscriptionId")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "subscriptionId", valid_564286
  var valid_564287 = path.getOrDefault("notificationSettingName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = newJString("default"))
  if valid_564287 != nil:
    section.add "notificationSettingName", valid_564287
  var valid_564288 = path.getOrDefault("resourceNamespace")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "resourceNamespace", valid_564288
  var valid_564289 = path.getOrDefault("resourceGroupName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "resourceGroupName", valid_564289
  var valid_564290 = path.getOrDefault("resourceName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "resourceName", valid_564290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564291 = query.getOrDefault("api-version")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_564291 != nil:
    section.add "api-version", valid_564291
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

proc call*(call_564293: Call_NotificationSettingsUpdate_564282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_NotificationSettingsUpdate_564282;
          resourceType: string; subscriptionId: string; resourceNamespace: string;
          resourceGroupName: string; body: JsonNode; resourceName: string;
          apiVersion: string = "2018-08-31-preview";
          notificationSettingName: string = "default"): Recallable =
  ## notificationSettingsUpdate
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   notificationSettingName: string (required)
  ##                          : Default string modeled as parameter for URL to work correctly.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   body: JObject (required)
  ##       : Body of the NotificationSetting PUT object.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564295 = newJObject()
  var query_564296 = newJObject()
  var body_564297 = newJObject()
  add(query_564296, "api-version", newJString(apiVersion))
  add(path_564295, "resourceType", newJString(resourceType))
  add(path_564295, "subscriptionId", newJString(subscriptionId))
  add(path_564295, "notificationSettingName", newJString(notificationSettingName))
  add(path_564295, "resourceNamespace", newJString(resourceNamespace))
  add(path_564295, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564297 = body
  add(path_564295, "resourceName", newJString(resourceName))
  result = call_564294.call(path_564295, query_564296, nil, nil, body_564297)

var notificationSettingsUpdate* = Call_NotificationSettingsUpdate_564282(
    name: "notificationSettingsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/notificationSettings/{notificationSettingName}",
    validator: validate_NotificationSettingsUpdate_564283, base: "",
    url: url_NotificationSettingsUpdate_564284, schemes: {Scheme.Https})
type
  Call_NotificationSettingsGet_564268 = ref object of OpenApiRestCall_563556
proc url_NotificationSettingsGet_564270(protocol: Scheme; host: string; base: string;
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

proc validate_NotificationSettingsGet_564269(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   notificationSettingName: JString (required)
  ##                          : Default string modeled as parameter for URL to work correctly.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564271 = path.getOrDefault("resourceType")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "resourceType", valid_564271
  var valid_564272 = path.getOrDefault("subscriptionId")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "subscriptionId", valid_564272
  var valid_564273 = path.getOrDefault("notificationSettingName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = newJString("default"))
  if valid_564273 != nil:
    section.add "notificationSettingName", valid_564273
  var valid_564274 = path.getOrDefault("resourceNamespace")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "resourceNamespace", valid_564274
  var valid_564275 = path.getOrDefault("resourceGroupName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "resourceGroupName", valid_564275
  var valid_564276 = path.getOrDefault("resourceName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "resourceName", valid_564276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564277 = query.getOrDefault("api-version")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_564277 != nil:
    section.add "api-version", valid_564277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564278: Call_NotificationSettingsGet_564268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564278.validator(path, query, header, formData, body)
  let scheme = call_564278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564278.url(scheme.get, call_564278.host, call_564278.base,
                         call_564278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564278, url, valid)

proc call*(call_564279: Call_NotificationSettingsGet_564268; resourceType: string;
          subscriptionId: string; resourceNamespace: string;
          resourceGroupName: string; resourceName: string;
          apiVersion: string = "2018-08-31-preview";
          notificationSettingName: string = "default"): Recallable =
  ## notificationSettingsGet
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   notificationSettingName: string (required)
  ##                          : Default string modeled as parameter for URL to work correctly.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564280 = newJObject()
  var query_564281 = newJObject()
  add(query_564281, "api-version", newJString(apiVersion))
  add(path_564280, "resourceType", newJString(resourceType))
  add(path_564280, "subscriptionId", newJString(subscriptionId))
  add(path_564280, "notificationSettingName", newJString(notificationSettingName))
  add(path_564280, "resourceNamespace", newJString(resourceNamespace))
  add(path_564280, "resourceGroupName", newJString(resourceGroupName))
  add(path_564280, "resourceName", newJString(resourceName))
  result = call_564279.call(path_564280, query_564281, nil, nil, nil)

var notificationSettingsGet* = Call_NotificationSettingsGet_564268(
    name: "notificationSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/notificationSettings/{notificationSettingName}",
    validator: validate_NotificationSettingsGet_564269, base: "",
    url: url_NotificationSettingsGet_564270, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
