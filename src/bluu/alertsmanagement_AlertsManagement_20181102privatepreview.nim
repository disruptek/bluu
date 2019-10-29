
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Alerts Management Service Resource Provider
## version: 2018-11-02-privatepreview
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
      "2018-11-02-privatepreview"))
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
          apiVersion: string = "2018-11-02-privatepreview"): Recallable =
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
  Call_ActionRulesGetAllSubscription_564089 = ref object of OpenApiRestCall_563556
proc url_ActionRulesGetAllSubscription_564091(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.AlertsManagement/actionRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActionRulesGetAllSubscription_564090(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all action rules of the subscription and given input filters
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
  ##   monitorService: JString
  ##                 : filter by monitor service which is the source of the alert object.
  ##   targetResource: JString
  ##                 : filter by target resource
  ##   targetResourceType: JString
  ##                     : filter by target resource type
  ##   severity: JString
  ##           : filter by severity
  ##   targetResourceGroup: JString
  ##                      : filter by target resource group name
  section = newJObject()
  var valid_564107 = query.getOrDefault("monitorService")
  valid_564107 = validateParameter(valid_564107, JString, required = false,
                                 default = newJString("Platform"))
  if valid_564107 != nil:
    section.add "monitorService", valid_564107
  var valid_564108 = query.getOrDefault("targetResource")
  valid_564108 = validateParameter(valid_564108, JString, required = false,
                                 default = nil)
  if valid_564108 != nil:
    section.add "targetResource", valid_564108
  var valid_564109 = query.getOrDefault("targetResourceType")
  valid_564109 = validateParameter(valid_564109, JString, required = false,
                                 default = nil)
  if valid_564109 != nil:
    section.add "targetResourceType", valid_564109
  var valid_564110 = query.getOrDefault("severity")
  valid_564110 = validateParameter(valid_564110, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564110 != nil:
    section.add "severity", valid_564110
  var valid_564111 = query.getOrDefault("targetResourceGroup")
  valid_564111 = validateParameter(valid_564111, JString, required = false,
                                 default = nil)
  if valid_564111 != nil:
    section.add "targetResourceGroup", valid_564111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564112: Call_ActionRulesGetAllSubscription_564089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all action rules of the subscription and given input filters
  ## 
  let valid = call_564112.validator(path, query, header, formData, body)
  let scheme = call_564112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564112.url(scheme.get, call_564112.host, call_564112.base,
                         call_564112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564112, url, valid)

proc call*(call_564113: Call_ActionRulesGetAllSubscription_564089;
          subscriptionId: string; monitorService: string = "Platform";
          targetResource: string = ""; targetResourceType: string = "";
          severity: string = "Sev0"; targetResourceGroup: string = ""): Recallable =
  ## actionRulesGetAllSubscription
  ## List all action rules of the subscription and given input filters
  ##   monitorService: string
  ##                 : filter by monitor service which is the source of the alert object.
  ##   targetResource: string
  ##                 : filter by target resource
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   targetResourceType: string
  ##                     : filter by target resource type
  ##   severity: string
  ##           : filter by severity
  ##   targetResourceGroup: string
  ##                      : filter by target resource group name
  var path_564114 = newJObject()
  var query_564115 = newJObject()
  add(query_564115, "monitorService", newJString(monitorService))
  add(query_564115, "targetResource", newJString(targetResource))
  add(path_564114, "subscriptionId", newJString(subscriptionId))
  add(query_564115, "targetResourceType", newJString(targetResourceType))
  add(query_564115, "severity", newJString(severity))
  add(query_564115, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564113.call(path_564114, query_564115, nil, nil, nil)

var actionRulesGetAllSubscription* = Call_ActionRulesGetAllSubscription_564089(
    name: "actionRulesGetAllSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/actionRules",
    validator: validate_ActionRulesGetAllSubscription_564090, base: "",
    url: url_ActionRulesGetAllSubscription_564091, schemes: {Scheme.Https})
type
  Call_AlertsGetAll_564116 = ref object of OpenApiRestCall_563556
proc url_AlertsGetAll_564118(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetAll_564117(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564119 = path.getOrDefault("subscriptionId")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "subscriptionId", valid_564119
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
  var valid_564120 = query.getOrDefault("monitorCondition")
  valid_564120 = validateParameter(valid_564120, JString, required = false,
                                 default = newJString("Fired"))
  if valid_564120 != nil:
    section.add "monitorCondition", valid_564120
  var valid_564121 = query.getOrDefault("sortBy")
  valid_564121 = validateParameter(valid_564121, JString, required = false,
                                 default = newJString("name"))
  if valid_564121 != nil:
    section.add "sortBy", valid_564121
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564122 = query.getOrDefault("api-version")
  valid_564122 = validateParameter(valid_564122, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_564122 != nil:
    section.add "api-version", valid_564122
  var valid_564123 = query.getOrDefault("pageCount")
  valid_564123 = validateParameter(valid_564123, JInt, required = false, default = nil)
  if valid_564123 != nil:
    section.add "pageCount", valid_564123
  var valid_564124 = query.getOrDefault("monitorService")
  valid_564124 = validateParameter(valid_564124, JString, required = false,
                                 default = newJString("Platform"))
  if valid_564124 != nil:
    section.add "monitorService", valid_564124
  var valid_564125 = query.getOrDefault("alertState")
  valid_564125 = validateParameter(valid_564125, JString, required = false,
                                 default = newJString("New"))
  if valid_564125 != nil:
    section.add "alertState", valid_564125
  var valid_564126 = query.getOrDefault("targetResource")
  valid_564126 = validateParameter(valid_564126, JString, required = false,
                                 default = nil)
  if valid_564126 != nil:
    section.add "targetResource", valid_564126
  var valid_564127 = query.getOrDefault("includePayload")
  valid_564127 = validateParameter(valid_564127, JBool, required = false, default = nil)
  if valid_564127 != nil:
    section.add "includePayload", valid_564127
  var valid_564128 = query.getOrDefault("targetResourceType")
  valid_564128 = validateParameter(valid_564128, JString, required = false,
                                 default = nil)
  if valid_564128 != nil:
    section.add "targetResourceType", valid_564128
  var valid_564129 = query.getOrDefault("sortOrder")
  valid_564129 = validateParameter(valid_564129, JString, required = false,
                                 default = newJString("asc"))
  if valid_564129 != nil:
    section.add "sortOrder", valid_564129
  var valid_564130 = query.getOrDefault("timeRange")
  valid_564130 = validateParameter(valid_564130, JString, required = false,
                                 default = newJString("1h"))
  if valid_564130 != nil:
    section.add "timeRange", valid_564130
  var valid_564131 = query.getOrDefault("severity")
  valid_564131 = validateParameter(valid_564131, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564131 != nil:
    section.add "severity", valid_564131
  var valid_564132 = query.getOrDefault("smartGroupId")
  valid_564132 = validateParameter(valid_564132, JString, required = false,
                                 default = nil)
  if valid_564132 != nil:
    section.add "smartGroupId", valid_564132
  var valid_564133 = query.getOrDefault("targetResourceGroup")
  valid_564133 = validateParameter(valid_564133, JString, required = false,
                                 default = nil)
  if valid_564133 != nil:
    section.add "targetResourceGroup", valid_564133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564134: Call_AlertsGetAll_564116; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the existing alerts, where the results can be selective by passing multiple filter parameters including time range and sorted on specific fields. 
  ## 
  let valid = call_564134.validator(path, query, header, formData, body)
  let scheme = call_564134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564134.url(scheme.get, call_564134.host, call_564134.base,
                         call_564134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564134, url, valid)

proc call*(call_564135: Call_AlertsGetAll_564116; subscriptionId: string;
          monitorCondition: string = "Fired"; sortBy: string = "name";
          apiVersion: string = "2018-11-02-privatepreview"; pageCount: int = 0;
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
  var path_564136 = newJObject()
  var query_564137 = newJObject()
  add(query_564137, "monitorCondition", newJString(monitorCondition))
  add(query_564137, "sortBy", newJString(sortBy))
  add(query_564137, "api-version", newJString(apiVersion))
  add(query_564137, "pageCount", newJInt(pageCount))
  add(query_564137, "monitorService", newJString(monitorService))
  add(query_564137, "alertState", newJString(alertState))
  add(query_564137, "targetResource", newJString(targetResource))
  add(path_564136, "subscriptionId", newJString(subscriptionId))
  add(query_564137, "includePayload", newJBool(includePayload))
  add(query_564137, "targetResourceType", newJString(targetResourceType))
  add(query_564137, "sortOrder", newJString(sortOrder))
  add(query_564137, "timeRange", newJString(timeRange))
  add(query_564137, "severity", newJString(severity))
  add(query_564137, "smartGroupId", newJString(smartGroupId))
  add(query_564137, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564135.call(path_564136, query_564137, nil, nil, nil)

var alertsGetAll* = Call_AlertsGetAll_564116(name: "alertsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts",
    validator: validate_AlertsGetAll_564117, base: "", url: url_AlertsGetAll_564118,
    schemes: {Scheme.Https})
type
  Call_AlertsGetById_564138 = ref object of OpenApiRestCall_563556
proc url_AlertsGetById_564140(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetById_564139(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564141 = path.getOrDefault("alertId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "alertId", valid_564141
  var valid_564142 = path.getOrDefault("subscriptionId")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "subscriptionId", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_AlertsGetById_564138; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific alert
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_AlertsGetById_564138; alertId: string;
          subscriptionId: string; apiVersion: string = "2018-11-02-privatepreview"): Recallable =
  ## alertsGetById
  ## Get information related to a specific alert
  ##   alertId: string (required)
  ##          : Unique ID of an alert object.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(path_564146, "alertId", newJString(alertId))
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var alertsGetById* = Call_AlertsGetById_564138(name: "alertsGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}",
    validator: validate_AlertsGetById_564139, base: "", url: url_AlertsGetById_564140,
    schemes: {Scheme.Https})
type
  Call_AlertsChangeState_564148 = ref object of OpenApiRestCall_563556
proc url_AlertsChangeState_564150(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsChangeState_564149(path: JsonNode; query: JsonNode;
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
  var valid_564151 = path.getOrDefault("alertId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "alertId", valid_564151
  var valid_564152 = path.getOrDefault("subscriptionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "subscriptionId", valid_564152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   newState: JString (required)
  ##           : filter by state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564153 = query.getOrDefault("api-version")
  valid_564153 = validateParameter(valid_564153, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_564153 != nil:
    section.add "api-version", valid_564153
  var valid_564154 = query.getOrDefault("newState")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = newJString("New"))
  if valid_564154 != nil:
    section.add "newState", valid_564154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564155: Call_AlertsChangeState_564148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of the alert.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_AlertsChangeState_564148; alertId: string;
          subscriptionId: string;
          apiVersion: string = "2018-11-02-privatepreview"; newState: string = "New"): Recallable =
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
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  add(path_564157, "alertId", newJString(alertId))
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(query_564158, "newState", newJString(newState))
  result = call_564156.call(path_564157, query_564158, nil, nil, nil)

var alertsChangeState* = Call_AlertsChangeState_564148(name: "alertsChangeState",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/changestate",
    validator: validate_AlertsChangeState_564149, base: "",
    url: url_AlertsChangeState_564150, schemes: {Scheme.Https})
type
  Call_AlertsGetHistory_564159 = ref object of OpenApiRestCall_563556
proc url_AlertsGetHistory_564161(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetHistory_564160(path: JsonNode; query: JsonNode;
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
  var valid_564162 = path.getOrDefault("alertId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "alertId", valid_564162
  var valid_564163 = path.getOrDefault("subscriptionId")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "subscriptionId", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_564164 != nil:
    section.add "api-version", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_AlertsGetHistory_564159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history of the changes of an alert.
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_AlertsGetHistory_564159; alertId: string;
          subscriptionId: string; apiVersion: string = "2018-11-02-privatepreview"): Recallable =
  ## alertsGetHistory
  ## Get the history of the changes of an alert.
  ##   alertId: string (required)
  ##          : Unique ID of an alert object.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(path_564167, "alertId", newJString(alertId))
  add(query_564168, "api-version", newJString(apiVersion))
  add(path_564167, "subscriptionId", newJString(subscriptionId))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var alertsGetHistory* = Call_AlertsGetHistory_564159(name: "alertsGetHistory",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/history",
    validator: validate_AlertsGetHistory_564160, base: "",
    url: url_AlertsGetHistory_564161, schemes: {Scheme.Https})
type
  Call_AlertsGetSummary_564169 = ref object of OpenApiRestCall_563556
proc url_AlertsGetSummary_564171(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetSummary_564170(path: JsonNode; query: JsonNode;
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
  var valid_564172 = path.getOrDefault("subscriptionId")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "subscriptionId", valid_564172
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
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_564173 != nil:
    section.add "api-version", valid_564173
  var valid_564174 = query.getOrDefault("timeRange")
  valid_564174 = validateParameter(valid_564174, JString, required = false,
                                 default = newJString("1h"))
  if valid_564174 != nil:
    section.add "timeRange", valid_564174
  var valid_564175 = query.getOrDefault("targetResourceGroup")
  valid_564175 = validateParameter(valid_564175, JString, required = false,
                                 default = nil)
  if valid_564175 != nil:
    section.add "targetResourceGroup", valid_564175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564176: Call_AlertsGetSummary_564169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Summary of alerts with the count each severity.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_AlertsGetSummary_564169; subscriptionId: string;
          apiVersion: string = "2018-11-02-privatepreview";
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
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  add(query_564179, "api-version", newJString(apiVersion))
  add(path_564178, "subscriptionId", newJString(subscriptionId))
  add(query_564179, "timeRange", newJString(timeRange))
  add(query_564179, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564177.call(path_564178, query_564179, nil, nil, nil)

var alertsGetSummary* = Call_AlertsGetSummary_564169(name: "alertsGetSummary",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alertsSummary",
    validator: validate_AlertsGetSummary_564170, base: "",
    url: url_AlertsGetSummary_564171, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetAll_564180 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetAll_564182(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetAll_564181(path: JsonNode; query: JsonNode;
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
  var valid_564183 = path.getOrDefault("subscriptionId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "subscriptionId", valid_564183
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
  var valid_564184 = query.getOrDefault("monitorCondition")
  valid_564184 = validateParameter(valid_564184, JString, required = false,
                                 default = newJString("Fired"))
  if valid_564184 != nil:
    section.add "monitorCondition", valid_564184
  var valid_564185 = query.getOrDefault("sortBy")
  valid_564185 = validateParameter(valid_564185, JString, required = false,
                                 default = newJString("alertsCount"))
  if valid_564185 != nil:
    section.add "sortBy", valid_564185
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_564186 != nil:
    section.add "api-version", valid_564186
  var valid_564187 = query.getOrDefault("pageCount")
  valid_564187 = validateParameter(valid_564187, JInt, required = false, default = nil)
  if valid_564187 != nil:
    section.add "pageCount", valid_564187
  var valid_564188 = query.getOrDefault("monitorService")
  valid_564188 = validateParameter(valid_564188, JString, required = false,
                                 default = newJString("Platform"))
  if valid_564188 != nil:
    section.add "monitorService", valid_564188
  var valid_564189 = query.getOrDefault("smartGroupState")
  valid_564189 = validateParameter(valid_564189, JString, required = false,
                                 default = newJString("New"))
  if valid_564189 != nil:
    section.add "smartGroupState", valid_564189
  var valid_564190 = query.getOrDefault("targetResource")
  valid_564190 = validateParameter(valid_564190, JString, required = false,
                                 default = nil)
  if valid_564190 != nil:
    section.add "targetResource", valid_564190
  var valid_564191 = query.getOrDefault("targetResourceType")
  valid_564191 = validateParameter(valid_564191, JString, required = false,
                                 default = nil)
  if valid_564191 != nil:
    section.add "targetResourceType", valid_564191
  var valid_564192 = query.getOrDefault("sortOrder")
  valid_564192 = validateParameter(valid_564192, JString, required = false,
                                 default = newJString("asc"))
  if valid_564192 != nil:
    section.add "sortOrder", valid_564192
  var valid_564193 = query.getOrDefault("timeRange")
  valid_564193 = validateParameter(valid_564193, JString, required = false,
                                 default = newJString("1h"))
  if valid_564193 != nil:
    section.add "timeRange", valid_564193
  var valid_564194 = query.getOrDefault("severity")
  valid_564194 = validateParameter(valid_564194, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564194 != nil:
    section.add "severity", valid_564194
  var valid_564195 = query.getOrDefault("targetResourceGroup")
  valid_564195 = validateParameter(valid_564195, JString, required = false,
                                 default = nil)
  if valid_564195 != nil:
    section.add "targetResourceGroup", valid_564195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564196: Call_SmartGroupsGetAll_564180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the smartGroups within the specified subscription. 
  ## 
  let valid = call_564196.validator(path, query, header, formData, body)
  let scheme = call_564196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564196.url(scheme.get, call_564196.host, call_564196.base,
                         call_564196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564196, url, valid)

proc call*(call_564197: Call_SmartGroupsGetAll_564180; subscriptionId: string;
          monitorCondition: string = "Fired"; sortBy: string = "alertsCount";
          apiVersion: string = "2018-11-02-privatepreview"; pageCount: int = 0;
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
  var path_564198 = newJObject()
  var query_564199 = newJObject()
  add(query_564199, "monitorCondition", newJString(monitorCondition))
  add(query_564199, "sortBy", newJString(sortBy))
  add(query_564199, "api-version", newJString(apiVersion))
  add(query_564199, "pageCount", newJInt(pageCount))
  add(query_564199, "monitorService", newJString(monitorService))
  add(query_564199, "smartGroupState", newJString(smartGroupState))
  add(query_564199, "targetResource", newJString(targetResource))
  add(path_564198, "subscriptionId", newJString(subscriptionId))
  add(query_564199, "targetResourceType", newJString(targetResourceType))
  add(query_564199, "sortOrder", newJString(sortOrder))
  add(query_564199, "timeRange", newJString(timeRange))
  add(query_564199, "severity", newJString(severity))
  add(query_564199, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564197.call(path_564198, query_564199, nil, nil, nil)

var smartGroupsGetAll* = Call_SmartGroupsGetAll_564180(name: "smartGroupsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups",
    validator: validate_SmartGroupsGetAll_564181, base: "",
    url: url_SmartGroupsGetAll_564182, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetById_564200 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetById_564202(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetById_564201(path: JsonNode; query: JsonNode;
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
  var valid_564203 = path.getOrDefault("subscriptionId")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "subscriptionId", valid_564203
  var valid_564204 = path.getOrDefault("smartGroupId")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "smartGroupId", valid_564204
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564205 = query.getOrDefault("api-version")
  valid_564205 = validateParameter(valid_564205, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_564205 != nil:
    section.add "api-version", valid_564205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564206: Call_SmartGroupsGetById_564200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of smart group.
  ## 
  let valid = call_564206.validator(path, query, header, formData, body)
  let scheme = call_564206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564206.url(scheme.get, call_564206.host, call_564206.base,
                         call_564206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564206, url, valid)

proc call*(call_564207: Call_SmartGroupsGetById_564200; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2018-11-02-privatepreview"): Recallable =
  ## smartGroupsGetById
  ## Get details of smart group.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart Group Id
  var path_564208 = newJObject()
  var query_564209 = newJObject()
  add(query_564209, "api-version", newJString(apiVersion))
  add(path_564208, "subscriptionId", newJString(subscriptionId))
  add(path_564208, "smartGroupId", newJString(smartGroupId))
  result = call_564207.call(path_564208, query_564209, nil, nil, nil)

var smartGroupsGetById* = Call_SmartGroupsGetById_564200(
    name: "smartGroupsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}",
    validator: validate_SmartGroupsGetById_564201, base: "",
    url: url_SmartGroupsGetById_564202, schemes: {Scheme.Https})
type
  Call_SmartGroupsChangeState_564210 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsChangeState_564212(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsChangeState_564211(path: JsonNode; query: JsonNode;
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
  var valid_564213 = path.getOrDefault("subscriptionId")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "subscriptionId", valid_564213
  var valid_564214 = path.getOrDefault("smartGroupId")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "smartGroupId", valid_564214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   newState: JString (required)
  ##           : filter by state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564215 = query.getOrDefault("api-version")
  valid_564215 = validateParameter(valid_564215, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_564215 != nil:
    section.add "api-version", valid_564215
  var valid_564216 = query.getOrDefault("newState")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = newJString("New"))
  if valid_564216 != nil:
    section.add "newState", valid_564216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564217: Call_SmartGroupsChangeState_564210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state from unresolved to resolved and all the alerts within the smart group will also be resolved.
  ## 
  let valid = call_564217.validator(path, query, header, formData, body)
  let scheme = call_564217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564217.url(scheme.get, call_564217.host, call_564217.base,
                         call_564217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564217, url, valid)

proc call*(call_564218: Call_SmartGroupsChangeState_564210; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2018-11-02-privatepreview";
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
  var path_564219 = newJObject()
  var query_564220 = newJObject()
  add(query_564220, "api-version", newJString(apiVersion))
  add(path_564219, "subscriptionId", newJString(subscriptionId))
  add(path_564219, "smartGroupId", newJString(smartGroupId))
  add(query_564220, "newState", newJString(newState))
  result = call_564218.call(path_564219, query_564220, nil, nil, nil)

var smartGroupsChangeState* = Call_SmartGroupsChangeState_564210(
    name: "smartGroupsChangeState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/changeState",
    validator: validate_SmartGroupsChangeState_564211, base: "",
    url: url_SmartGroupsChangeState_564212, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetHistory_564221 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetHistory_564223(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetHistory_564222(path: JsonNode; query: JsonNode;
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
  var valid_564224 = path.getOrDefault("subscriptionId")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "subscriptionId", valid_564224
  var valid_564225 = path.getOrDefault("smartGroupId")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "smartGroupId", valid_564225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564226 = query.getOrDefault("api-version")
  valid_564226 = validateParameter(valid_564226, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_564226 != nil:
    section.add "api-version", valid_564226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564227: Call_SmartGroupsGetHistory_564221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history of the changes of smart group.
  ## 
  let valid = call_564227.validator(path, query, header, formData, body)
  let scheme = call_564227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564227.url(scheme.get, call_564227.host, call_564227.base,
                         call_564227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564227, url, valid)

proc call*(call_564228: Call_SmartGroupsGetHistory_564221; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2018-11-02-privatepreview"): Recallable =
  ## smartGroupsGetHistory
  ## Get the history of the changes of smart group.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart Group Id
  var path_564229 = newJObject()
  var query_564230 = newJObject()
  add(query_564230, "api-version", newJString(apiVersion))
  add(path_564229, "subscriptionId", newJString(subscriptionId))
  add(path_564229, "smartGroupId", newJString(smartGroupId))
  result = call_564228.call(path_564229, query_564230, nil, nil, nil)

var smartGroupsGetHistory* = Call_SmartGroupsGetHistory_564221(
    name: "smartGroupsGetHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/history",
    validator: validate_SmartGroupsGetHistory_564222, base: "",
    url: url_SmartGroupsGetHistory_564223, schemes: {Scheme.Https})
type
  Call_ActionRulesGetAllResourceGroup_564231 = ref object of OpenApiRestCall_563556
proc url_ActionRulesGetAllResourceGroup_564233(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/actionRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActionRulesGetAllResourceGroup_564232(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all action rules of the subscription, created in given resource group and given input filters
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroup: JString (required)
  ##                : Resource group name where the resource is created.
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroup` field"
  var valid_564234 = path.getOrDefault("resourceGroup")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "resourceGroup", valid_564234
  var valid_564235 = path.getOrDefault("subscriptionId")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "subscriptionId", valid_564235
  result.add "path", section
  ## parameters in `query` object:
  ##   monitorService: JString
  ##                 : filter by monitor service which is the source of the alert object.
  ##   targetResource: JString
  ##                 : filter by target resource
  ##   targetResourceType: JString
  ##                     : filter by target resource type
  ##   severity: JString
  ##           : filter by severity
  ##   targetResourceGroup: JString
  ##                      : filter by target resource group name
  section = newJObject()
  var valid_564236 = query.getOrDefault("monitorService")
  valid_564236 = validateParameter(valid_564236, JString, required = false,
                                 default = newJString("Platform"))
  if valid_564236 != nil:
    section.add "monitorService", valid_564236
  var valid_564237 = query.getOrDefault("targetResource")
  valid_564237 = validateParameter(valid_564237, JString, required = false,
                                 default = nil)
  if valid_564237 != nil:
    section.add "targetResource", valid_564237
  var valid_564238 = query.getOrDefault("targetResourceType")
  valid_564238 = validateParameter(valid_564238, JString, required = false,
                                 default = nil)
  if valid_564238 != nil:
    section.add "targetResourceType", valid_564238
  var valid_564239 = query.getOrDefault("severity")
  valid_564239 = validateParameter(valid_564239, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564239 != nil:
    section.add "severity", valid_564239
  var valid_564240 = query.getOrDefault("targetResourceGroup")
  valid_564240 = validateParameter(valid_564240, JString, required = false,
                                 default = nil)
  if valid_564240 != nil:
    section.add "targetResourceGroup", valid_564240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564241: Call_ActionRulesGetAllResourceGroup_564231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all action rules of the subscription, created in given resource group and given input filters
  ## 
  let valid = call_564241.validator(path, query, header, formData, body)
  let scheme = call_564241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564241.url(scheme.get, call_564241.host, call_564241.base,
                         call_564241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564241, url, valid)

proc call*(call_564242: Call_ActionRulesGetAllResourceGroup_564231;
          resourceGroup: string; subscriptionId: string;
          monitorService: string = "Platform"; targetResource: string = "";
          targetResourceType: string = ""; severity: string = "Sev0";
          targetResourceGroup: string = ""): Recallable =
  ## actionRulesGetAllResourceGroup
  ## List all action rules of the subscription, created in given resource group and given input filters
  ##   resourceGroup: string (required)
  ##                : Resource group name where the resource is created.
  ##   monitorService: string
  ##                 : filter by monitor service which is the source of the alert object.
  ##   targetResource: string
  ##                 : filter by target resource
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   targetResourceType: string
  ##                     : filter by target resource type
  ##   severity: string
  ##           : filter by severity
  ##   targetResourceGroup: string
  ##                      : filter by target resource group name
  var path_564243 = newJObject()
  var query_564244 = newJObject()
  add(path_564243, "resourceGroup", newJString(resourceGroup))
  add(query_564244, "monitorService", newJString(monitorService))
  add(query_564244, "targetResource", newJString(targetResource))
  add(path_564243, "subscriptionId", newJString(subscriptionId))
  add(query_564244, "targetResourceType", newJString(targetResourceType))
  add(query_564244, "severity", newJString(severity))
  add(query_564244, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564242.call(path_564243, query_564244, nil, nil, nil)

var actionRulesGetAllResourceGroup* = Call_ActionRulesGetAllResourceGroup_564231(
    name: "actionRulesGetAllResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/actionRules",
    validator: validate_ActionRulesGetAllResourceGroup_564232, base: "",
    url: url_ActionRulesGetAllResourceGroup_564233, schemes: {Scheme.Https})
type
  Call_ActionRulesCreateUpdate_564254 = ref object of OpenApiRestCall_563556
proc url_ActionRulesCreateUpdate_564256(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "actionRuleName" in path, "`actionRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/actionRules/"),
               (kind: VariableSegment, value: "actionRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActionRulesCreateUpdate_564255(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates/Updates a specific action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroup: JString (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: JString (required)
  ##                 : The name of action rule that needs to be created/updated
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroup` field"
  var valid_564274 = path.getOrDefault("resourceGroup")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "resourceGroup", valid_564274
  var valid_564275 = path.getOrDefault("actionRuleName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "actionRuleName", valid_564275
  var valid_564276 = path.getOrDefault("subscriptionId")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "subscriptionId", valid_564276
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   actionRule: JObject (required)
  ##             : action rule to be created/updated
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564278: Call_ActionRulesCreateUpdate_564254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates/Updates a specific action rule
  ## 
  let valid = call_564278.validator(path, query, header, formData, body)
  let scheme = call_564278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564278.url(scheme.get, call_564278.host, call_564278.base,
                         call_564278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564278, url, valid)

proc call*(call_564279: Call_ActionRulesCreateUpdate_564254; actionRule: JsonNode;
          resourceGroup: string; actionRuleName: string; subscriptionId: string): Recallable =
  ## actionRulesCreateUpdate
  ## Creates/Updates a specific action rule
  ##   actionRule: JObject (required)
  ##             : action rule to be created/updated
  ##   resourceGroup: string (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: string (required)
  ##                 : The name of action rule that needs to be created/updated
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564280 = newJObject()
  var body_564281 = newJObject()
  if actionRule != nil:
    body_564281 = actionRule
  add(path_564280, "resourceGroup", newJString(resourceGroup))
  add(path_564280, "actionRuleName", newJString(actionRuleName))
  add(path_564280, "subscriptionId", newJString(subscriptionId))
  result = call_564279.call(path_564280, nil, nil, nil, body_564281)

var actionRulesCreateUpdate* = Call_ActionRulesCreateUpdate_564254(
    name: "actionRulesCreateUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesCreateUpdate_564255, base: "",
    url: url_ActionRulesCreateUpdate_564256, schemes: {Scheme.Https})
type
  Call_ActionRulesGetByName_564245 = ref object of OpenApiRestCall_563556
proc url_ActionRulesGetByName_564247(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "actionRuleName" in path, "`actionRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/actionRules/"),
               (kind: VariableSegment, value: "actionRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActionRulesGetByName_564246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroup: JString (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: JString (required)
  ##                 : The name of action rule that needs to be fetched
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroup` field"
  var valid_564248 = path.getOrDefault("resourceGroup")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "resourceGroup", valid_564248
  var valid_564249 = path.getOrDefault("actionRuleName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "actionRuleName", valid_564249
  var valid_564250 = path.getOrDefault("subscriptionId")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "subscriptionId", valid_564250
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564251: Call_ActionRulesGetByName_564245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific action rule
  ## 
  let valid = call_564251.validator(path, query, header, formData, body)
  let scheme = call_564251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564251.url(scheme.get, call_564251.host, call_564251.base,
                         call_564251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564251, url, valid)

proc call*(call_564252: Call_ActionRulesGetByName_564245; resourceGroup: string;
          actionRuleName: string; subscriptionId: string): Recallable =
  ## actionRulesGetByName
  ## Get a specific action rule
  ##   resourceGroup: string (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: string (required)
  ##                 : The name of action rule that needs to be fetched
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564253 = newJObject()
  add(path_564253, "resourceGroup", newJString(resourceGroup))
  add(path_564253, "actionRuleName", newJString(actionRuleName))
  add(path_564253, "subscriptionId", newJString(subscriptionId))
  result = call_564252.call(path_564253, nil, nil, nil, nil)

var actionRulesGetByName* = Call_ActionRulesGetByName_564245(
    name: "actionRulesGetByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesGetByName_564246, base: "",
    url: url_ActionRulesGetByName_564247, schemes: {Scheme.Https})
type
  Call_ActionRulesPatch_564291 = ref object of OpenApiRestCall_563556
proc url_ActionRulesPatch_564293(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "actionRuleName" in path, "`actionRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/actionRules/"),
               (kind: VariableSegment, value: "actionRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActionRulesPatch_564292(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Update enabled flag and/or tags for the given action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroup: JString (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: JString (required)
  ##                 : The name that needs to be updated
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroup` field"
  var valid_564294 = path.getOrDefault("resourceGroup")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "resourceGroup", valid_564294
  var valid_564295 = path.getOrDefault("actionRuleName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "actionRuleName", valid_564295
  var valid_564296 = path.getOrDefault("subscriptionId")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "subscriptionId", valid_564296
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   actionRulePatch: JObject (required)
  ##                  : Parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564298: Call_ActionRulesPatch_564291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update enabled flag and/or tags for the given action rule
  ## 
  let valid = call_564298.validator(path, query, header, formData, body)
  let scheme = call_564298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564298.url(scheme.get, call_564298.host, call_564298.base,
                         call_564298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564298, url, valid)

proc call*(call_564299: Call_ActionRulesPatch_564291; resourceGroup: string;
          actionRuleName: string; subscriptionId: string; actionRulePatch: JsonNode): Recallable =
  ## actionRulesPatch
  ## Update enabled flag and/or tags for the given action rule
  ##   resourceGroup: string (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: string (required)
  ##                 : The name that needs to be updated
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   actionRulePatch: JObject (required)
  ##                  : Parameters supplied to the operation.
  var path_564300 = newJObject()
  var body_564301 = newJObject()
  add(path_564300, "resourceGroup", newJString(resourceGroup))
  add(path_564300, "actionRuleName", newJString(actionRuleName))
  add(path_564300, "subscriptionId", newJString(subscriptionId))
  if actionRulePatch != nil:
    body_564301 = actionRulePatch
  result = call_564299.call(path_564300, nil, nil, nil, body_564301)

var actionRulesPatch* = Call_ActionRulesPatch_564291(name: "actionRulesPatch",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesPatch_564292, base: "",
    url: url_ActionRulesPatch_564293, schemes: {Scheme.Https})
type
  Call_ActionRulesDelete_564282 = ref object of OpenApiRestCall_563556
proc url_ActionRulesDelete_564284(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "actionRuleName" in path, "`actionRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/actionRules/"),
               (kind: VariableSegment, value: "actionRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActionRulesDelete_564283(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a given action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroup: JString (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: JString (required)
  ##                 : The name that needs to be deleted
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroup` field"
  var valid_564285 = path.getOrDefault("resourceGroup")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "resourceGroup", valid_564285
  var valid_564286 = path.getOrDefault("actionRuleName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "actionRuleName", valid_564286
  var valid_564287 = path.getOrDefault("subscriptionId")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "subscriptionId", valid_564287
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564288: Call_ActionRulesDelete_564282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a given action rule
  ## 
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_ActionRulesDelete_564282; resourceGroup: string;
          actionRuleName: string; subscriptionId: string): Recallable =
  ## actionRulesDelete
  ## Deletes a given action rule
  ##   resourceGroup: string (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: string (required)
  ##                 : The name that needs to be deleted
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564290 = newJObject()
  add(path_564290, "resourceGroup", newJString(resourceGroup))
  add(path_564290, "actionRuleName", newJString(actionRuleName))
  add(path_564290, "subscriptionId", newJString(subscriptionId))
  result = call_564289.call(path_564290, nil, nil, nil, nil)

var actionRulesDelete* = Call_ActionRulesDelete_564282(name: "actionRulesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesDelete_564283, base: "",
    url: url_ActionRulesDelete_564284, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
