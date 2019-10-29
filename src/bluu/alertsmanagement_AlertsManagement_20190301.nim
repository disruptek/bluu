
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Alerts Management Service Resource Provider
## version: 2019-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Alerts Management Service provides a single pane of glass of alerts across Azure Monitor.
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
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563954 = query.getOrDefault("api-version")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = newJString("2018-05-05"))
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
          apiVersion: string = "2018-05-05"): Recallable =
  ## operationsList
  ## List all operations available through Azure Alerts Management Resource Provider.
  ##   apiVersion: string (required)
  ##             : API version.
  var query_564049 = newJObject()
  add(query_564049, "api-version", newJString(apiVersion))
  result = call_564048.call(nil, query_564049, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.AlertsManagement/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_SmartGroupsGetAll_564089 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetAll_564091(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetAll_564090(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List all the Smart Groups within a specified subscription. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   sortBy: JString
  ##         : Sort the query results by input field. Default value is sort by 'lastModifiedDateTime'.
  ##   api-version: JString (required)
  ##              : API version.
  ##   pageCount: JInt
  ##            : Determines number of alerts returned per page in response. Permissible value is between 1 to 250. When the "includeContent"  filter is selected, maximum value allowed is 25. Default value is 25.
  ##   monitorService: JString
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   smartGroupState: JString
  ##                  : Filter by state of the smart group. Default value is to select all.
  ##   targetResource: JString
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   targetResourceType: JString
  ##                     : Filter by target resource type. Default value is select all.
  ##   sortOrder: JString
  ##            : Sort the query results order in either ascending or descending.  Default value is 'desc' for time fields and 'asc' for others.
  ##   timeRange: JString
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   severity: JString
  ##           : Filter by severity.  Default value is select all.
  ##   targetResourceGroup: JString
  ##                      : Filter by target resource group name. Default value is select all.
  section = newJObject()
  var valid_564107 = query.getOrDefault("monitorCondition")
  valid_564107 = validateParameter(valid_564107, JString, required = false,
                                 default = newJString("Fired"))
  if valid_564107 != nil:
    section.add "monitorCondition", valid_564107
  var valid_564108 = query.getOrDefault("sortBy")
  valid_564108 = validateParameter(valid_564108, JString, required = false,
                                 default = newJString("alertsCount"))
  if valid_564108 != nil:
    section.add "sortBy", valid_564108
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564109 = query.getOrDefault("api-version")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564109 != nil:
    section.add "api-version", valid_564109
  var valid_564110 = query.getOrDefault("pageCount")
  valid_564110 = validateParameter(valid_564110, JInt, required = false, default = nil)
  if valid_564110 != nil:
    section.add "pageCount", valid_564110
  var valid_564111 = query.getOrDefault("monitorService")
  valid_564111 = validateParameter(valid_564111, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_564111 != nil:
    section.add "monitorService", valid_564111
  var valid_564112 = query.getOrDefault("smartGroupState")
  valid_564112 = validateParameter(valid_564112, JString, required = false,
                                 default = newJString("New"))
  if valid_564112 != nil:
    section.add "smartGroupState", valid_564112
  var valid_564113 = query.getOrDefault("targetResource")
  valid_564113 = validateParameter(valid_564113, JString, required = false,
                                 default = nil)
  if valid_564113 != nil:
    section.add "targetResource", valid_564113
  var valid_564114 = query.getOrDefault("targetResourceType")
  valid_564114 = validateParameter(valid_564114, JString, required = false,
                                 default = nil)
  if valid_564114 != nil:
    section.add "targetResourceType", valid_564114
  var valid_564115 = query.getOrDefault("sortOrder")
  valid_564115 = validateParameter(valid_564115, JString, required = false,
                                 default = newJString("asc"))
  if valid_564115 != nil:
    section.add "sortOrder", valid_564115
  var valid_564116 = query.getOrDefault("timeRange")
  valid_564116 = validateParameter(valid_564116, JString, required = false,
                                 default = newJString("1h"))
  if valid_564116 != nil:
    section.add "timeRange", valid_564116
  var valid_564117 = query.getOrDefault("severity")
  valid_564117 = validateParameter(valid_564117, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564117 != nil:
    section.add "severity", valid_564117
  var valid_564118 = query.getOrDefault("targetResourceGroup")
  valid_564118 = validateParameter(valid_564118, JString, required = false,
                                 default = nil)
  if valid_564118 != nil:
    section.add "targetResourceGroup", valid_564118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564119: Call_SmartGroupsGetAll_564089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the Smart Groups within a specified subscription. 
  ## 
  let valid = call_564119.validator(path, query, header, formData, body)
  let scheme = call_564119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564119.url(scheme.get, call_564119.host, call_564119.base,
                         call_564119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564119, url, valid)

proc call*(call_564120: Call_SmartGroupsGetAll_564089; subscriptionId: string;
          monitorCondition: string = "Fired"; sortBy: string = "alertsCount";
          apiVersion: string = "2018-05-05"; pageCount: int = 0;
          monitorService: string = "Application Insights";
          smartGroupState: string = "New"; targetResource: string = "";
          targetResourceType: string = ""; sortOrder: string = "asc";
          timeRange: string = "1h"; severity: string = "Sev0";
          targetResourceGroup: string = ""): Recallable =
  ## smartGroupsGetAll
  ## List all the Smart Groups within a specified subscription. 
  ##   monitorCondition: string
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   sortBy: string
  ##         : Sort the query results by input field. Default value is sort by 'lastModifiedDateTime'.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   pageCount: int
  ##            : Determines number of alerts returned per page in response. Permissible value is between 1 to 250. When the "includeContent"  filter is selected, maximum value allowed is 25. Default value is 25.
  ##   monitorService: string
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   smartGroupState: string
  ##                  : Filter by state of the smart group. Default value is to select all.
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   targetResourceType: string
  ##                     : Filter by target resource type. Default value is select all.
  ##   sortOrder: string
  ##            : Sort the query results order in either ascending or descending.  Default value is 'desc' for time fields and 'asc' for others.
  ##   timeRange: string
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   severity: string
  ##           : Filter by severity.  Default value is select all.
  ##   targetResourceGroup: string
  ##                      : Filter by target resource group name. Default value is select all.
  var path_564121 = newJObject()
  var query_564122 = newJObject()
  add(query_564122, "monitorCondition", newJString(monitorCondition))
  add(query_564122, "sortBy", newJString(sortBy))
  add(query_564122, "api-version", newJString(apiVersion))
  add(query_564122, "pageCount", newJInt(pageCount))
  add(query_564122, "monitorService", newJString(monitorService))
  add(query_564122, "smartGroupState", newJString(smartGroupState))
  add(query_564122, "targetResource", newJString(targetResource))
  add(path_564121, "subscriptionId", newJString(subscriptionId))
  add(query_564122, "targetResourceType", newJString(targetResourceType))
  add(query_564122, "sortOrder", newJString(sortOrder))
  add(query_564122, "timeRange", newJString(timeRange))
  add(query_564122, "severity", newJString(severity))
  add(query_564122, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564120.call(path_564121, query_564122, nil, nil, nil)

var smartGroupsGetAll* = Call_SmartGroupsGetAll_564089(name: "smartGroupsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups",
    validator: validate_SmartGroupsGetAll_564090, base: "",
    url: url_SmartGroupsGetAll_564091, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetById_564123 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetById_564125(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetById_564124(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get information related to a specific Smart Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: JString (required)
  ##               : Smart group unique id. 
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564126 = path.getOrDefault("subscriptionId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "subscriptionId", valid_564126
  var valid_564127 = path.getOrDefault("smartGroupId")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "smartGroupId", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564129: Call_SmartGroupsGetById_564123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific Smart Group.
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_SmartGroupsGetById_564123; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2018-05-05"): Recallable =
  ## smartGroupsGetById
  ## Get information related to a specific Smart Group.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart group unique id. 
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  add(query_564132, "api-version", newJString(apiVersion))
  add(path_564131, "subscriptionId", newJString(subscriptionId))
  add(path_564131, "smartGroupId", newJString(smartGroupId))
  result = call_564130.call(path_564131, query_564132, nil, nil, nil)

var smartGroupsGetById* = Call_SmartGroupsGetById_564123(
    name: "smartGroupsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}",
    validator: validate_SmartGroupsGetById_564124, base: "",
    url: url_SmartGroupsGetById_564125, schemes: {Scheme.Https})
type
  Call_SmartGroupsChangeState_564133 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsChangeState_564135(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsChangeState_564134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Change the state of a Smart Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: JString (required)
  ##               : Smart group unique id. 
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564136 = path.getOrDefault("subscriptionId")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "subscriptionId", valid_564136
  var valid_564137 = path.getOrDefault("smartGroupId")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "smartGroupId", valid_564137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   newState: JString (required)
  ##           : New state of the alert.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564138 = query.getOrDefault("api-version")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564138 != nil:
    section.add "api-version", valid_564138
  var valid_564139 = query.getOrDefault("newState")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = newJString("New"))
  if valid_564139 != nil:
    section.add "newState", valid_564139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_SmartGroupsChangeState_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of a Smart Group.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_SmartGroupsChangeState_564133; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2018-05-05";
          newState: string = "New"): Recallable =
  ## smartGroupsChangeState
  ## Change the state of a Smart Group.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart group unique id. 
  ##   newState: string (required)
  ##           : New state of the alert.
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  add(query_564143, "api-version", newJString(apiVersion))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "smartGroupId", newJString(smartGroupId))
  add(query_564143, "newState", newJString(newState))
  result = call_564141.call(path_564142, query_564143, nil, nil, nil)

var smartGroupsChangeState* = Call_SmartGroupsChangeState_564133(
    name: "smartGroupsChangeState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/changeState",
    validator: validate_SmartGroupsChangeState_564134, base: "",
    url: url_SmartGroupsChangeState_564135, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetHistory_564144 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetHistory_564146(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetHistory_564145(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the history a smart group, which captures any Smart Group state changes (New/Acknowledged/Closed) .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: JString (required)
  ##               : Smart group unique id. 
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564147 = path.getOrDefault("subscriptionId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "subscriptionId", valid_564147
  var valid_564148 = path.getOrDefault("smartGroupId")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "smartGroupId", valid_564148
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564149 = query.getOrDefault("api-version")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564149 != nil:
    section.add "api-version", valid_564149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564150: Call_SmartGroupsGetHistory_564144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history a smart group, which captures any Smart Group state changes (New/Acknowledged/Closed) .
  ## 
  let valid = call_564150.validator(path, query, header, formData, body)
  let scheme = call_564150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564150.url(scheme.get, call_564150.host, call_564150.base,
                         call_564150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564150, url, valid)

proc call*(call_564151: Call_SmartGroupsGetHistory_564144; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2018-05-05"): Recallable =
  ## smartGroupsGetHistory
  ## Get the history a smart group, which captures any Smart Group state changes (New/Acknowledged/Closed) .
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart group unique id. 
  var path_564152 = newJObject()
  var query_564153 = newJObject()
  add(query_564153, "api-version", newJString(apiVersion))
  add(path_564152, "subscriptionId", newJString(subscriptionId))
  add(path_564152, "smartGroupId", newJString(smartGroupId))
  result = call_564151.call(path_564152, query_564153, nil, nil, nil)

var smartGroupsGetHistory* = Call_SmartGroupsGetHistory_564144(
    name: "smartGroupsGetHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/history",
    validator: validate_SmartGroupsGetHistory_564145, base: "",
    url: url_SmartGroupsGetHistory_564146, schemes: {Scheme.Https})
type
  Call_AlertsGetAll_564154 = ref object of OpenApiRestCall_563556
proc url_AlertsGetAll_564156(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetAll_564155(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List all existing alerts, where the results can be filtered on the basis of multiple parameters (e.g. time range). The results can then be sorted on the basis specific fields, with the default being lastModifiedDateTime. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : scope here is resourceId for which alert is created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_564157 = path.getOrDefault("scope")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "scope", valid_564157
  result.add "path", section
  ## parameters in `query` object:
  ##   monitorCondition: JString
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   includeEgressConfig: JBool
  ##                      : Include egress config which would be used for displaying the content in portal.  Default value is 'false'.
  ##   sortBy: JString
  ##         : Sort the query results by input field,  Default value is 'lastModifiedDateTime'.
  ##   api-version: JString (required)
  ##              : API version.
  ##   pageCount: JInt
  ##            : Determines number of alerts returned per page in response. Permissible value is between 1 to 250. When the "includeContent"  filter is selected, maximum value allowed is 25. Default value is 25.
  ##   monitorService: JString
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   select: JString
  ##         : This filter allows to selection of the fields(comma separated) which would  be part of the essential section. This would allow to project only the  required fields rather than getting entire content.  Default is to fetch all the fields in the essentials section.
  ##   alertRule: JString
  ##            : Filter by specific alert rule.  Default value is to select all.
  ##   alertState: JString
  ##             : Filter by state of the alert instance. Default value is to select all.
  ##   targetResource: JString
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   customTimeRange: JString
  ##                  : Filter by custom time range in the format <start-time>/<end-time>  where time is in (ISO-8601 format)'. Permissible values is within 30 days from  query time. Either timeRange or customTimeRange could be used but not both. Default is none.
  ##   includeContext: JBool
  ##                 : Include context which has contextual data specific to the monitor service. Default value is false'
  ##   targetResourceType: JString
  ##                     : Filter by target resource type. Default value is select all.
  ##   sortOrder: JString
  ##            : Sort the query results order in either ascending or descending.  Default value is 'desc' for time fields and 'asc' for others.
  ##   timeRange: JString
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   severity: JString
  ##           : Filter by severity.  Default value is select all.
  ##   smartGroupId: JString
  ##               : Filter the alerts list by the Smart Group Id. Default value is none.
  ##   targetResourceGroup: JString
  ##                      : Filter by target resource group name. Default value is select all.
  section = newJObject()
  var valid_564158 = query.getOrDefault("monitorCondition")
  valid_564158 = validateParameter(valid_564158, JString, required = false,
                                 default = newJString("Fired"))
  if valid_564158 != nil:
    section.add "monitorCondition", valid_564158
  var valid_564159 = query.getOrDefault("includeEgressConfig")
  valid_564159 = validateParameter(valid_564159, JBool, required = false, default = nil)
  if valid_564159 != nil:
    section.add "includeEgressConfig", valid_564159
  var valid_564160 = query.getOrDefault("sortBy")
  valid_564160 = validateParameter(valid_564160, JString, required = false,
                                 default = newJString("name"))
  if valid_564160 != nil:
    section.add "sortBy", valid_564160
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564161 = query.getOrDefault("api-version")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564161 != nil:
    section.add "api-version", valid_564161
  var valid_564162 = query.getOrDefault("pageCount")
  valid_564162 = validateParameter(valid_564162, JInt, required = false, default = nil)
  if valid_564162 != nil:
    section.add "pageCount", valid_564162
  var valid_564163 = query.getOrDefault("monitorService")
  valid_564163 = validateParameter(valid_564163, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_564163 != nil:
    section.add "monitorService", valid_564163
  var valid_564164 = query.getOrDefault("select")
  valid_564164 = validateParameter(valid_564164, JString, required = false,
                                 default = nil)
  if valid_564164 != nil:
    section.add "select", valid_564164
  var valid_564165 = query.getOrDefault("alertRule")
  valid_564165 = validateParameter(valid_564165, JString, required = false,
                                 default = nil)
  if valid_564165 != nil:
    section.add "alertRule", valid_564165
  var valid_564166 = query.getOrDefault("alertState")
  valid_564166 = validateParameter(valid_564166, JString, required = false,
                                 default = newJString("New"))
  if valid_564166 != nil:
    section.add "alertState", valid_564166
  var valid_564167 = query.getOrDefault("targetResource")
  valid_564167 = validateParameter(valid_564167, JString, required = false,
                                 default = nil)
  if valid_564167 != nil:
    section.add "targetResource", valid_564167
  var valid_564168 = query.getOrDefault("customTimeRange")
  valid_564168 = validateParameter(valid_564168, JString, required = false,
                                 default = nil)
  if valid_564168 != nil:
    section.add "customTimeRange", valid_564168
  var valid_564169 = query.getOrDefault("includeContext")
  valid_564169 = validateParameter(valid_564169, JBool, required = false, default = nil)
  if valid_564169 != nil:
    section.add "includeContext", valid_564169
  var valid_564170 = query.getOrDefault("targetResourceType")
  valid_564170 = validateParameter(valid_564170, JString, required = false,
                                 default = nil)
  if valid_564170 != nil:
    section.add "targetResourceType", valid_564170
  var valid_564171 = query.getOrDefault("sortOrder")
  valid_564171 = validateParameter(valid_564171, JString, required = false,
                                 default = newJString("asc"))
  if valid_564171 != nil:
    section.add "sortOrder", valid_564171
  var valid_564172 = query.getOrDefault("timeRange")
  valid_564172 = validateParameter(valid_564172, JString, required = false,
                                 default = newJString("1h"))
  if valid_564172 != nil:
    section.add "timeRange", valid_564172
  var valid_564173 = query.getOrDefault("severity")
  valid_564173 = validateParameter(valid_564173, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564173 != nil:
    section.add "severity", valid_564173
  var valid_564174 = query.getOrDefault("smartGroupId")
  valid_564174 = validateParameter(valid_564174, JString, required = false,
                                 default = nil)
  if valid_564174 != nil:
    section.add "smartGroupId", valid_564174
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

proc call*(call_564176: Call_AlertsGetAll_564154; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all existing alerts, where the results can be filtered on the basis of multiple parameters (e.g. time range). The results can then be sorted on the basis specific fields, with the default being lastModifiedDateTime. 
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_AlertsGetAll_564154; scope: string;
          monitorCondition: string = "Fired"; includeEgressConfig: bool = false;
          sortBy: string = "name"; apiVersion: string = "2018-05-05";
          pageCount: int = 0; monitorService: string = "Application Insights";
          select: string = ""; alertRule: string = ""; alertState: string = "New";
          targetResource: string = ""; customTimeRange: string = "";
          includeContext: bool = false; targetResourceType: string = "";
          sortOrder: string = "asc"; timeRange: string = "1h";
          severity: string = "Sev0"; smartGroupId: string = "";
          targetResourceGroup: string = ""): Recallable =
  ## alertsGetAll
  ## List all existing alerts, where the results can be filtered on the basis of multiple parameters (e.g. time range). The results can then be sorted on the basis specific fields, with the default being lastModifiedDateTime. 
  ##   monitorCondition: string
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   includeEgressConfig: bool
  ##                      : Include egress config which would be used for displaying the content in portal.  Default value is 'false'.
  ##   sortBy: string
  ##         : Sort the query results by input field,  Default value is 'lastModifiedDateTime'.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   pageCount: int
  ##            : Determines number of alerts returned per page in response. Permissible value is between 1 to 250. When the "includeContent"  filter is selected, maximum value allowed is 25. Default value is 25.
  ##   monitorService: string
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   select: string
  ##         : This filter allows to selection of the fields(comma separated) which would  be part of the essential section. This would allow to project only the  required fields rather than getting entire content.  Default is to fetch all the fields in the essentials section.
  ##   alertRule: string
  ##            : Filter by specific alert rule.  Default value is to select all.
  ##   alertState: string
  ##             : Filter by state of the alert instance. Default value is to select all.
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   customTimeRange: string
  ##                  : Filter by custom time range in the format <start-time>/<end-time>  where time is in (ISO-8601 format)'. Permissible values is within 30 days from  query time. Either timeRange or customTimeRange could be used but not both. Default is none.
  ##   includeContext: bool
  ##                 : Include context which has contextual data specific to the monitor service. Default value is false'
  ##   targetResourceType: string
  ##                     : Filter by target resource type. Default value is select all.
  ##   sortOrder: string
  ##            : Sort the query results order in either ascending or descending.  Default value is 'desc' for time fields and 'asc' for others.
  ##   timeRange: string
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   severity: string
  ##           : Filter by severity.  Default value is select all.
  ##   smartGroupId: string
  ##               : Filter the alerts list by the Smart Group Id. Default value is none.
  ##   scope: string (required)
  ##        : scope here is resourceId for which alert is created.
  ##   targetResourceGroup: string
  ##                      : Filter by target resource group name. Default value is select all.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  add(query_564179, "monitorCondition", newJString(monitorCondition))
  add(query_564179, "includeEgressConfig", newJBool(includeEgressConfig))
  add(query_564179, "sortBy", newJString(sortBy))
  add(query_564179, "api-version", newJString(apiVersion))
  add(query_564179, "pageCount", newJInt(pageCount))
  add(query_564179, "monitorService", newJString(monitorService))
  add(query_564179, "select", newJString(select))
  add(query_564179, "alertRule", newJString(alertRule))
  add(query_564179, "alertState", newJString(alertState))
  add(query_564179, "targetResource", newJString(targetResource))
  add(query_564179, "customTimeRange", newJString(customTimeRange))
  add(query_564179, "includeContext", newJBool(includeContext))
  add(query_564179, "targetResourceType", newJString(targetResourceType))
  add(query_564179, "sortOrder", newJString(sortOrder))
  add(query_564179, "timeRange", newJString(timeRange))
  add(query_564179, "severity", newJString(severity))
  add(query_564179, "smartGroupId", newJString(smartGroupId))
  add(path_564178, "scope", newJString(scope))
  add(query_564179, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564177.call(path_564178, query_564179, nil, nil, nil)

var alertsGetAll* = Call_AlertsGetAll_564154(name: "alertsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.AlertsManagement/alerts",
    validator: validate_AlertsGetAll_564155, base: "", url: url_AlertsGetAll_564156,
    schemes: {Scheme.Https})
type
  Call_AlertsGetById_564180 = ref object of OpenApiRestCall_563556
proc url_AlertsGetById_564182(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetById_564181(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information related to a specific alert. If scope is a deleted resource then please use scope as parent resource of the delete resource. For example if my alert id is '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/vm1/providers/Microsoft.AlertsManagement/alerts/{alertId}' and 'vm1' is deleted then if you want to get alert by id then use parent resource of scope. So in this example get alert by id call will look like this: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/alerts/{alertId}'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Unique ID of an alert instance.
  ##   scope: JString (required)
  ##        : scope here is resourceId for which alert is created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564183 = path.getOrDefault("alertId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "alertId", valid_564183
  var valid_564184 = path.getOrDefault("scope")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "scope", valid_564184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564185 = query.getOrDefault("api-version")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564185 != nil:
    section.add "api-version", valid_564185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564186: Call_AlertsGetById_564180; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific alert. If scope is a deleted resource then please use scope as parent resource of the delete resource. For example if my alert id is '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/vm1/providers/Microsoft.AlertsManagement/alerts/{alertId}' and 'vm1' is deleted then if you want to get alert by id then use parent resource of scope. So in this example get alert by id call will look like this: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/alerts/{alertId}'.
  ## 
  let valid = call_564186.validator(path, query, header, formData, body)
  let scheme = call_564186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564186.url(scheme.get, call_564186.host, call_564186.base,
                         call_564186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564186, url, valid)

proc call*(call_564187: Call_AlertsGetById_564180; alertId: string; scope: string;
          apiVersion: string = "2018-05-05"): Recallable =
  ## alertsGetById
  ## Get information related to a specific alert. If scope is a deleted resource then please use scope as parent resource of the delete resource. For example if my alert id is '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/vm1/providers/Microsoft.AlertsManagement/alerts/{alertId}' and 'vm1' is deleted then if you want to get alert by id then use parent resource of scope. So in this example get alert by id call will look like this: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/alerts/{alertId}'.
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   scope: string (required)
  ##        : scope here is resourceId for which alert is created.
  var path_564188 = newJObject()
  var query_564189 = newJObject()
  add(path_564188, "alertId", newJString(alertId))
  add(query_564189, "api-version", newJString(apiVersion))
  add(path_564188, "scope", newJString(scope))
  result = call_564187.call(path_564188, query_564189, nil, nil, nil)

var alertsGetById* = Call_AlertsGetById_564180(name: "alertsGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.AlertsManagement/alerts/{alertId}",
    validator: validate_AlertsGetById_564181, base: "", url: url_AlertsGetById_564182,
    schemes: {Scheme.Https})
type
  Call_AlertsChangeState_564190 = ref object of OpenApiRestCall_563556
proc url_AlertsChangeState_564192(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/changestate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsChangeState_564191(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Change the state of an alert. If scope is a deleted resource then please use scope as parent resource of the delete resource. For example if my alert id is '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/vm1/providers/Microsoft.AlertsManagement/alerts/{alertId}' and 'vm1' is deleted then if you want to change state of this particular alert then use parent resource of scope. So in this example change state call will look like this: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/alerts/{alertId}'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Unique ID of an alert instance.
  ##   scope: JString (required)
  ##        : scope here is resourceId for which alert is created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564193 = path.getOrDefault("alertId")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "alertId", valid_564193
  var valid_564194 = path.getOrDefault("scope")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "scope", valid_564194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   newState: JString (required)
  ##           : New state of the alert.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564195 = query.getOrDefault("api-version")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564195 != nil:
    section.add "api-version", valid_564195
  var valid_564196 = query.getOrDefault("newState")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = newJString("New"))
  if valid_564196 != nil:
    section.add "newState", valid_564196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564197: Call_AlertsChangeState_564190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of an alert. If scope is a deleted resource then please use scope as parent resource of the delete resource. For example if my alert id is '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/vm1/providers/Microsoft.AlertsManagement/alerts/{alertId}' and 'vm1' is deleted then if you want to change state of this particular alert then use parent resource of scope. So in this example change state call will look like this: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/alerts/{alertId}'.
  ## 
  let valid = call_564197.validator(path, query, header, formData, body)
  let scheme = call_564197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564197.url(scheme.get, call_564197.host, call_564197.base,
                         call_564197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564197, url, valid)

proc call*(call_564198: Call_AlertsChangeState_564190; alertId: string;
          scope: string; apiVersion: string = "2018-05-05"; newState: string = "New"): Recallable =
  ## alertsChangeState
  ## Change the state of an alert. If scope is a deleted resource then please use scope as parent resource of the delete resource. For example if my alert id is '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/vm1/providers/Microsoft.AlertsManagement/alerts/{alertId}' and 'vm1' is deleted then if you want to change state of this particular alert then use parent resource of scope. So in this example change state call will look like this: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/alerts/{alertId}'.
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   newState: string (required)
  ##           : New state of the alert.
  ##   scope: string (required)
  ##        : scope here is resourceId for which alert is created.
  var path_564199 = newJObject()
  var query_564200 = newJObject()
  add(path_564199, "alertId", newJString(alertId))
  add(query_564200, "api-version", newJString(apiVersion))
  add(query_564200, "newState", newJString(newState))
  add(path_564199, "scope", newJString(scope))
  result = call_564198.call(path_564199, query_564200, nil, nil, nil)

var alertsChangeState* = Call_AlertsChangeState_564190(name: "alertsChangeState",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/{scope}/providers/Microsoft.AlertsManagement/alerts/{alertId}/changestate",
    validator: validate_AlertsChangeState_564191, base: "",
    url: url_AlertsChangeState_564192, schemes: {Scheme.Https})
type
  Call_AlertsGetHistory_564201 = ref object of OpenApiRestCall_563556
proc url_AlertsGetHistory_564203(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/alerts/"),
               (kind: VariableSegment, value: "alertId"),
               (kind: ConstantSegment, value: "/history")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetHistory_564202(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved), alert state changes (New/Acknowledged/Closed) and applied action rules for that particular alert. If scope is a deleted resource then please use scope as parent resource of the delete resource. For example if my alert id is '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/vm1/providers/Microsoft.AlertsManagement/alerts/{alertId}' and 'vm1' is deleted then if you want to get history of this particular alert then use parent resource of scope. So in this example get history call will look like this: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/alerts/{alertId}/history'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Unique ID of an alert instance.
  ##   scope: JString (required)
  ##        : scope here is resourceId for which alert is created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564204 = path.getOrDefault("alertId")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "alertId", valid_564204
  var valid_564205 = path.getOrDefault("scope")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "scope", valid_564205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564206 = query.getOrDefault("api-version")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564206 != nil:
    section.add "api-version", valid_564206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564207: Call_AlertsGetHistory_564201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved), alert state changes (New/Acknowledged/Closed) and applied action rules for that particular alert. If scope is a deleted resource then please use scope as parent resource of the delete resource. For example if my alert id is '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/vm1/providers/Microsoft.AlertsManagement/alerts/{alertId}' and 'vm1' is deleted then if you want to get history of this particular alert then use parent resource of scope. So in this example get history call will look like this: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/alerts/{alertId}/history'.
  ## 
  let valid = call_564207.validator(path, query, header, formData, body)
  let scheme = call_564207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564207.url(scheme.get, call_564207.host, call_564207.base,
                         call_564207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564207, url, valid)

proc call*(call_564208: Call_AlertsGetHistory_564201; alertId: string; scope: string;
          apiVersion: string = "2018-05-05"): Recallable =
  ## alertsGetHistory
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved), alert state changes (New/Acknowledged/Closed) and applied action rules for that particular alert. If scope is a deleted resource then please use scope as parent resource of the delete resource. For example if my alert id is '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/virtualMachines/vm1/providers/Microsoft.AlertsManagement/alerts/{alertId}' and 'vm1' is deleted then if you want to get history of this particular alert then use parent resource of scope. So in this example get history call will look like this: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/alerts/{alertId}/history'.
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   scope: string (required)
  ##        : scope here is resourceId for which alert is created.
  var path_564209 = newJObject()
  var query_564210 = newJObject()
  add(path_564209, "alertId", newJString(alertId))
  add(query_564210, "api-version", newJString(apiVersion))
  add(path_564209, "scope", newJString(scope))
  result = call_564208.call(path_564209, query_564210, nil, nil, nil)

var alertsGetHistory* = Call_AlertsGetHistory_564201(name: "alertsGetHistory",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.AlertsManagement/alerts/{alertId}/history",
    validator: validate_AlertsGetHistory_564202, base: "",
    url: url_AlertsGetHistory_564203, schemes: {Scheme.Https})
type
  Call_AlertsGetSummary_564211 = ref object of OpenApiRestCall_563556
proc url_AlertsGetSummary_564213(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/alertsSummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertsGetSummary_564212(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get a summarized count of your alerts grouped by various parameters (e.g. grouping by 'Severity' returns the count of alerts for each severity).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : scope here is resourceId for which alert is created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_564214 = path.getOrDefault("scope")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "scope", valid_564214
  result.add "path", section
  ## parameters in `query` object:
  ##   monitorCondition: JString
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   includeSmartGroupsCount: JBool
  ##                          : Include count of the SmartGroups as part of the summary. Default value is 'false'.
  ##   api-version: JString (required)
  ##              : API version.
  ##   monitorService: JString
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   alertRule: JString
  ##            : Filter by specific alert rule.  Default value is to select all.
  ##   alertState: JString
  ##             : Filter by state of the alert instance. Default value is to select all.
  ##   targetResource: JString
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   customTimeRange: JString
  ##                  : Filter by custom time range in the format <start-time>/<end-time>  where time is in (ISO-8601 format)'. Permissible values is within 30 days from  query time. Either timeRange or customTimeRange could be used but not both. Default is none.
  ##   targetResourceType: JString
  ##                     : Filter by target resource type. Default value is select all.
  ##   timeRange: JString
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   severity: JString
  ##           : Filter by severity.  Default value is select all.
  ##   groupby: JString (required)
  ##          : This parameter allows the result set to be grouped by input fields. For example, groupby=severity,alertstate.
  ##   targetResourceGroup: JString
  ##                      : Filter by target resource group name. Default value is select all.
  section = newJObject()
  var valid_564215 = query.getOrDefault("monitorCondition")
  valid_564215 = validateParameter(valid_564215, JString, required = false,
                                 default = newJString("Fired"))
  if valid_564215 != nil:
    section.add "monitorCondition", valid_564215
  var valid_564216 = query.getOrDefault("includeSmartGroupsCount")
  valid_564216 = validateParameter(valid_564216, JBool, required = false, default = nil)
  if valid_564216 != nil:
    section.add "includeSmartGroupsCount", valid_564216
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564217 = query.getOrDefault("api-version")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564217 != nil:
    section.add "api-version", valid_564217
  var valid_564218 = query.getOrDefault("monitorService")
  valid_564218 = validateParameter(valid_564218, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_564218 != nil:
    section.add "monitorService", valid_564218
  var valid_564219 = query.getOrDefault("alertRule")
  valid_564219 = validateParameter(valid_564219, JString, required = false,
                                 default = nil)
  if valid_564219 != nil:
    section.add "alertRule", valid_564219
  var valid_564220 = query.getOrDefault("alertState")
  valid_564220 = validateParameter(valid_564220, JString, required = false,
                                 default = newJString("New"))
  if valid_564220 != nil:
    section.add "alertState", valid_564220
  var valid_564221 = query.getOrDefault("targetResource")
  valid_564221 = validateParameter(valid_564221, JString, required = false,
                                 default = nil)
  if valid_564221 != nil:
    section.add "targetResource", valid_564221
  var valid_564222 = query.getOrDefault("customTimeRange")
  valid_564222 = validateParameter(valid_564222, JString, required = false,
                                 default = nil)
  if valid_564222 != nil:
    section.add "customTimeRange", valid_564222
  var valid_564223 = query.getOrDefault("targetResourceType")
  valid_564223 = validateParameter(valid_564223, JString, required = false,
                                 default = nil)
  if valid_564223 != nil:
    section.add "targetResourceType", valid_564223
  var valid_564224 = query.getOrDefault("timeRange")
  valid_564224 = validateParameter(valid_564224, JString, required = false,
                                 default = newJString("1h"))
  if valid_564224 != nil:
    section.add "timeRange", valid_564224
  var valid_564225 = query.getOrDefault("severity")
  valid_564225 = validateParameter(valid_564225, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564225 != nil:
    section.add "severity", valid_564225
  var valid_564226 = query.getOrDefault("groupby")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = newJString("severity"))
  if valid_564226 != nil:
    section.add "groupby", valid_564226
  var valid_564227 = query.getOrDefault("targetResourceGroup")
  valid_564227 = validateParameter(valid_564227, JString, required = false,
                                 default = nil)
  if valid_564227 != nil:
    section.add "targetResourceGroup", valid_564227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564228: Call_AlertsGetSummary_564211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a summarized count of your alerts grouped by various parameters (e.g. grouping by 'Severity' returns the count of alerts for each severity).
  ## 
  let valid = call_564228.validator(path, query, header, formData, body)
  let scheme = call_564228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564228.url(scheme.get, call_564228.host, call_564228.base,
                         call_564228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564228, url, valid)

proc call*(call_564229: Call_AlertsGetSummary_564211; scope: string;
          monitorCondition: string = "Fired"; includeSmartGroupsCount: bool = false;
          apiVersion: string = "2018-05-05";
          monitorService: string = "Application Insights"; alertRule: string = "";
          alertState: string = "New"; targetResource: string = "";
          customTimeRange: string = ""; targetResourceType: string = "";
          timeRange: string = "1h"; severity: string = "Sev0";
          groupby: string = "severity"; targetResourceGroup: string = ""): Recallable =
  ## alertsGetSummary
  ## Get a summarized count of your alerts grouped by various parameters (e.g. grouping by 'Severity' returns the count of alerts for each severity).
  ##   monitorCondition: string
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   includeSmartGroupsCount: bool
  ##                          : Include count of the SmartGroups as part of the summary. Default value is 'false'.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   monitorService: string
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   alertRule: string
  ##            : Filter by specific alert rule.  Default value is to select all.
  ##   alertState: string
  ##             : Filter by state of the alert instance. Default value is to select all.
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   customTimeRange: string
  ##                  : Filter by custom time range in the format <start-time>/<end-time>  where time is in (ISO-8601 format)'. Permissible values is within 30 days from  query time. Either timeRange or customTimeRange could be used but not both. Default is none.
  ##   targetResourceType: string
  ##                     : Filter by target resource type. Default value is select all.
  ##   timeRange: string
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   severity: string
  ##           : Filter by severity.  Default value is select all.
  ##   groupby: string (required)
  ##          : This parameter allows the result set to be grouped by input fields. For example, groupby=severity,alertstate.
  ##   scope: string (required)
  ##        : scope here is resourceId for which alert is created.
  ##   targetResourceGroup: string
  ##                      : Filter by target resource group name. Default value is select all.
  var path_564230 = newJObject()
  var query_564231 = newJObject()
  add(query_564231, "monitorCondition", newJString(monitorCondition))
  add(query_564231, "includeSmartGroupsCount", newJBool(includeSmartGroupsCount))
  add(query_564231, "api-version", newJString(apiVersion))
  add(query_564231, "monitorService", newJString(monitorService))
  add(query_564231, "alertRule", newJString(alertRule))
  add(query_564231, "alertState", newJString(alertState))
  add(query_564231, "targetResource", newJString(targetResource))
  add(query_564231, "customTimeRange", newJString(customTimeRange))
  add(query_564231, "targetResourceType", newJString(targetResourceType))
  add(query_564231, "timeRange", newJString(timeRange))
  add(query_564231, "severity", newJString(severity))
  add(query_564231, "groupby", newJString(groupby))
  add(path_564230, "scope", newJString(scope))
  add(query_564231, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564229.call(path_564230, query_564231, nil, nil, nil)

var alertsGetSummary* = Call_AlertsGetSummary_564211(name: "alertsGetSummary",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.AlertsManagement/alertsSummary",
    validator: validate_AlertsGetSummary_564212, base: "",
    url: url_AlertsGetSummary_564213, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
