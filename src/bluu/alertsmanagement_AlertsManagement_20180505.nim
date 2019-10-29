
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Alerts Management Service Resource Provider
## version: 2018-05-05
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
  ## List all existing alerts, where the results can be filtered on the basis of multiple parameters (e.g. time range). The results can then be sorted on the basis specific fields, with the default being lastModifiedDateTime. 
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
  var valid_564107 = query.getOrDefault("monitorCondition")
  valid_564107 = validateParameter(valid_564107, JString, required = false,
                                 default = newJString("Fired"))
  if valid_564107 != nil:
    section.add "monitorCondition", valid_564107
  var valid_564108 = query.getOrDefault("includeEgressConfig")
  valid_564108 = validateParameter(valid_564108, JBool, required = false, default = nil)
  if valid_564108 != nil:
    section.add "includeEgressConfig", valid_564108
  var valid_564109 = query.getOrDefault("sortBy")
  valid_564109 = validateParameter(valid_564109, JString, required = false,
                                 default = newJString("name"))
  if valid_564109 != nil:
    section.add "sortBy", valid_564109
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564110 = query.getOrDefault("api-version")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564110 != nil:
    section.add "api-version", valid_564110
  var valid_564111 = query.getOrDefault("pageCount")
  valid_564111 = validateParameter(valid_564111, JInt, required = false, default = nil)
  if valid_564111 != nil:
    section.add "pageCount", valid_564111
  var valid_564112 = query.getOrDefault("monitorService")
  valid_564112 = validateParameter(valid_564112, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_564112 != nil:
    section.add "monitorService", valid_564112
  var valid_564113 = query.getOrDefault("select")
  valid_564113 = validateParameter(valid_564113, JString, required = false,
                                 default = nil)
  if valid_564113 != nil:
    section.add "select", valid_564113
  var valid_564114 = query.getOrDefault("alertRule")
  valid_564114 = validateParameter(valid_564114, JString, required = false,
                                 default = nil)
  if valid_564114 != nil:
    section.add "alertRule", valid_564114
  var valid_564115 = query.getOrDefault("alertState")
  valid_564115 = validateParameter(valid_564115, JString, required = false,
                                 default = newJString("New"))
  if valid_564115 != nil:
    section.add "alertState", valid_564115
  var valid_564116 = query.getOrDefault("targetResource")
  valid_564116 = validateParameter(valid_564116, JString, required = false,
                                 default = nil)
  if valid_564116 != nil:
    section.add "targetResource", valid_564116
  var valid_564117 = query.getOrDefault("customTimeRange")
  valid_564117 = validateParameter(valid_564117, JString, required = false,
                                 default = nil)
  if valid_564117 != nil:
    section.add "customTimeRange", valid_564117
  var valid_564118 = query.getOrDefault("includeContext")
  valid_564118 = validateParameter(valid_564118, JBool, required = false, default = nil)
  if valid_564118 != nil:
    section.add "includeContext", valid_564118
  var valid_564119 = query.getOrDefault("targetResourceType")
  valid_564119 = validateParameter(valid_564119, JString, required = false,
                                 default = nil)
  if valid_564119 != nil:
    section.add "targetResourceType", valid_564119
  var valid_564120 = query.getOrDefault("sortOrder")
  valid_564120 = validateParameter(valid_564120, JString, required = false,
                                 default = newJString("asc"))
  if valid_564120 != nil:
    section.add "sortOrder", valid_564120
  var valid_564121 = query.getOrDefault("timeRange")
  valid_564121 = validateParameter(valid_564121, JString, required = false,
                                 default = newJString("1h"))
  if valid_564121 != nil:
    section.add "timeRange", valid_564121
  var valid_564122 = query.getOrDefault("severity")
  valid_564122 = validateParameter(valid_564122, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564122 != nil:
    section.add "severity", valid_564122
  var valid_564123 = query.getOrDefault("smartGroupId")
  valid_564123 = validateParameter(valid_564123, JString, required = false,
                                 default = nil)
  if valid_564123 != nil:
    section.add "smartGroupId", valid_564123
  var valid_564124 = query.getOrDefault("targetResourceGroup")
  valid_564124 = validateParameter(valid_564124, JString, required = false,
                                 default = nil)
  if valid_564124 != nil:
    section.add "targetResourceGroup", valid_564124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564125: Call_AlertsGetAll_564089; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all existing alerts, where the results can be filtered on the basis of multiple parameters (e.g. time range). The results can then be sorted on the basis specific fields, with the default being lastModifiedDateTime. 
  ## 
  let valid = call_564125.validator(path, query, header, formData, body)
  let scheme = call_564125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564125.url(scheme.get, call_564125.host, call_564125.base,
                         call_564125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564125, url, valid)

proc call*(call_564126: Call_AlertsGetAll_564089; subscriptionId: string;
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
  ##   smartGroupId: string
  ##               : Filter the alerts list by the Smart Group Id. Default value is none.
  ##   targetResourceGroup: string
  ##                      : Filter by target resource group name. Default value is select all.
  var path_564127 = newJObject()
  var query_564128 = newJObject()
  add(query_564128, "monitorCondition", newJString(monitorCondition))
  add(query_564128, "includeEgressConfig", newJBool(includeEgressConfig))
  add(query_564128, "sortBy", newJString(sortBy))
  add(query_564128, "api-version", newJString(apiVersion))
  add(query_564128, "pageCount", newJInt(pageCount))
  add(query_564128, "monitorService", newJString(monitorService))
  add(query_564128, "select", newJString(select))
  add(query_564128, "alertRule", newJString(alertRule))
  add(query_564128, "alertState", newJString(alertState))
  add(query_564128, "targetResource", newJString(targetResource))
  add(query_564128, "customTimeRange", newJString(customTimeRange))
  add(query_564128, "includeContext", newJBool(includeContext))
  add(path_564127, "subscriptionId", newJString(subscriptionId))
  add(query_564128, "targetResourceType", newJString(targetResourceType))
  add(query_564128, "sortOrder", newJString(sortOrder))
  add(query_564128, "timeRange", newJString(timeRange))
  add(query_564128, "severity", newJString(severity))
  add(query_564128, "smartGroupId", newJString(smartGroupId))
  add(query_564128, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564126.call(path_564127, query_564128, nil, nil, nil)

var alertsGetAll* = Call_AlertsGetAll_564089(name: "alertsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts",
    validator: validate_AlertsGetAll_564090, base: "", url: url_AlertsGetAll_564091,
    schemes: {Scheme.Https})
type
  Call_AlertsGetById_564129 = ref object of OpenApiRestCall_563556
proc url_AlertsGetById_564131(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetById_564130(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information related to a specific alert
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Unique ID of an alert instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564132 = path.getOrDefault("alertId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "alertId", valid_564132
  var valid_564133 = path.getOrDefault("subscriptionId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "subscriptionId", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564134 != nil:
    section.add "api-version", valid_564134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_AlertsGetById_564129; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific alert
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_AlertsGetById_564129; alertId: string;
          subscriptionId: string; apiVersion: string = "2018-05-05"): Recallable =
  ## alertsGetById
  ## Get information related to a specific alert
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  add(path_564137, "alertId", newJString(alertId))
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  result = call_564136.call(path_564137, query_564138, nil, nil, nil)

var alertsGetById* = Call_AlertsGetById_564129(name: "alertsGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}",
    validator: validate_AlertsGetById_564130, base: "", url: url_AlertsGetById_564131,
    schemes: {Scheme.Https})
type
  Call_AlertsChangeState_564139 = ref object of OpenApiRestCall_563556
proc url_AlertsChangeState_564141(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsChangeState_564140(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Change the state of an alert.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Unique ID of an alert instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564142 = path.getOrDefault("alertId")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "alertId", valid_564142
  var valid_564143 = path.getOrDefault("subscriptionId")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "subscriptionId", valid_564143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   newState: JString (required)
  ##           : New state of the alert.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564144 = query.getOrDefault("api-version")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564144 != nil:
    section.add "api-version", valid_564144
  var valid_564145 = query.getOrDefault("newState")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = newJString("New"))
  if valid_564145 != nil:
    section.add "newState", valid_564145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564146: Call_AlertsChangeState_564139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of an alert.
  ## 
  let valid = call_564146.validator(path, query, header, formData, body)
  let scheme = call_564146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564146.url(scheme.get, call_564146.host, call_564146.base,
                         call_564146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564146, url, valid)

proc call*(call_564147: Call_AlertsChangeState_564139; alertId: string;
          subscriptionId: string; apiVersion: string = "2018-05-05";
          newState: string = "New"): Recallable =
  ## alertsChangeState
  ## Change the state of an alert.
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   newState: string (required)
  ##           : New state of the alert.
  var path_564148 = newJObject()
  var query_564149 = newJObject()
  add(path_564148, "alertId", newJString(alertId))
  add(query_564149, "api-version", newJString(apiVersion))
  add(path_564148, "subscriptionId", newJString(subscriptionId))
  add(query_564149, "newState", newJString(newState))
  result = call_564147.call(path_564148, query_564149, nil, nil, nil)

var alertsChangeState* = Call_AlertsChangeState_564139(name: "alertsChangeState",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/changestate",
    validator: validate_AlertsChangeState_564140, base: "",
    url: url_AlertsChangeState_564141, schemes: {Scheme.Https})
type
  Call_AlertsGetHistory_564150 = ref object of OpenApiRestCall_563556
proc url_AlertsGetHistory_564152(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetHistory_564151(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved) and alert state changes (New/Acknowledged/Closed).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Unique ID of an alert instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564153 = path.getOrDefault("alertId")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "alertId", valid_564153
  var valid_564154 = path.getOrDefault("subscriptionId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "subscriptionId", valid_564154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564155 = query.getOrDefault("api-version")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564155 != nil:
    section.add "api-version", valid_564155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_AlertsGetHistory_564150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved) and alert state changes (New/Acknowledged/Closed).
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_AlertsGetHistory_564150; alertId: string;
          subscriptionId: string; apiVersion: string = "2018-05-05"): Recallable =
  ## alertsGetHistory
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved) and alert state changes (New/Acknowledged/Closed).
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  add(path_564158, "alertId", newJString(alertId))
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "subscriptionId", newJString(subscriptionId))
  result = call_564157.call(path_564158, query_564159, nil, nil, nil)

var alertsGetHistory* = Call_AlertsGetHistory_564150(name: "alertsGetHistory",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/history",
    validator: validate_AlertsGetHistory_564151, base: "",
    url: url_AlertsGetHistory_564152, schemes: {Scheme.Https})
type
  Call_AlertsGetSummary_564160 = ref object of OpenApiRestCall_563556
proc url_AlertsGetSummary_564162(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetSummary_564161(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get a summarized count of your alerts grouped by various parameters (e.g. grouping by 'Severity' returns the count of alerts for each severity).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564163 = path.getOrDefault("subscriptionId")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "subscriptionId", valid_564163
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
  var valid_564164 = query.getOrDefault("monitorCondition")
  valid_564164 = validateParameter(valid_564164, JString, required = false,
                                 default = newJString("Fired"))
  if valid_564164 != nil:
    section.add "monitorCondition", valid_564164
  var valid_564165 = query.getOrDefault("includeSmartGroupsCount")
  valid_564165 = validateParameter(valid_564165, JBool, required = false, default = nil)
  if valid_564165 != nil:
    section.add "includeSmartGroupsCount", valid_564165
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564166 != nil:
    section.add "api-version", valid_564166
  var valid_564167 = query.getOrDefault("monitorService")
  valid_564167 = validateParameter(valid_564167, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_564167 != nil:
    section.add "monitorService", valid_564167
  var valid_564168 = query.getOrDefault("alertRule")
  valid_564168 = validateParameter(valid_564168, JString, required = false,
                                 default = nil)
  if valid_564168 != nil:
    section.add "alertRule", valid_564168
  var valid_564169 = query.getOrDefault("alertState")
  valid_564169 = validateParameter(valid_564169, JString, required = false,
                                 default = newJString("New"))
  if valid_564169 != nil:
    section.add "alertState", valid_564169
  var valid_564170 = query.getOrDefault("targetResource")
  valid_564170 = validateParameter(valid_564170, JString, required = false,
                                 default = nil)
  if valid_564170 != nil:
    section.add "targetResource", valid_564170
  var valid_564171 = query.getOrDefault("customTimeRange")
  valid_564171 = validateParameter(valid_564171, JString, required = false,
                                 default = nil)
  if valid_564171 != nil:
    section.add "customTimeRange", valid_564171
  var valid_564172 = query.getOrDefault("targetResourceType")
  valid_564172 = validateParameter(valid_564172, JString, required = false,
                                 default = nil)
  if valid_564172 != nil:
    section.add "targetResourceType", valid_564172
  var valid_564173 = query.getOrDefault("timeRange")
  valid_564173 = validateParameter(valid_564173, JString, required = false,
                                 default = newJString("1h"))
  if valid_564173 != nil:
    section.add "timeRange", valid_564173
  var valid_564174 = query.getOrDefault("severity")
  valid_564174 = validateParameter(valid_564174, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564174 != nil:
    section.add "severity", valid_564174
  var valid_564175 = query.getOrDefault("groupby")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = newJString("severity"))
  if valid_564175 != nil:
    section.add "groupby", valid_564175
  var valid_564176 = query.getOrDefault("targetResourceGroup")
  valid_564176 = validateParameter(valid_564176, JString, required = false,
                                 default = nil)
  if valid_564176 != nil:
    section.add "targetResourceGroup", valid_564176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564177: Call_AlertsGetSummary_564160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a summarized count of your alerts grouped by various parameters (e.g. grouping by 'Severity' returns the count of alerts for each severity).
  ## 
  let valid = call_564177.validator(path, query, header, formData, body)
  let scheme = call_564177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564177.url(scheme.get, call_564177.host, call_564177.base,
                         call_564177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564177, url, valid)

proc call*(call_564178: Call_AlertsGetSummary_564160; subscriptionId: string;
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
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   targetResourceType: string
  ##                     : Filter by target resource type. Default value is select all.
  ##   timeRange: string
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   severity: string
  ##           : Filter by severity.  Default value is select all.
  ##   groupby: string (required)
  ##          : This parameter allows the result set to be grouped by input fields. For example, groupby=severity,alertstate.
  ##   targetResourceGroup: string
  ##                      : Filter by target resource group name. Default value is select all.
  var path_564179 = newJObject()
  var query_564180 = newJObject()
  add(query_564180, "monitorCondition", newJString(monitorCondition))
  add(query_564180, "includeSmartGroupsCount", newJBool(includeSmartGroupsCount))
  add(query_564180, "api-version", newJString(apiVersion))
  add(query_564180, "monitorService", newJString(monitorService))
  add(query_564180, "alertRule", newJString(alertRule))
  add(query_564180, "alertState", newJString(alertState))
  add(query_564180, "targetResource", newJString(targetResource))
  add(query_564180, "customTimeRange", newJString(customTimeRange))
  add(path_564179, "subscriptionId", newJString(subscriptionId))
  add(query_564180, "targetResourceType", newJString(targetResourceType))
  add(query_564180, "timeRange", newJString(timeRange))
  add(query_564180, "severity", newJString(severity))
  add(query_564180, "groupby", newJString(groupby))
  add(query_564180, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564178.call(path_564179, query_564180, nil, nil, nil)

var alertsGetSummary* = Call_AlertsGetSummary_564160(name: "alertsGetSummary",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alertsSummary",
    validator: validate_AlertsGetSummary_564161, base: "",
    url: url_AlertsGetSummary_564162, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetAll_564181 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetAll_564183(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetAll_564182(path: JsonNode; query: JsonNode;
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
  var valid_564184 = path.getOrDefault("subscriptionId")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "subscriptionId", valid_564184
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
  var valid_564185 = query.getOrDefault("monitorCondition")
  valid_564185 = validateParameter(valid_564185, JString, required = false,
                                 default = newJString("Fired"))
  if valid_564185 != nil:
    section.add "monitorCondition", valid_564185
  var valid_564186 = query.getOrDefault("sortBy")
  valid_564186 = validateParameter(valid_564186, JString, required = false,
                                 default = newJString("alertsCount"))
  if valid_564186 != nil:
    section.add "sortBy", valid_564186
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564187 = query.getOrDefault("api-version")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564187 != nil:
    section.add "api-version", valid_564187
  var valid_564188 = query.getOrDefault("pageCount")
  valid_564188 = validateParameter(valid_564188, JInt, required = false, default = nil)
  if valid_564188 != nil:
    section.add "pageCount", valid_564188
  var valid_564189 = query.getOrDefault("monitorService")
  valid_564189 = validateParameter(valid_564189, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_564189 != nil:
    section.add "monitorService", valid_564189
  var valid_564190 = query.getOrDefault("smartGroupState")
  valid_564190 = validateParameter(valid_564190, JString, required = false,
                                 default = newJString("New"))
  if valid_564190 != nil:
    section.add "smartGroupState", valid_564190
  var valid_564191 = query.getOrDefault("targetResource")
  valid_564191 = validateParameter(valid_564191, JString, required = false,
                                 default = nil)
  if valid_564191 != nil:
    section.add "targetResource", valid_564191
  var valid_564192 = query.getOrDefault("targetResourceType")
  valid_564192 = validateParameter(valid_564192, JString, required = false,
                                 default = nil)
  if valid_564192 != nil:
    section.add "targetResourceType", valid_564192
  var valid_564193 = query.getOrDefault("sortOrder")
  valid_564193 = validateParameter(valid_564193, JString, required = false,
                                 default = newJString("asc"))
  if valid_564193 != nil:
    section.add "sortOrder", valid_564193
  var valid_564194 = query.getOrDefault("timeRange")
  valid_564194 = validateParameter(valid_564194, JString, required = false,
                                 default = newJString("1h"))
  if valid_564194 != nil:
    section.add "timeRange", valid_564194
  var valid_564195 = query.getOrDefault("severity")
  valid_564195 = validateParameter(valid_564195, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564195 != nil:
    section.add "severity", valid_564195
  var valid_564196 = query.getOrDefault("targetResourceGroup")
  valid_564196 = validateParameter(valid_564196, JString, required = false,
                                 default = nil)
  if valid_564196 != nil:
    section.add "targetResourceGroup", valid_564196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564197: Call_SmartGroupsGetAll_564181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the Smart Groups within a specified subscription. 
  ## 
  let valid = call_564197.validator(path, query, header, formData, body)
  let scheme = call_564197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564197.url(scheme.get, call_564197.host, call_564197.base,
                         call_564197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564197, url, valid)

proc call*(call_564198: Call_SmartGroupsGetAll_564181; subscriptionId: string;
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
  var path_564199 = newJObject()
  var query_564200 = newJObject()
  add(query_564200, "monitorCondition", newJString(monitorCondition))
  add(query_564200, "sortBy", newJString(sortBy))
  add(query_564200, "api-version", newJString(apiVersion))
  add(query_564200, "pageCount", newJInt(pageCount))
  add(query_564200, "monitorService", newJString(monitorService))
  add(query_564200, "smartGroupState", newJString(smartGroupState))
  add(query_564200, "targetResource", newJString(targetResource))
  add(path_564199, "subscriptionId", newJString(subscriptionId))
  add(query_564200, "targetResourceType", newJString(targetResourceType))
  add(query_564200, "sortOrder", newJString(sortOrder))
  add(query_564200, "timeRange", newJString(timeRange))
  add(query_564200, "severity", newJString(severity))
  add(query_564200, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564198.call(path_564199, query_564200, nil, nil, nil)

var smartGroupsGetAll* = Call_SmartGroupsGetAll_564181(name: "smartGroupsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups",
    validator: validate_SmartGroupsGetAll_564182, base: "",
    url: url_SmartGroupsGetAll_564183, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetById_564201 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetById_564203(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetById_564202(path: JsonNode; query: JsonNode;
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
  var valid_564204 = path.getOrDefault("subscriptionId")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "subscriptionId", valid_564204
  var valid_564205 = path.getOrDefault("smartGroupId")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "smartGroupId", valid_564205
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

proc call*(call_564207: Call_SmartGroupsGetById_564201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific Smart Group.
  ## 
  let valid = call_564207.validator(path, query, header, formData, body)
  let scheme = call_564207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564207.url(scheme.get, call_564207.host, call_564207.base,
                         call_564207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564207, url, valid)

proc call*(call_564208: Call_SmartGroupsGetById_564201; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2018-05-05"): Recallable =
  ## smartGroupsGetById
  ## Get information related to a specific Smart Group.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart group unique id. 
  var path_564209 = newJObject()
  var query_564210 = newJObject()
  add(query_564210, "api-version", newJString(apiVersion))
  add(path_564209, "subscriptionId", newJString(subscriptionId))
  add(path_564209, "smartGroupId", newJString(smartGroupId))
  result = call_564208.call(path_564209, query_564210, nil, nil, nil)

var smartGroupsGetById* = Call_SmartGroupsGetById_564201(
    name: "smartGroupsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}",
    validator: validate_SmartGroupsGetById_564202, base: "",
    url: url_SmartGroupsGetById_564203, schemes: {Scheme.Https})
type
  Call_SmartGroupsChangeState_564211 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsChangeState_564213(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsChangeState_564212(path: JsonNode; query: JsonNode;
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
  var valid_564214 = path.getOrDefault("subscriptionId")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "subscriptionId", valid_564214
  var valid_564215 = path.getOrDefault("smartGroupId")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "smartGroupId", valid_564215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   newState: JString (required)
  ##           : New state of the alert.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564216 = query.getOrDefault("api-version")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564216 != nil:
    section.add "api-version", valid_564216
  var valid_564217 = query.getOrDefault("newState")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = newJString("New"))
  if valid_564217 != nil:
    section.add "newState", valid_564217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564218: Call_SmartGroupsChangeState_564211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of a Smart Group.
  ## 
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_SmartGroupsChangeState_564211; subscriptionId: string;
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
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  add(query_564221, "api-version", newJString(apiVersion))
  add(path_564220, "subscriptionId", newJString(subscriptionId))
  add(path_564220, "smartGroupId", newJString(smartGroupId))
  add(query_564221, "newState", newJString(newState))
  result = call_564219.call(path_564220, query_564221, nil, nil, nil)

var smartGroupsChangeState* = Call_SmartGroupsChangeState_564211(
    name: "smartGroupsChangeState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/changeState",
    validator: validate_SmartGroupsChangeState_564212, base: "",
    url: url_SmartGroupsChangeState_564213, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetHistory_564222 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetHistory_564224(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetHistory_564223(path: JsonNode; query: JsonNode;
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
  var valid_564225 = path.getOrDefault("subscriptionId")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "subscriptionId", valid_564225
  var valid_564226 = path.getOrDefault("smartGroupId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "smartGroupId", valid_564226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564227 = query.getOrDefault("api-version")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_564227 != nil:
    section.add "api-version", valid_564227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564228: Call_SmartGroupsGetHistory_564222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history a smart group, which captures any Smart Group state changes (New/Acknowledged/Closed) .
  ## 
  let valid = call_564228.validator(path, query, header, formData, body)
  let scheme = call_564228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564228.url(scheme.get, call_564228.host, call_564228.base,
                         call_564228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564228, url, valid)

proc call*(call_564229: Call_SmartGroupsGetHistory_564222; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2018-05-05"): Recallable =
  ## smartGroupsGetHistory
  ## Get the history a smart group, which captures any Smart Group state changes (New/Acknowledged/Closed) .
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart group unique id. 
  var path_564230 = newJObject()
  var query_564231 = newJObject()
  add(query_564231, "api-version", newJString(apiVersion))
  add(path_564230, "subscriptionId", newJString(subscriptionId))
  add(path_564230, "smartGroupId", newJString(smartGroupId))
  result = call_564229.call(path_564230, query_564231, nil, nil, nil)

var smartGroupsGetHistory* = Call_SmartGroupsGetHistory_564222(
    name: "smartGroupsGetHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/history",
    validator: validate_SmartGroupsGetHistory_564223, base: "",
    url: url_SmartGroupsGetHistory_564224, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
