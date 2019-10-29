
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Alerts Management Service Resource Provider
## version: 2018-05-05-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## REST APIs for Azure Alerts Management Service.
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
  macServiceName = "alertsmanagement-AlertsManagement"
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
  ## List all operations available through Azure Alerts Management Resource Provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563954 = query.getOrDefault("api-version")
  valid_563954 = validateParameter(valid_563954, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_563954 != nil:
    section.add "api-version", valid_563954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563977: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all operations available through Azure Alerts Management Resource Provider.
  ## 
  let valid = call_563977.validator(path, query, header, formData, body)
  let scheme = call_563977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563977.url(scheme.get, call_563977.host, call_563977.base,
                         call_563977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563977, url, valid)

proc call*(call_564048: Call_OperationsList_563778;
          apiVersion: string = "2017-11-15-privatepreview"): Recallable =
  ## operationsList
  ## List all operations available through Azure Alerts Management Resource Provider.
  ##   apiVersion: string (required)
  ##             : client API version
  var query_564049 = newJObject()
  add(query_564049, "api-version", newJString(apiVersion))
  result = call_564048.call(nil, query_564049, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.AlertsManagement/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_AlertsGetAll_564089 = ref object of OpenApiRestCall_563556
proc url_AlertsGetAll_564091(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.AlertsManagement/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetAll_564090(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the existing alerts, where the results can be selective by passing multiple filter parameters including time range and sorted on specific fields. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564106 = path.getOrDefault("subscriptionId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "subscriptionId", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   monitorCondition: JString
  ##                   : filter by monitor condition which is the state of the alert at monitor service
  ##   sortBy: JString
  ##         : sort the query results by input field, default value is 'lastModifiedDateTime'.
  ##   api-version: JString (required)
  ##              : client API version
  ##   pageCount: JInt
  ##            : number of items per page, default value is '25'.
  ##   monitorService: JString
  ##                 : filter by monitor service which is the source of the alert object.
  ##   alertState: JString
  ##             : filter by state
  ##   targetResource: JString
  ##                 : filter by target resource
  ##   includePayload: JBool
  ##                 : include payload field content, default value is 'false'.
  ##   targetResourceType: JString
  ##                     : filter by target resource type
  ##   sortOrder: JString
  ##            : sort the query results order in either ascending or descending, default value is 'desc' for time fields and 'asc' for others.
  ##   timeRange: JString
  ##            : filter by time range, default value is 1 day
  ##   severity: JString
  ##           : filter by severity
  ##   smartGroupId: JString
  ##               : filter by smart Group Id
  ##   targetResourceGroup: JString
  ##                      : filter by target resource group name
  section = newJObject()
  var valid_564107 = query.getOrDefault("monitorCondition")
  valid_564107 = validateParameter(valid_564107, JString, required = false,
                                 default = newJString("Fired"))
  if valid_564107 != nil:
    section.add "monitorCondition", valid_564107
  var valid_564108 = query.getOrDefault("sortBy")
  valid_564108 = validateParameter(valid_564108, JString, required = false,
                                 default = newJString("name"))
  if valid_564108 != nil:
    section.add "sortBy", valid_564108
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564109 = query.getOrDefault("api-version")
  valid_564109 = validateParameter(valid_564109, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_564109 != nil:
    section.add "api-version", valid_564109
  var valid_564110 = query.getOrDefault("pageCount")
  valid_564110 = validateParameter(valid_564110, JInt, required = false, default = nil)
  if valid_564110 != nil:
    section.add "pageCount", valid_564110
  var valid_564111 = query.getOrDefault("monitorService")
  valid_564111 = validateParameter(valid_564111, JString, required = false,
                                 default = newJString("Platform"))
  if valid_564111 != nil:
    section.add "monitorService", valid_564111
  var valid_564112 = query.getOrDefault("alertState")
  valid_564112 = validateParameter(valid_564112, JString, required = false,
                                 default = newJString("New"))
  if valid_564112 != nil:
    section.add "alertState", valid_564112
  var valid_564113 = query.getOrDefault("targetResource")
  valid_564113 = validateParameter(valid_564113, JString, required = false,
                                 default = nil)
  if valid_564113 != nil:
    section.add "targetResource", valid_564113
  var valid_564114 = query.getOrDefault("includePayload")
  valid_564114 = validateParameter(valid_564114, JBool, required = false, default = nil)
  if valid_564114 != nil:
    section.add "includePayload", valid_564114
  var valid_564115 = query.getOrDefault("targetResourceType")
  valid_564115 = validateParameter(valid_564115, JString, required = false,
                                 default = nil)
  if valid_564115 != nil:
    section.add "targetResourceType", valid_564115
  var valid_564116 = query.getOrDefault("sortOrder")
  valid_564116 = validateParameter(valid_564116, JString, required = false,
                                 default = newJString("asc"))
  if valid_564116 != nil:
    section.add "sortOrder", valid_564116
  var valid_564117 = query.getOrDefault("timeRange")
  valid_564117 = validateParameter(valid_564117, JString, required = false,
                                 default = newJString("1h"))
  if valid_564117 != nil:
    section.add "timeRange", valid_564117
  var valid_564118 = query.getOrDefault("severity")
  valid_564118 = validateParameter(valid_564118, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564118 != nil:
    section.add "severity", valid_564118
  var valid_564119 = query.getOrDefault("smartGroupId")
  valid_564119 = validateParameter(valid_564119, JString, required = false,
                                 default = nil)
  if valid_564119 != nil:
    section.add "smartGroupId", valid_564119
  var valid_564120 = query.getOrDefault("targetResourceGroup")
  valid_564120 = validateParameter(valid_564120, JString, required = false,
                                 default = nil)
  if valid_564120 != nil:
    section.add "targetResourceGroup", valid_564120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564121: Call_AlertsGetAll_564089; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the existing alerts, where the results can be selective by passing multiple filter parameters including time range and sorted on specific fields. 
  ## 
  let valid = call_564121.validator(path, query, header, formData, body)
  let scheme = call_564121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564121.url(scheme.get, call_564121.host, call_564121.base,
                         call_564121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564121, url, valid)

proc call*(call_564122: Call_AlertsGetAll_564089; subscriptionId: string;
          monitorCondition: string = "Fired"; sortBy: string = "name";
          apiVersion: string = "2017-11-15-privatepreview"; pageCount: int = 0;
          monitorService: string = "Platform"; alertState: string = "New";
          targetResource: string = ""; includePayload: bool = false;
          targetResourceType: string = ""; sortOrder: string = "asc";
          timeRange: string = "1h"; severity: string = "Sev0";
          smartGroupId: string = ""; targetResourceGroup: string = ""): Recallable =
  ## alertsGetAll
  ## List all the existing alerts, where the results can be selective by passing multiple filter parameters including time range and sorted on specific fields. 
  ##   monitorCondition: string
  ##                   : filter by monitor condition which is the state of the alert at monitor service
  ##   sortBy: string
  ##         : sort the query results by input field, default value is 'lastModifiedDateTime'.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   pageCount: int
  ##            : number of items per page, default value is '25'.
  ##   monitorService: string
  ##                 : filter by monitor service which is the source of the alert object.
  ##   alertState: string
  ##             : filter by state
  ##   targetResource: string
  ##                 : filter by target resource
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   includePayload: bool
  ##                 : include payload field content, default value is 'false'.
  ##   targetResourceType: string
  ##                     : filter by target resource type
  ##   sortOrder: string
  ##            : sort the query results order in either ascending or descending, default value is 'desc' for time fields and 'asc' for others.
  ##   timeRange: string
  ##            : filter by time range, default value is 1 day
  ##   severity: string
  ##           : filter by severity
  ##   smartGroupId: string
  ##               : filter by smart Group Id
  ##   targetResourceGroup: string
  ##                      : filter by target resource group name
  var path_564123 = newJObject()
  var query_564124 = newJObject()
  add(query_564124, "monitorCondition", newJString(monitorCondition))
  add(query_564124, "sortBy", newJString(sortBy))
  add(query_564124, "api-version", newJString(apiVersion))
  add(query_564124, "pageCount", newJInt(pageCount))
  add(query_564124, "monitorService", newJString(monitorService))
  add(query_564124, "alertState", newJString(alertState))
  add(query_564124, "targetResource", newJString(targetResource))
  add(path_564123, "subscriptionId", newJString(subscriptionId))
  add(query_564124, "includePayload", newJBool(includePayload))
  add(query_564124, "targetResourceType", newJString(targetResourceType))
  add(query_564124, "sortOrder", newJString(sortOrder))
  add(query_564124, "timeRange", newJString(timeRange))
  add(query_564124, "severity", newJString(severity))
  add(query_564124, "smartGroupId", newJString(smartGroupId))
  add(query_564124, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564122.call(path_564123, query_564124, nil, nil, nil)

var alertsGetAll* = Call_AlertsGetAll_564089(name: "alertsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts",
    validator: validate_AlertsGetAll_564090, base: "", url: url_AlertsGetAll_564091,
    schemes: {Scheme.Https})
type
  Call_AlertsGetById_564125 = ref object of OpenApiRestCall_563556
proc url_AlertsGetById_564127(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetById_564126(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information related to a specific alert
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Unique ID of an alert object.
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564128 = path.getOrDefault("alertId")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "alertId", valid_564128
  var valid_564129 = path.getOrDefault("subscriptionId")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "subscriptionId", valid_564129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564130 = query.getOrDefault("api-version")
  valid_564130 = validateParameter(valid_564130, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_564130 != nil:
    section.add "api-version", valid_564130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564131: Call_AlertsGetById_564125; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific alert
  ## 
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_AlertsGetById_564125; alertId: string;
          subscriptionId: string; apiVersion: string = "2017-11-15-privatepreview"): Recallable =
  ## alertsGetById
  ## Get information related to a specific alert
  ##   alertId: string (required)
  ##          : Unique ID of an alert object.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564133 = newJObject()
  var query_564134 = newJObject()
  add(path_564133, "alertId", newJString(alertId))
  add(query_564134, "api-version", newJString(apiVersion))
  add(path_564133, "subscriptionId", newJString(subscriptionId))
  result = call_564132.call(path_564133, query_564134, nil, nil, nil)

var alertsGetById* = Call_AlertsGetById_564125(name: "alertsGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}",
    validator: validate_AlertsGetById_564126, base: "", url: url_AlertsGetById_564127,
    schemes: {Scheme.Https})
type
  Call_AlertsChangeState_564135 = ref object of OpenApiRestCall_563556
proc url_AlertsChangeState_564137(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/changestate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsChangeState_564136(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Change the state of the alert.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Unique ID of an alert object.
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564138 = path.getOrDefault("alertId")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "alertId", valid_564138
  var valid_564139 = path.getOrDefault("subscriptionId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "subscriptionId", valid_564139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   newState: JString (required)
  ##           : filter by state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564140 = query.getOrDefault("api-version")
  valid_564140 = validateParameter(valid_564140, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_564140 != nil:
    section.add "api-version", valid_564140
  var valid_564141 = query.getOrDefault("newState")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = newJString("New"))
  if valid_564141 != nil:
    section.add "newState", valid_564141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564142: Call_AlertsChangeState_564135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of the alert.
  ## 
  let valid = call_564142.validator(path, query, header, formData, body)
  let scheme = call_564142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564142.url(scheme.get, call_564142.host, call_564142.base,
                         call_564142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564142, url, valid)

proc call*(call_564143: Call_AlertsChangeState_564135; alertId: string;
          subscriptionId: string;
          apiVersion: string = "2017-11-15-privatepreview"; newState: string = "New"): Recallable =
  ## alertsChangeState
  ## Change the state of the alert.
  ##   alertId: string (required)
  ##          : Unique ID of an alert object.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   newState: string (required)
  ##           : filter by state
  var path_564144 = newJObject()
  var query_564145 = newJObject()
  add(path_564144, "alertId", newJString(alertId))
  add(query_564145, "api-version", newJString(apiVersion))
  add(path_564144, "subscriptionId", newJString(subscriptionId))
  add(query_564145, "newState", newJString(newState))
  result = call_564143.call(path_564144, query_564145, nil, nil, nil)

var alertsChangeState* = Call_AlertsChangeState_564135(name: "alertsChangeState",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/changestate",
    validator: validate_AlertsChangeState_564136, base: "",
    url: url_AlertsChangeState_564137, schemes: {Scheme.Https})
type
  Call_AlertsGetHistory_564146 = ref object of OpenApiRestCall_563556
proc url_AlertsGetHistory_564148(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/history")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetHistory_564147(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the history of the changes of an alert.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Unique ID of an alert object.
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564149 = path.getOrDefault("alertId")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "alertId", valid_564149
  var valid_564150 = path.getOrDefault("subscriptionId")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "subscriptionId", valid_564150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564152: Call_AlertsGetHistory_564146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history of the changes of an alert.
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_AlertsGetHistory_564146; alertId: string;
          subscriptionId: string; apiVersion: string = "2017-11-15-privatepreview"): Recallable =
  ## alertsGetHistory
  ## Get the history of the changes of an alert.
  ##   alertId: string (required)
  ##          : Unique ID of an alert object.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  add(path_564154, "alertId", newJString(alertId))
  add(query_564155, "api-version", newJString(apiVersion))
  add(path_564154, "subscriptionId", newJString(subscriptionId))
  result = call_564153.call(path_564154, query_564155, nil, nil, nil)

var alertsGetHistory* = Call_AlertsGetHistory_564146(name: "alertsGetHistory",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/history",
    validator: validate_AlertsGetHistory_564147, base: "",
    url: url_AlertsGetHistory_564148, schemes: {Scheme.Https})
type
  Call_AlertsGetSummary_564156 = ref object of OpenApiRestCall_563556
proc url_AlertsGetSummary_564158(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.AlertsManagement/alertsSummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetSummary_564157(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Summary of alerts with the count each severity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564159 = path.getOrDefault("subscriptionId")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "subscriptionId", valid_564159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   timeRange: JString
  ##            : filter by time range, default value is 1 day
  ##   targetResourceGroup: JString
  ##                      : filter by target resource group name
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564160 = query.getOrDefault("api-version")
  valid_564160 = validateParameter(valid_564160, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_564160 != nil:
    section.add "api-version", valid_564160
  var valid_564161 = query.getOrDefault("timeRange")
  valid_564161 = validateParameter(valid_564161, JString, required = false,
                                 default = newJString("1h"))
  if valid_564161 != nil:
    section.add "timeRange", valid_564161
  var valid_564162 = query.getOrDefault("targetResourceGroup")
  valid_564162 = validateParameter(valid_564162, JString, required = false,
                                 default = nil)
  if valid_564162 != nil:
    section.add "targetResourceGroup", valid_564162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564163: Call_AlertsGetSummary_564156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Summary of alerts with the count each severity.
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_AlertsGetSummary_564156; subscriptionId: string;
          apiVersion: string = "2017-11-15-privatepreview";
          timeRange: string = "1h"; targetResourceGroup: string = ""): Recallable =
  ## alertsGetSummary
  ## Summary of alerts with the count each severity.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   timeRange: string
  ##            : filter by time range, default value is 1 day
  ##   targetResourceGroup: string
  ##                      : filter by target resource group name
  var path_564165 = newJObject()
  var query_564166 = newJObject()
  add(query_564166, "api-version", newJString(apiVersion))
  add(path_564165, "subscriptionId", newJString(subscriptionId))
  add(query_564166, "timeRange", newJString(timeRange))
  add(query_564166, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564164.call(path_564165, query_564166, nil, nil, nil)

var alertsGetSummary* = Call_AlertsGetSummary_564156(name: "alertsGetSummary",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alertsSummary",
    validator: validate_AlertsGetSummary_564157, base: "",
    url: url_AlertsGetSummary_564158, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetAll_564167 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetAll_564169(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.AlertsManagement/smartGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SmartGroupsGetAll_564168(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List all the smartGroups within the specified subscription. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564170 = path.getOrDefault("subscriptionId")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "subscriptionId", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   monitorCondition: JString
  ##                   : filter by monitor condition which is the state of the alert at monitor service
  ##   sortBy: JString
  ##         : sort the query results by input field, default value is 'lastModifiedDateTime'.
  ##   api-version: JString (required)
  ##              : client API version
  ##   pageCount: JInt
  ##            : number of items per page, default value is '25'.
  ##   monitorService: JString
  ##                 : filter by monitor service which is the source of the alert object.
  ##   smartGroupState: JString
  ##                  : filter by state
  ##   targetResource: JString
  ##                 : filter by target resource
  ##   targetResourceType: JString
  ##                     : filter by target resource type
  ##   sortOrder: JString
  ##            : sort the query results order in either ascending or descending, default value is 'desc' for time fields and 'asc' for others.
  ##   timeRange: JString
  ##            : filter by time range, default value is 1 day
  ##   severity: JString
  ##           : filter by severity
  ##   targetResourceGroup: JString
  ##                      : filter by target resource group name
  section = newJObject()
  var valid_564171 = query.getOrDefault("monitorCondition")
  valid_564171 = validateParameter(valid_564171, JString, required = false,
                                 default = newJString("Fired"))
  if valid_564171 != nil:
    section.add "monitorCondition", valid_564171
  var valid_564172 = query.getOrDefault("sortBy")
  valid_564172 = validateParameter(valid_564172, JString, required = false,
                                 default = newJString("alertsCount"))
  if valid_564172 != nil:
    section.add "sortBy", valid_564172
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_564173 != nil:
    section.add "api-version", valid_564173
  var valid_564174 = query.getOrDefault("pageCount")
  valid_564174 = validateParameter(valid_564174, JInt, required = false, default = nil)
  if valid_564174 != nil:
    section.add "pageCount", valid_564174
  var valid_564175 = query.getOrDefault("monitorService")
  valid_564175 = validateParameter(valid_564175, JString, required = false,
                                 default = newJString("Platform"))
  if valid_564175 != nil:
    section.add "monitorService", valid_564175
  var valid_564176 = query.getOrDefault("smartGroupState")
  valid_564176 = validateParameter(valid_564176, JString, required = false,
                                 default = newJString("New"))
  if valid_564176 != nil:
    section.add "smartGroupState", valid_564176
  var valid_564177 = query.getOrDefault("targetResource")
  valid_564177 = validateParameter(valid_564177, JString, required = false,
                                 default = nil)
  if valid_564177 != nil:
    section.add "targetResource", valid_564177
  var valid_564178 = query.getOrDefault("targetResourceType")
  valid_564178 = validateParameter(valid_564178, JString, required = false,
                                 default = nil)
  if valid_564178 != nil:
    section.add "targetResourceType", valid_564178
  var valid_564179 = query.getOrDefault("sortOrder")
  valid_564179 = validateParameter(valid_564179, JString, required = false,
                                 default = newJString("asc"))
  if valid_564179 != nil:
    section.add "sortOrder", valid_564179
  var valid_564180 = query.getOrDefault("timeRange")
  valid_564180 = validateParameter(valid_564180, JString, required = false,
                                 default = newJString("1h"))
  if valid_564180 != nil:
    section.add "timeRange", valid_564180
  var valid_564181 = query.getOrDefault("severity")
  valid_564181 = validateParameter(valid_564181, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564181 != nil:
    section.add "severity", valid_564181
  var valid_564182 = query.getOrDefault("targetResourceGroup")
  valid_564182 = validateParameter(valid_564182, JString, required = false,
                                 default = nil)
  if valid_564182 != nil:
    section.add "targetResourceGroup", valid_564182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564183: Call_SmartGroupsGetAll_564167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the smartGroups within the specified subscription. 
  ## 
  let valid = call_564183.validator(path, query, header, formData, body)
  let scheme = call_564183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564183.url(scheme.get, call_564183.host, call_564183.base,
                         call_564183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564183, url, valid)

proc call*(call_564184: Call_SmartGroupsGetAll_564167; subscriptionId: string;
          monitorCondition: string = "Fired"; sortBy: string = "alertsCount";
          apiVersion: string = "2017-11-15-privatepreview"; pageCount: int = 0;
          monitorService: string = "Platform"; smartGroupState: string = "New";
          targetResource: string = ""; targetResourceType: string = "";
          sortOrder: string = "asc"; timeRange: string = "1h";
          severity: string = "Sev0"; targetResourceGroup: string = ""): Recallable =
  ## smartGroupsGetAll
  ## List all the smartGroups within the specified subscription. 
  ##   monitorCondition: string
  ##                   : filter by monitor condition which is the state of the alert at monitor service
  ##   sortBy: string
  ##         : sort the query results by input field, default value is 'lastModifiedDateTime'.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   pageCount: int
  ##            : number of items per page, default value is '25'.
  ##   monitorService: string
  ##                 : filter by monitor service which is the source of the alert object.
  ##   smartGroupState: string
  ##                  : filter by state
  ##   targetResource: string
  ##                 : filter by target resource
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   targetResourceType: string
  ##                     : filter by target resource type
  ##   sortOrder: string
  ##            : sort the query results order in either ascending or descending, default value is 'desc' for time fields and 'asc' for others.
  ##   timeRange: string
  ##            : filter by time range, default value is 1 day
  ##   severity: string
  ##           : filter by severity
  ##   targetResourceGroup: string
  ##                      : filter by target resource group name
  var path_564185 = newJObject()
  var query_564186 = newJObject()
  add(query_564186, "monitorCondition", newJString(monitorCondition))
  add(query_564186, "sortBy", newJString(sortBy))
  add(query_564186, "api-version", newJString(apiVersion))
  add(query_564186, "pageCount", newJInt(pageCount))
  add(query_564186, "monitorService", newJString(monitorService))
  add(query_564186, "smartGroupState", newJString(smartGroupState))
  add(query_564186, "targetResource", newJString(targetResource))
  add(path_564185, "subscriptionId", newJString(subscriptionId))
  add(query_564186, "targetResourceType", newJString(targetResourceType))
  add(query_564186, "sortOrder", newJString(sortOrder))
  add(query_564186, "timeRange", newJString(timeRange))
  add(query_564186, "severity", newJString(severity))
  add(query_564186, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564184.call(path_564185, query_564186, nil, nil, nil)

var smartGroupsGetAll* = Call_SmartGroupsGetAll_564167(name: "smartGroupsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups",
    validator: validate_SmartGroupsGetAll_564168, base: "",
    url: url_SmartGroupsGetAll_564169, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetById_564187 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetById_564189(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "smartGroupId" in path, "`smartGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/smartGroups/"),
               (kind: VariableSegment, value: "smartGroupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SmartGroupsGetById_564188(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get details of smart group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: JString (required)
  ##               : Smart Group Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564190 = path.getOrDefault("subscriptionId")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "subscriptionId", valid_564190
  var valid_564191 = path.getOrDefault("smartGroupId")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "smartGroupId", valid_564191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564192 = query.getOrDefault("api-version")
  valid_564192 = validateParameter(valid_564192, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_564192 != nil:
    section.add "api-version", valid_564192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564193: Call_SmartGroupsGetById_564187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of smart group.
  ## 
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_SmartGroupsGetById_564187; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2017-11-15-privatepreview"): Recallable =
  ## smartGroupsGetById
  ## Get details of smart group.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart Group Id
  var path_564195 = newJObject()
  var query_564196 = newJObject()
  add(query_564196, "api-version", newJString(apiVersion))
  add(path_564195, "subscriptionId", newJString(subscriptionId))
  add(path_564195, "smartGroupId", newJString(smartGroupId))
  result = call_564194.call(path_564195, query_564196, nil, nil, nil)

var smartGroupsGetById* = Call_SmartGroupsGetById_564187(
    name: "smartGroupsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}",
    validator: validate_SmartGroupsGetById_564188, base: "",
    url: url_SmartGroupsGetById_564189, schemes: {Scheme.Https})
type
  Call_SmartGroupsChangeState_564197 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsChangeState_564199(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "smartGroupId" in path, "`smartGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/smartGroups/"),
               (kind: VariableSegment, value: "smartGroupId"),
               (kind: ConstantSegment, value: "/changeState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SmartGroupsChangeState_564198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Change the state from unresolved to resolved and all the alerts within the smart group will also be resolved.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: JString (required)
  ##               : Smart Group Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564200 = path.getOrDefault("subscriptionId")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "subscriptionId", valid_564200
  var valid_564201 = path.getOrDefault("smartGroupId")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "smartGroupId", valid_564201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   newState: JString (required)
  ##           : filter by state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564202 = query.getOrDefault("api-version")
  valid_564202 = validateParameter(valid_564202, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_564202 != nil:
    section.add "api-version", valid_564202
  var valid_564203 = query.getOrDefault("newState")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = newJString("New"))
  if valid_564203 != nil:
    section.add "newState", valid_564203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564204: Call_SmartGroupsChangeState_564197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state from unresolved to resolved and all the alerts within the smart group will also be resolved.
  ## 
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_SmartGroupsChangeState_564197; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2017-11-15-privatepreview";
          newState: string = "New"): Recallable =
  ## smartGroupsChangeState
  ## Change the state from unresolved to resolved and all the alerts within the smart group will also be resolved.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart Group Id
  ##   newState: string (required)
  ##           : filter by state
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  add(query_564207, "api-version", newJString(apiVersion))
  add(path_564206, "subscriptionId", newJString(subscriptionId))
  add(path_564206, "smartGroupId", newJString(smartGroupId))
  add(query_564207, "newState", newJString(newState))
  result = call_564205.call(path_564206, query_564207, nil, nil, nil)

var smartGroupsChangeState* = Call_SmartGroupsChangeState_564197(
    name: "smartGroupsChangeState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/changeState",
    validator: validate_SmartGroupsChangeState_564198, base: "",
    url: url_SmartGroupsChangeState_564199, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetHistory_564208 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetHistory_564210(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "smartGroupId" in path, "`smartGroupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/smartGroups/"),
               (kind: VariableSegment, value: "smartGroupId"),
               (kind: ConstantSegment, value: "/history")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SmartGroupsGetHistory_564209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the history of the changes of smart group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: JString (required)
  ##               : Smart Group Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564211 = path.getOrDefault("subscriptionId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "subscriptionId", valid_564211
  var valid_564212 = path.getOrDefault("smartGroupId")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "smartGroupId", valid_564212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564213 = query.getOrDefault("api-version")
  valid_564213 = validateParameter(valid_564213, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_564213 != nil:
    section.add "api-version", valid_564213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564214: Call_SmartGroupsGetHistory_564208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history of the changes of smart group.
  ## 
  let valid = call_564214.validator(path, query, header, formData, body)
  let scheme = call_564214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564214.url(scheme.get, call_564214.host, call_564214.base,
                         call_564214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564214, url, valid)

proc call*(call_564215: Call_SmartGroupsGetHistory_564208; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2017-11-15-privatepreview"): Recallable =
  ## smartGroupsGetHistory
  ## Get the history of the changes of smart group.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart Group Id
  var path_564216 = newJObject()
  var query_564217 = newJObject()
  add(query_564217, "api-version", newJString(apiVersion))
  add(path_564216, "subscriptionId", newJString(subscriptionId))
  add(path_564216, "smartGroupId", newJString(smartGroupId))
  result = call_564215.call(path_564216, query_564217, nil, nil, nil)

var smartGroupsGetHistory* = Call_SmartGroupsGetHistory_564208(
    name: "smartGroupsGetHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/history",
    validator: validate_SmartGroupsGetHistory_564209, base: "",
    url: url_SmartGroupsGetHistory_564210, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
