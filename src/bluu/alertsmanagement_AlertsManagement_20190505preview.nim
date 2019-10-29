
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Alerts Management Service Resource Provider
## version: 2019-05-05-preview
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
  Call_AlertsMetaData_563778 = ref object of OpenApiRestCall_563556
proc url_AlertsMetaData_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AlertsMetaData_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List alerts meta data information based on value of identifier parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   identifier: JString (required)
  ##             : Identification of the information to be retrieved by API call.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563954 = query.getOrDefault("api-version")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_563954 != nil:
    section.add "api-version", valid_563954
  var valid_563955 = query.getOrDefault("identifier")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = newJString("MonitorServiceList"))
  if valid_563955 != nil:
    section.add "identifier", valid_563955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563978: Call_AlertsMetaData_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List alerts meta data information based on value of identifier parameter.
  ## 
  let valid = call_563978.validator(path, query, header, formData, body)
  let scheme = call_563978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563978.url(scheme.get, call_563978.host, call_563978.base,
                         call_563978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563978, url, valid)

proc call*(call_564049: Call_AlertsMetaData_563778;
          apiVersion: string = "2019-05-05-preview";
          identifier: string = "MonitorServiceList"): Recallable =
  ## alertsMetaData
  ## List alerts meta data information based on value of identifier parameter.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   identifier: string (required)
  ##             : Identification of the information to be retrieved by API call.
  var query_564050 = newJObject()
  add(query_564050, "api-version", newJString(apiVersion))
  add(query_564050, "identifier", newJString(identifier))
  result = call_564049.call(nil, query_564050, nil, nil, nil)

var alertsMetaData* = Call_AlertsMetaData_563778(name: "alertsMetaData",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.AlertsManagement/alertsMetaData",
    validator: validate_AlertsMetaData_563779, base: "", url: url_AlertsMetaData_563780,
    schemes: {Scheme.Https})
type
  Call_OperationsList_564090 = ref object of OpenApiRestCall_563556
proc url_OperationsList_564092(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564091(path: JsonNode; query: JsonNode;
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
  var valid_564093 = query.getOrDefault("api-version")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564093 != nil:
    section.add "api-version", valid_564093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564094: Call_OperationsList_564090; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all operations available through Azure Alerts Management Resource Provider.
  ## 
  let valid = call_564094.validator(path, query, header, formData, body)
  let scheme = call_564094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564094.url(scheme.get, call_564094.host, call_564094.base,
                         call_564094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564094, url, valid)

proc call*(call_564095: Call_OperationsList_564090;
          apiVersion: string = "2019-05-05-preview"): Recallable =
  ## operationsList
  ## List all operations available through Azure Alerts Management Resource Provider.
  ##   apiVersion: string (required)
  ##             : client API version
  var query_564096 = newJObject()
  add(query_564096, "api-version", newJString(apiVersion))
  result = call_564095.call(nil, query_564096, nil, nil, nil)

var operationsList* = Call_OperationsList_564090(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.AlertsManagement/operations",
    validator: validate_OperationsList_564091, base: "", url: url_OperationsList_564092,
    schemes: {Scheme.Https})
type
  Call_ActionRulesListBySubscription_564097 = ref object of OpenApiRestCall_563556
proc url_ActionRulesListBySubscription_564099(protocol: Scheme; host: string;
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

proc validate_ActionRulesListBySubscription_564098(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all action rules of the subscription and given input filters
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564114 = path.getOrDefault("subscriptionId")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "subscriptionId", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   name: JString
  ##       : filter by action rule name
  ##   description: JString
  ##              : filter by alert rule description
  ##   api-version: JString (required)
  ##              : client API version
  ##   alertRuleId: JString
  ##              : filter by alert rule id
  ##   monitorService: JString
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   targetResource: JString
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   targetResourceType: JString
  ##                     : Filter by target resource type. Default value is select all.
  ##   severity: JString
  ##           : Filter by severity.  Default value is select all.
  ##   impactedScope: JString
  ##                : filter by impacted/target scope (provide comma separated list for multiple scopes). The value should be an well constructed ARM id of the scope.
  ##   actionGroup: JString
  ##              : filter by action group configured as part of action rule
  ##   targetResourceGroup: JString
  ##                      : Filter by target resource group name. Default value is select all.
  section = newJObject()
  var valid_564115 = query.getOrDefault("name")
  valid_564115 = validateParameter(valid_564115, JString, required = false,
                                 default = nil)
  if valid_564115 != nil:
    section.add "name", valid_564115
  var valid_564116 = query.getOrDefault("description")
  valid_564116 = validateParameter(valid_564116, JString, required = false,
                                 default = nil)
  if valid_564116 != nil:
    section.add "description", valid_564116
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564117 = query.getOrDefault("api-version")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564117 != nil:
    section.add "api-version", valid_564117
  var valid_564118 = query.getOrDefault("alertRuleId")
  valid_564118 = validateParameter(valid_564118, JString, required = false,
                                 default = nil)
  if valid_564118 != nil:
    section.add "alertRuleId", valid_564118
  var valid_564119 = query.getOrDefault("monitorService")
  valid_564119 = validateParameter(valid_564119, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_564119 != nil:
    section.add "monitorService", valid_564119
  var valid_564120 = query.getOrDefault("targetResource")
  valid_564120 = validateParameter(valid_564120, JString, required = false,
                                 default = nil)
  if valid_564120 != nil:
    section.add "targetResource", valid_564120
  var valid_564121 = query.getOrDefault("targetResourceType")
  valid_564121 = validateParameter(valid_564121, JString, required = false,
                                 default = nil)
  if valid_564121 != nil:
    section.add "targetResourceType", valid_564121
  var valid_564122 = query.getOrDefault("severity")
  valid_564122 = validateParameter(valid_564122, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564122 != nil:
    section.add "severity", valid_564122
  var valid_564123 = query.getOrDefault("impactedScope")
  valid_564123 = validateParameter(valid_564123, JString, required = false,
                                 default = nil)
  if valid_564123 != nil:
    section.add "impactedScope", valid_564123
  var valid_564124 = query.getOrDefault("actionGroup")
  valid_564124 = validateParameter(valid_564124, JString, required = false,
                                 default = nil)
  if valid_564124 != nil:
    section.add "actionGroup", valid_564124
  var valid_564125 = query.getOrDefault("targetResourceGroup")
  valid_564125 = validateParameter(valid_564125, JString, required = false,
                                 default = nil)
  if valid_564125 != nil:
    section.add "targetResourceGroup", valid_564125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564126: Call_ActionRulesListBySubscription_564097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all action rules of the subscription and given input filters
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_ActionRulesListBySubscription_564097;
          subscriptionId: string; name: string = ""; description: string = "";
          apiVersion: string = "2019-05-05-preview"; alertRuleId: string = "";
          monitorService: string = "Application Insights";
          targetResource: string = ""; targetResourceType: string = "";
          severity: string = "Sev0"; impactedScope: string = "";
          actionGroup: string = ""; targetResourceGroup: string = ""): Recallable =
  ## actionRulesListBySubscription
  ## List all action rules of the subscription and given input filters
  ##   name: string
  ##       : filter by action rule name
  ##   description: string
  ##              : filter by alert rule description
  ##   apiVersion: string (required)
  ##             : client API version
  ##   alertRuleId: string
  ##              : filter by alert rule id
  ##   monitorService: string
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   targetResourceType: string
  ##                     : Filter by target resource type. Default value is select all.
  ##   severity: string
  ##           : Filter by severity.  Default value is select all.
  ##   impactedScope: string
  ##                : filter by impacted/target scope (provide comma separated list for multiple scopes). The value should be an well constructed ARM id of the scope.
  ##   actionGroup: string
  ##              : filter by action group configured as part of action rule
  ##   targetResourceGroup: string
  ##                      : Filter by target resource group name. Default value is select all.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  add(query_564129, "name", newJString(name))
  add(query_564129, "description", newJString(description))
  add(query_564129, "api-version", newJString(apiVersion))
  add(query_564129, "alertRuleId", newJString(alertRuleId))
  add(query_564129, "monitorService", newJString(monitorService))
  add(query_564129, "targetResource", newJString(targetResource))
  add(path_564128, "subscriptionId", newJString(subscriptionId))
  add(query_564129, "targetResourceType", newJString(targetResourceType))
  add(query_564129, "severity", newJString(severity))
  add(query_564129, "impactedScope", newJString(impactedScope))
  add(query_564129, "actionGroup", newJString(actionGroup))
  add(query_564129, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564127.call(path_564128, query_564129, nil, nil, nil)

var actionRulesListBySubscription* = Call_ActionRulesListBySubscription_564097(
    name: "actionRulesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/actionRules",
    validator: validate_ActionRulesListBySubscription_564098, base: "",
    url: url_ActionRulesListBySubscription_564099, schemes: {Scheme.Https})
type
  Call_AlertsGetAll_564130 = ref object of OpenApiRestCall_563556
proc url_AlertsGetAll_564132(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetAll_564131(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List all existing alerts, where the results can be filtered on the basis of multiple parameters (e.g. time range). The results can then be sorted on the basis specific fields, with the default being lastModifiedDateTime. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564133 = path.getOrDefault("subscriptionId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "subscriptionId", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   monitorCondition: JString
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   includeEgressConfig: JBool
  ##                      : Include egress config which would be used for displaying the content in portal.  Default value is 'false'.
  ##   sortBy: JString
  ##         : Sort the query results by input field,  Default value is 'lastModifiedDateTime'.
  ##   api-version: JString (required)
  ##              : client API version
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
  var valid_564134 = query.getOrDefault("monitorCondition")
  valid_564134 = validateParameter(valid_564134, JString, required = false,
                                 default = newJString("Fired"))
  if valid_564134 != nil:
    section.add "monitorCondition", valid_564134
  var valid_564135 = query.getOrDefault("includeEgressConfig")
  valid_564135 = validateParameter(valid_564135, JBool, required = false, default = nil)
  if valid_564135 != nil:
    section.add "includeEgressConfig", valid_564135
  var valid_564136 = query.getOrDefault("sortBy")
  valid_564136 = validateParameter(valid_564136, JString, required = false,
                                 default = newJString("name"))
  if valid_564136 != nil:
    section.add "sortBy", valid_564136
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564137 = query.getOrDefault("api-version")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564137 != nil:
    section.add "api-version", valid_564137
  var valid_564138 = query.getOrDefault("pageCount")
  valid_564138 = validateParameter(valid_564138, JInt, required = false, default = nil)
  if valid_564138 != nil:
    section.add "pageCount", valid_564138
  var valid_564139 = query.getOrDefault("monitorService")
  valid_564139 = validateParameter(valid_564139, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_564139 != nil:
    section.add "monitorService", valid_564139
  var valid_564140 = query.getOrDefault("select")
  valid_564140 = validateParameter(valid_564140, JString, required = false,
                                 default = nil)
  if valid_564140 != nil:
    section.add "select", valid_564140
  var valid_564141 = query.getOrDefault("alertRule")
  valid_564141 = validateParameter(valid_564141, JString, required = false,
                                 default = nil)
  if valid_564141 != nil:
    section.add "alertRule", valid_564141
  var valid_564142 = query.getOrDefault("alertState")
  valid_564142 = validateParameter(valid_564142, JString, required = false,
                                 default = newJString("New"))
  if valid_564142 != nil:
    section.add "alertState", valid_564142
  var valid_564143 = query.getOrDefault("targetResource")
  valid_564143 = validateParameter(valid_564143, JString, required = false,
                                 default = nil)
  if valid_564143 != nil:
    section.add "targetResource", valid_564143
  var valid_564144 = query.getOrDefault("customTimeRange")
  valid_564144 = validateParameter(valid_564144, JString, required = false,
                                 default = nil)
  if valid_564144 != nil:
    section.add "customTimeRange", valid_564144
  var valid_564145 = query.getOrDefault("includeContext")
  valid_564145 = validateParameter(valid_564145, JBool, required = false, default = nil)
  if valid_564145 != nil:
    section.add "includeContext", valid_564145
  var valid_564146 = query.getOrDefault("targetResourceType")
  valid_564146 = validateParameter(valid_564146, JString, required = false,
                                 default = nil)
  if valid_564146 != nil:
    section.add "targetResourceType", valid_564146
  var valid_564147 = query.getOrDefault("sortOrder")
  valid_564147 = validateParameter(valid_564147, JString, required = false,
                                 default = newJString("asc"))
  if valid_564147 != nil:
    section.add "sortOrder", valid_564147
  var valid_564148 = query.getOrDefault("timeRange")
  valid_564148 = validateParameter(valid_564148, JString, required = false,
                                 default = newJString("1h"))
  if valid_564148 != nil:
    section.add "timeRange", valid_564148
  var valid_564149 = query.getOrDefault("severity")
  valid_564149 = validateParameter(valid_564149, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564149 != nil:
    section.add "severity", valid_564149
  var valid_564150 = query.getOrDefault("smartGroupId")
  valid_564150 = validateParameter(valid_564150, JString, required = false,
                                 default = nil)
  if valid_564150 != nil:
    section.add "smartGroupId", valid_564150
  var valid_564151 = query.getOrDefault("targetResourceGroup")
  valid_564151 = validateParameter(valid_564151, JString, required = false,
                                 default = nil)
  if valid_564151 != nil:
    section.add "targetResourceGroup", valid_564151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564152: Call_AlertsGetAll_564130; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all existing alerts, where the results can be filtered on the basis of multiple parameters (e.g. time range). The results can then be sorted on the basis specific fields, with the default being lastModifiedDateTime. 
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_AlertsGetAll_564130; subscriptionId: string;
          monitorCondition: string = "Fired"; includeEgressConfig: bool = false;
          sortBy: string = "name"; apiVersion: string = "2019-05-05-preview";
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
  ##             : client API version
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
  ##                 : The ID of the target subscription.
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
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  add(query_564155, "monitorCondition", newJString(monitorCondition))
  add(query_564155, "includeEgressConfig", newJBool(includeEgressConfig))
  add(query_564155, "sortBy", newJString(sortBy))
  add(query_564155, "api-version", newJString(apiVersion))
  add(query_564155, "pageCount", newJInt(pageCount))
  add(query_564155, "monitorService", newJString(monitorService))
  add(query_564155, "select", newJString(select))
  add(query_564155, "alertRule", newJString(alertRule))
  add(query_564155, "alertState", newJString(alertState))
  add(query_564155, "targetResource", newJString(targetResource))
  add(query_564155, "customTimeRange", newJString(customTimeRange))
  add(query_564155, "includeContext", newJBool(includeContext))
  add(path_564154, "subscriptionId", newJString(subscriptionId))
  add(query_564155, "targetResourceType", newJString(targetResourceType))
  add(query_564155, "sortOrder", newJString(sortOrder))
  add(query_564155, "timeRange", newJString(timeRange))
  add(query_564155, "severity", newJString(severity))
  add(query_564155, "smartGroupId", newJString(smartGroupId))
  add(query_564155, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564153.call(path_564154, query_564155, nil, nil, nil)

var alertsGetAll* = Call_AlertsGetAll_564130(name: "alertsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts",
    validator: validate_AlertsGetAll_564131, base: "", url: url_AlertsGetAll_564132,
    schemes: {Scheme.Https})
type
  Call_AlertsGetById_564156 = ref object of OpenApiRestCall_563556
proc url_AlertsGetById_564158(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetById_564157(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information related to a specific alert
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Unique ID of an alert instance.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564159 = path.getOrDefault("alertId")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "alertId", valid_564159
  var valid_564160 = path.getOrDefault("subscriptionId")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "subscriptionId", valid_564160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564161 = query.getOrDefault("api-version")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564161 != nil:
    section.add "api-version", valid_564161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564162: Call_AlertsGetById_564156; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific alert
  ## 
  let valid = call_564162.validator(path, query, header, formData, body)
  let scheme = call_564162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564162.url(scheme.get, call_564162.host, call_564162.base,
                         call_564162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564162, url, valid)

proc call*(call_564163: Call_AlertsGetById_564156; alertId: string;
          subscriptionId: string; apiVersion: string = "2019-05-05-preview"): Recallable =
  ## alertsGetById
  ## Get information related to a specific alert
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_564164 = newJObject()
  var query_564165 = newJObject()
  add(path_564164, "alertId", newJString(alertId))
  add(query_564165, "api-version", newJString(apiVersion))
  add(path_564164, "subscriptionId", newJString(subscriptionId))
  result = call_564163.call(path_564164, query_564165, nil, nil, nil)

var alertsGetById* = Call_AlertsGetById_564156(name: "alertsGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}",
    validator: validate_AlertsGetById_564157, base: "", url: url_AlertsGetById_564158,
    schemes: {Scheme.Https})
type
  Call_AlertsChangeState_564166 = ref object of OpenApiRestCall_563556
proc url_AlertsChangeState_564168(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsChangeState_564167(path: JsonNode; query: JsonNode;
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
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564169 = path.getOrDefault("alertId")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "alertId", valid_564169
  var valid_564170 = path.getOrDefault("subscriptionId")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "subscriptionId", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   newState: JString (required)
  ##           : New state of the alert.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564171 = query.getOrDefault("api-version")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564171 != nil:
    section.add "api-version", valid_564171
  var valid_564172 = query.getOrDefault("newState")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = newJString("New"))
  if valid_564172 != nil:
    section.add "newState", valid_564172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564173: Call_AlertsChangeState_564166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of an alert.
  ## 
  let valid = call_564173.validator(path, query, header, formData, body)
  let scheme = call_564173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564173.url(scheme.get, call_564173.host, call_564173.base,
                         call_564173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564173, url, valid)

proc call*(call_564174: Call_AlertsChangeState_564166; alertId: string;
          subscriptionId: string; apiVersion: string = "2019-05-05-preview";
          newState: string = "New"): Recallable =
  ## alertsChangeState
  ## Change the state of an alert.
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   newState: string (required)
  ##           : New state of the alert.
  var path_564175 = newJObject()
  var query_564176 = newJObject()
  add(path_564175, "alertId", newJString(alertId))
  add(query_564176, "api-version", newJString(apiVersion))
  add(path_564175, "subscriptionId", newJString(subscriptionId))
  add(query_564176, "newState", newJString(newState))
  result = call_564174.call(path_564175, query_564176, nil, nil, nil)

var alertsChangeState* = Call_AlertsChangeState_564166(name: "alertsChangeState",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/changestate",
    validator: validate_AlertsChangeState_564167, base: "",
    url: url_AlertsChangeState_564168, schemes: {Scheme.Https})
type
  Call_AlertsGetHistory_564177 = ref object of OpenApiRestCall_563556
proc url_AlertsGetHistory_564179(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetHistory_564178(path: JsonNode; query: JsonNode;
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
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_564180 = path.getOrDefault("alertId")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "alertId", valid_564180
  var valid_564181 = path.getOrDefault("subscriptionId")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "subscriptionId", valid_564181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564182 = query.getOrDefault("api-version")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564182 != nil:
    section.add "api-version", valid_564182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564183: Call_AlertsGetHistory_564177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved) and alert state changes (New/Acknowledged/Closed).
  ## 
  let valid = call_564183.validator(path, query, header, formData, body)
  let scheme = call_564183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564183.url(scheme.get, call_564183.host, call_564183.base,
                         call_564183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564183, url, valid)

proc call*(call_564184: Call_AlertsGetHistory_564177; alertId: string;
          subscriptionId: string; apiVersion: string = "2019-05-05-preview"): Recallable =
  ## alertsGetHistory
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved) and alert state changes (New/Acknowledged/Closed).
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_564185 = newJObject()
  var query_564186 = newJObject()
  add(path_564185, "alertId", newJString(alertId))
  add(query_564186, "api-version", newJString(apiVersion))
  add(path_564185, "subscriptionId", newJString(subscriptionId))
  result = call_564184.call(path_564185, query_564186, nil, nil, nil)

var alertsGetHistory* = Call_AlertsGetHistory_564177(name: "alertsGetHistory",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/history",
    validator: validate_AlertsGetHistory_564178, base: "",
    url: url_AlertsGetHistory_564179, schemes: {Scheme.Https})
type
  Call_AlertsGetSummary_564187 = ref object of OpenApiRestCall_563556
proc url_AlertsGetSummary_564189(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetSummary_564188(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get a summarized count of your alerts grouped by various parameters (e.g. grouping by 'Severity' returns the count of alerts for each severity).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564190 = path.getOrDefault("subscriptionId")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "subscriptionId", valid_564190
  result.add "path", section
  ## parameters in `query` object:
  ##   monitorCondition: JString
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   includeSmartGroupsCount: JBool
  ##                          : Include count of the SmartGroups as part of the summary. Default value is 'false'.
  ##   api-version: JString (required)
  ##              : client API version
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
  ##          : This parameter allows the result set to be grouped by input fields (Maximum 2 comma separated fields supported). For example, groupby=severity or groupby=severity,alertstate.
  ##   targetResourceGroup: JString
  ##                      : Filter by target resource group name. Default value is select all.
  section = newJObject()
  var valid_564191 = query.getOrDefault("monitorCondition")
  valid_564191 = validateParameter(valid_564191, JString, required = false,
                                 default = newJString("Fired"))
  if valid_564191 != nil:
    section.add "monitorCondition", valid_564191
  var valid_564192 = query.getOrDefault("includeSmartGroupsCount")
  valid_564192 = validateParameter(valid_564192, JBool, required = false, default = nil)
  if valid_564192 != nil:
    section.add "includeSmartGroupsCount", valid_564192
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564193 = query.getOrDefault("api-version")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564193 != nil:
    section.add "api-version", valid_564193
  var valid_564194 = query.getOrDefault("monitorService")
  valid_564194 = validateParameter(valid_564194, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_564194 != nil:
    section.add "monitorService", valid_564194
  var valid_564195 = query.getOrDefault("alertRule")
  valid_564195 = validateParameter(valid_564195, JString, required = false,
                                 default = nil)
  if valid_564195 != nil:
    section.add "alertRule", valid_564195
  var valid_564196 = query.getOrDefault("alertState")
  valid_564196 = validateParameter(valid_564196, JString, required = false,
                                 default = newJString("New"))
  if valid_564196 != nil:
    section.add "alertState", valid_564196
  var valid_564197 = query.getOrDefault("targetResource")
  valid_564197 = validateParameter(valid_564197, JString, required = false,
                                 default = nil)
  if valid_564197 != nil:
    section.add "targetResource", valid_564197
  var valid_564198 = query.getOrDefault("customTimeRange")
  valid_564198 = validateParameter(valid_564198, JString, required = false,
                                 default = nil)
  if valid_564198 != nil:
    section.add "customTimeRange", valid_564198
  var valid_564199 = query.getOrDefault("targetResourceType")
  valid_564199 = validateParameter(valid_564199, JString, required = false,
                                 default = nil)
  if valid_564199 != nil:
    section.add "targetResourceType", valid_564199
  var valid_564200 = query.getOrDefault("timeRange")
  valid_564200 = validateParameter(valid_564200, JString, required = false,
                                 default = newJString("1h"))
  if valid_564200 != nil:
    section.add "timeRange", valid_564200
  var valid_564201 = query.getOrDefault("severity")
  valid_564201 = validateParameter(valid_564201, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564201 != nil:
    section.add "severity", valid_564201
  var valid_564202 = query.getOrDefault("groupby")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = newJString("severity"))
  if valid_564202 != nil:
    section.add "groupby", valid_564202
  var valid_564203 = query.getOrDefault("targetResourceGroup")
  valid_564203 = validateParameter(valid_564203, JString, required = false,
                                 default = nil)
  if valid_564203 != nil:
    section.add "targetResourceGroup", valid_564203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564204: Call_AlertsGetSummary_564187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a summarized count of your alerts grouped by various parameters (e.g. grouping by 'Severity' returns the count of alerts for each severity).
  ## 
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_AlertsGetSummary_564187; subscriptionId: string;
          monitorCondition: string = "Fired"; includeSmartGroupsCount: bool = false;
          apiVersion: string = "2019-05-05-preview";
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
  ##             : client API version
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
  ##                 : The ID of the target subscription.
  ##   targetResourceType: string
  ##                     : Filter by target resource type. Default value is select all.
  ##   timeRange: string
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   severity: string
  ##           : Filter by severity.  Default value is select all.
  ##   groupby: string (required)
  ##          : This parameter allows the result set to be grouped by input fields (Maximum 2 comma separated fields supported). For example, groupby=severity or groupby=severity,alertstate.
  ##   targetResourceGroup: string
  ##                      : Filter by target resource group name. Default value is select all.
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  add(query_564207, "monitorCondition", newJString(monitorCondition))
  add(query_564207, "includeSmartGroupsCount", newJBool(includeSmartGroupsCount))
  add(query_564207, "api-version", newJString(apiVersion))
  add(query_564207, "monitorService", newJString(monitorService))
  add(query_564207, "alertRule", newJString(alertRule))
  add(query_564207, "alertState", newJString(alertState))
  add(query_564207, "targetResource", newJString(targetResource))
  add(query_564207, "customTimeRange", newJString(customTimeRange))
  add(path_564206, "subscriptionId", newJString(subscriptionId))
  add(query_564207, "targetResourceType", newJString(targetResourceType))
  add(query_564207, "timeRange", newJString(timeRange))
  add(query_564207, "severity", newJString(severity))
  add(query_564207, "groupby", newJString(groupby))
  add(query_564207, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564205.call(path_564206, query_564207, nil, nil, nil)

var alertsGetSummary* = Call_AlertsGetSummary_564187(name: "alertsGetSummary",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alertsSummary",
    validator: validate_AlertsGetSummary_564188, base: "",
    url: url_AlertsGetSummary_564189, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetAll_564208 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetAll_564210(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetAll_564209(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List all the Smart Groups within a specified subscription. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564211 = path.getOrDefault("subscriptionId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "subscriptionId", valid_564211
  result.add "path", section
  ## parameters in `query` object:
  ##   monitorCondition: JString
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   sortBy: JString
  ##         : Sort the query results by input field. Default value is sort by 'lastModifiedDateTime'.
  ##   api-version: JString (required)
  ##              : client API version
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
  var valid_564212 = query.getOrDefault("monitorCondition")
  valid_564212 = validateParameter(valid_564212, JString, required = false,
                                 default = newJString("Fired"))
  if valid_564212 != nil:
    section.add "monitorCondition", valid_564212
  var valid_564213 = query.getOrDefault("sortBy")
  valid_564213 = validateParameter(valid_564213, JString, required = false,
                                 default = newJString("alertsCount"))
  if valid_564213 != nil:
    section.add "sortBy", valid_564213
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564214 = query.getOrDefault("api-version")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564214 != nil:
    section.add "api-version", valid_564214
  var valid_564215 = query.getOrDefault("pageCount")
  valid_564215 = validateParameter(valid_564215, JInt, required = false, default = nil)
  if valid_564215 != nil:
    section.add "pageCount", valid_564215
  var valid_564216 = query.getOrDefault("monitorService")
  valid_564216 = validateParameter(valid_564216, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_564216 != nil:
    section.add "monitorService", valid_564216
  var valid_564217 = query.getOrDefault("smartGroupState")
  valid_564217 = validateParameter(valid_564217, JString, required = false,
                                 default = newJString("New"))
  if valid_564217 != nil:
    section.add "smartGroupState", valid_564217
  var valid_564218 = query.getOrDefault("targetResource")
  valid_564218 = validateParameter(valid_564218, JString, required = false,
                                 default = nil)
  if valid_564218 != nil:
    section.add "targetResource", valid_564218
  var valid_564219 = query.getOrDefault("targetResourceType")
  valid_564219 = validateParameter(valid_564219, JString, required = false,
                                 default = nil)
  if valid_564219 != nil:
    section.add "targetResourceType", valid_564219
  var valid_564220 = query.getOrDefault("sortOrder")
  valid_564220 = validateParameter(valid_564220, JString, required = false,
                                 default = newJString("asc"))
  if valid_564220 != nil:
    section.add "sortOrder", valid_564220
  var valid_564221 = query.getOrDefault("timeRange")
  valid_564221 = validateParameter(valid_564221, JString, required = false,
                                 default = newJString("1h"))
  if valid_564221 != nil:
    section.add "timeRange", valid_564221
  var valid_564222 = query.getOrDefault("severity")
  valid_564222 = validateParameter(valid_564222, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564222 != nil:
    section.add "severity", valid_564222
  var valid_564223 = query.getOrDefault("targetResourceGroup")
  valid_564223 = validateParameter(valid_564223, JString, required = false,
                                 default = nil)
  if valid_564223 != nil:
    section.add "targetResourceGroup", valid_564223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564224: Call_SmartGroupsGetAll_564208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the Smart Groups within a specified subscription. 
  ## 
  let valid = call_564224.validator(path, query, header, formData, body)
  let scheme = call_564224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564224.url(scheme.get, call_564224.host, call_564224.base,
                         call_564224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564224, url, valid)

proc call*(call_564225: Call_SmartGroupsGetAll_564208; subscriptionId: string;
          monitorCondition: string = "Fired"; sortBy: string = "alertsCount";
          apiVersion: string = "2019-05-05-preview"; pageCount: int = 0;
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
  ##             : client API version
  ##   pageCount: int
  ##            : Determines number of alerts returned per page in response. Permissible value is between 1 to 250. When the "includeContent"  filter is selected, maximum value allowed is 25. Default value is 25.
  ##   monitorService: string
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   smartGroupState: string
  ##                  : Filter by state of the smart group. Default value is to select all.
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
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
  var path_564226 = newJObject()
  var query_564227 = newJObject()
  add(query_564227, "monitorCondition", newJString(monitorCondition))
  add(query_564227, "sortBy", newJString(sortBy))
  add(query_564227, "api-version", newJString(apiVersion))
  add(query_564227, "pageCount", newJInt(pageCount))
  add(query_564227, "monitorService", newJString(monitorService))
  add(query_564227, "smartGroupState", newJString(smartGroupState))
  add(query_564227, "targetResource", newJString(targetResource))
  add(path_564226, "subscriptionId", newJString(subscriptionId))
  add(query_564227, "targetResourceType", newJString(targetResourceType))
  add(query_564227, "sortOrder", newJString(sortOrder))
  add(query_564227, "timeRange", newJString(timeRange))
  add(query_564227, "severity", newJString(severity))
  add(query_564227, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564225.call(path_564226, query_564227, nil, nil, nil)

var smartGroupsGetAll* = Call_SmartGroupsGetAll_564208(name: "smartGroupsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups",
    validator: validate_SmartGroupsGetAll_564209, base: "",
    url: url_SmartGroupsGetAll_564210, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetById_564228 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetById_564230(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetById_564229(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get information related to a specific Smart Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   smartGroupId: JString (required)
  ##               : Smart group unique id. 
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564231 = path.getOrDefault("subscriptionId")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "subscriptionId", valid_564231
  var valid_564232 = path.getOrDefault("smartGroupId")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "smartGroupId", valid_564232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564233 = query.getOrDefault("api-version")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564233 != nil:
    section.add "api-version", valid_564233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564234: Call_SmartGroupsGetById_564228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific Smart Group.
  ## 
  let valid = call_564234.validator(path, query, header, formData, body)
  let scheme = call_564234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564234.url(scheme.get, call_564234.host, call_564234.base,
                         call_564234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564234, url, valid)

proc call*(call_564235: Call_SmartGroupsGetById_564228; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2019-05-05-preview"): Recallable =
  ## smartGroupsGetById
  ## Get information related to a specific Smart Group.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   smartGroupId: string (required)
  ##               : Smart group unique id. 
  var path_564236 = newJObject()
  var query_564237 = newJObject()
  add(query_564237, "api-version", newJString(apiVersion))
  add(path_564236, "subscriptionId", newJString(subscriptionId))
  add(path_564236, "smartGroupId", newJString(smartGroupId))
  result = call_564235.call(path_564236, query_564237, nil, nil, nil)

var smartGroupsGetById* = Call_SmartGroupsGetById_564228(
    name: "smartGroupsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}",
    validator: validate_SmartGroupsGetById_564229, base: "",
    url: url_SmartGroupsGetById_564230, schemes: {Scheme.Https})
type
  Call_SmartGroupsChangeState_564238 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsChangeState_564240(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsChangeState_564239(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Change the state of a Smart Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   smartGroupId: JString (required)
  ##               : Smart group unique id. 
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564241 = path.getOrDefault("subscriptionId")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "subscriptionId", valid_564241
  var valid_564242 = path.getOrDefault("smartGroupId")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "smartGroupId", valid_564242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   newState: JString (required)
  ##           : New state of the alert.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564243 = query.getOrDefault("api-version")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564243 != nil:
    section.add "api-version", valid_564243
  var valid_564244 = query.getOrDefault("newState")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = newJString("New"))
  if valid_564244 != nil:
    section.add "newState", valid_564244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564245: Call_SmartGroupsChangeState_564238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of a Smart Group.
  ## 
  let valid = call_564245.validator(path, query, header, formData, body)
  let scheme = call_564245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564245.url(scheme.get, call_564245.host, call_564245.base,
                         call_564245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564245, url, valid)

proc call*(call_564246: Call_SmartGroupsChangeState_564238; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2019-05-05-preview";
          newState: string = "New"): Recallable =
  ## smartGroupsChangeState
  ## Change the state of a Smart Group.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   smartGroupId: string (required)
  ##               : Smart group unique id. 
  ##   newState: string (required)
  ##           : New state of the alert.
  var path_564247 = newJObject()
  var query_564248 = newJObject()
  add(query_564248, "api-version", newJString(apiVersion))
  add(path_564247, "subscriptionId", newJString(subscriptionId))
  add(path_564247, "smartGroupId", newJString(smartGroupId))
  add(query_564248, "newState", newJString(newState))
  result = call_564246.call(path_564247, query_564248, nil, nil, nil)

var smartGroupsChangeState* = Call_SmartGroupsChangeState_564238(
    name: "smartGroupsChangeState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/changeState",
    validator: validate_SmartGroupsChangeState_564239, base: "",
    url: url_SmartGroupsChangeState_564240, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetHistory_564249 = ref object of OpenApiRestCall_563556
proc url_SmartGroupsGetHistory_564251(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetHistory_564250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the history a smart group, which captures any Smart Group state changes (New/Acknowledged/Closed) .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   smartGroupId: JString (required)
  ##               : Smart group unique id. 
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564252 = path.getOrDefault("subscriptionId")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "subscriptionId", valid_564252
  var valid_564253 = path.getOrDefault("smartGroupId")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "smartGroupId", valid_564253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564254 = query.getOrDefault("api-version")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564254 != nil:
    section.add "api-version", valid_564254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564255: Call_SmartGroupsGetHistory_564249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history a smart group, which captures any Smart Group state changes (New/Acknowledged/Closed) .
  ## 
  let valid = call_564255.validator(path, query, header, formData, body)
  let scheme = call_564255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564255.url(scheme.get, call_564255.host, call_564255.base,
                         call_564255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564255, url, valid)

proc call*(call_564256: Call_SmartGroupsGetHistory_564249; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2019-05-05-preview"): Recallable =
  ## smartGroupsGetHistory
  ## Get the history a smart group, which captures any Smart Group state changes (New/Acknowledged/Closed) .
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   smartGroupId: string (required)
  ##               : Smart group unique id. 
  var path_564257 = newJObject()
  var query_564258 = newJObject()
  add(query_564258, "api-version", newJString(apiVersion))
  add(path_564257, "subscriptionId", newJString(subscriptionId))
  add(path_564257, "smartGroupId", newJString(smartGroupId))
  result = call_564256.call(path_564257, query_564258, nil, nil, nil)

var smartGroupsGetHistory* = Call_SmartGroupsGetHistory_564249(
    name: "smartGroupsGetHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/history",
    validator: validate_SmartGroupsGetHistory_564250, base: "",
    url: url_SmartGroupsGetHistory_564251, schemes: {Scheme.Https})
type
  Call_ActionRulesListByResourceGroup_564259 = ref object of OpenApiRestCall_563556
proc url_ActionRulesListByResourceGroup_564261(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/actionRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActionRulesListByResourceGroup_564260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all action rules of the subscription, created in given resource group and given input filters
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name where the resource is created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564262 = path.getOrDefault("subscriptionId")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "subscriptionId", valid_564262
  var valid_564263 = path.getOrDefault("resourceGroupName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "resourceGroupName", valid_564263
  result.add "path", section
  ## parameters in `query` object:
  ##   name: JString
  ##       : filter by action rule name
  ##   description: JString
  ##              : filter by alert rule description
  ##   api-version: JString (required)
  ##              : client API version
  ##   alertRuleId: JString
  ##              : filter by alert rule id
  ##   monitorService: JString
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   targetResource: JString
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   targetResourceType: JString
  ##                     : Filter by target resource type. Default value is select all.
  ##   severity: JString
  ##           : Filter by severity.  Default value is select all.
  ##   impactedScope: JString
  ##                : filter by impacted/target scope (provide comma separated list for multiple scopes). The value should be an well constructed ARM id of the scope.
  ##   actionGroup: JString
  ##              : filter by action group configured as part of action rule
  ##   targetResourceGroup: JString
  ##                      : Filter by target resource group name. Default value is select all.
  section = newJObject()
  var valid_564264 = query.getOrDefault("name")
  valid_564264 = validateParameter(valid_564264, JString, required = false,
                                 default = nil)
  if valid_564264 != nil:
    section.add "name", valid_564264
  var valid_564265 = query.getOrDefault("description")
  valid_564265 = validateParameter(valid_564265, JString, required = false,
                                 default = nil)
  if valid_564265 != nil:
    section.add "description", valid_564265
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564266 = query.getOrDefault("api-version")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564266 != nil:
    section.add "api-version", valid_564266
  var valid_564267 = query.getOrDefault("alertRuleId")
  valid_564267 = validateParameter(valid_564267, JString, required = false,
                                 default = nil)
  if valid_564267 != nil:
    section.add "alertRuleId", valid_564267
  var valid_564268 = query.getOrDefault("monitorService")
  valid_564268 = validateParameter(valid_564268, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_564268 != nil:
    section.add "monitorService", valid_564268
  var valid_564269 = query.getOrDefault("targetResource")
  valid_564269 = validateParameter(valid_564269, JString, required = false,
                                 default = nil)
  if valid_564269 != nil:
    section.add "targetResource", valid_564269
  var valid_564270 = query.getOrDefault("targetResourceType")
  valid_564270 = validateParameter(valid_564270, JString, required = false,
                                 default = nil)
  if valid_564270 != nil:
    section.add "targetResourceType", valid_564270
  var valid_564271 = query.getOrDefault("severity")
  valid_564271 = validateParameter(valid_564271, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_564271 != nil:
    section.add "severity", valid_564271
  var valid_564272 = query.getOrDefault("impactedScope")
  valid_564272 = validateParameter(valid_564272, JString, required = false,
                                 default = nil)
  if valid_564272 != nil:
    section.add "impactedScope", valid_564272
  var valid_564273 = query.getOrDefault("actionGroup")
  valid_564273 = validateParameter(valid_564273, JString, required = false,
                                 default = nil)
  if valid_564273 != nil:
    section.add "actionGroup", valid_564273
  var valid_564274 = query.getOrDefault("targetResourceGroup")
  valid_564274 = validateParameter(valid_564274, JString, required = false,
                                 default = nil)
  if valid_564274 != nil:
    section.add "targetResourceGroup", valid_564274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564275: Call_ActionRulesListByResourceGroup_564259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all action rules of the subscription, created in given resource group and given input filters
  ## 
  let valid = call_564275.validator(path, query, header, formData, body)
  let scheme = call_564275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564275.url(scheme.get, call_564275.host, call_564275.base,
                         call_564275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564275, url, valid)

proc call*(call_564276: Call_ActionRulesListByResourceGroup_564259;
          subscriptionId: string; resourceGroupName: string; name: string = "";
          description: string = ""; apiVersion: string = "2019-05-05-preview";
          alertRuleId: string = ""; monitorService: string = "Application Insights";
          targetResource: string = ""; targetResourceType: string = "";
          severity: string = "Sev0"; impactedScope: string = "";
          actionGroup: string = ""; targetResourceGroup: string = ""): Recallable =
  ## actionRulesListByResourceGroup
  ## List all action rules of the subscription, created in given resource group and given input filters
  ##   name: string
  ##       : filter by action rule name
  ##   description: string
  ##              : filter by alert rule description
  ##   apiVersion: string (required)
  ##             : client API version
  ##   alertRuleId: string
  ##              : filter by alert rule id
  ##   monitorService: string
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   targetResourceType: string
  ##                     : Filter by target resource type. Default value is select all.
  ##   severity: string
  ##           : Filter by severity.  Default value is select all.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name where the resource is created.
  ##   impactedScope: string
  ##                : filter by impacted/target scope (provide comma separated list for multiple scopes). The value should be an well constructed ARM id of the scope.
  ##   actionGroup: string
  ##              : filter by action group configured as part of action rule
  ##   targetResourceGroup: string
  ##                      : Filter by target resource group name. Default value is select all.
  var path_564277 = newJObject()
  var query_564278 = newJObject()
  add(query_564278, "name", newJString(name))
  add(query_564278, "description", newJString(description))
  add(query_564278, "api-version", newJString(apiVersion))
  add(query_564278, "alertRuleId", newJString(alertRuleId))
  add(query_564278, "monitorService", newJString(monitorService))
  add(query_564278, "targetResource", newJString(targetResource))
  add(path_564277, "subscriptionId", newJString(subscriptionId))
  add(query_564278, "targetResourceType", newJString(targetResourceType))
  add(query_564278, "severity", newJString(severity))
  add(path_564277, "resourceGroupName", newJString(resourceGroupName))
  add(query_564278, "impactedScope", newJString(impactedScope))
  add(query_564278, "actionGroup", newJString(actionGroup))
  add(query_564278, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_564276.call(path_564277, query_564278, nil, nil, nil)

var actionRulesListByResourceGroup* = Call_ActionRulesListByResourceGroup_564259(
    name: "actionRulesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AlertsManagement/actionRules",
    validator: validate_ActionRulesListByResourceGroup_564260, base: "",
    url: url_ActionRulesListByResourceGroup_564261, schemes: {Scheme.Https})
type
  Call_ActionRulesCreateUpdate_564290 = ref object of OpenApiRestCall_563556
proc url_ActionRulesCreateUpdate_564292(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "actionRuleName" in path, "`actionRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/actionRules/"),
               (kind: VariableSegment, value: "actionRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActionRulesCreateUpdate_564291(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates/Updates a specific action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   actionRuleName: JString (required)
  ##                 : The name of action rule that needs to be created/updated
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name where the resource is created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `actionRuleName` field"
  var valid_564310 = path.getOrDefault("actionRuleName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "actionRuleName", valid_564310
  var valid_564311 = path.getOrDefault("subscriptionId")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "subscriptionId", valid_564311
  var valid_564312 = path.getOrDefault("resourceGroupName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "resourceGroupName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564313 != nil:
    section.add "api-version", valid_564313
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

proc call*(call_564315: Call_ActionRulesCreateUpdate_564290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates/Updates a specific action rule
  ## 
  let valid = call_564315.validator(path, query, header, formData, body)
  let scheme = call_564315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564315.url(scheme.get, call_564315.host, call_564315.base,
                         call_564315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564315, url, valid)

proc call*(call_564316: Call_ActionRulesCreateUpdate_564290; actionRule: JsonNode;
          actionRuleName: string; subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2019-05-05-preview"): Recallable =
  ## actionRulesCreateUpdate
  ## Creates/Updates a specific action rule
  ##   actionRule: JObject (required)
  ##             : action rule to be created/updated
  ##   apiVersion: string (required)
  ##             : client API version
  ##   actionRuleName: string (required)
  ##                 : The name of action rule that needs to be created/updated
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name where the resource is created.
  var path_564317 = newJObject()
  var query_564318 = newJObject()
  var body_564319 = newJObject()
  if actionRule != nil:
    body_564319 = actionRule
  add(query_564318, "api-version", newJString(apiVersion))
  add(path_564317, "actionRuleName", newJString(actionRuleName))
  add(path_564317, "subscriptionId", newJString(subscriptionId))
  add(path_564317, "resourceGroupName", newJString(resourceGroupName))
  result = call_564316.call(path_564317, query_564318, nil, nil, body_564319)

var actionRulesCreateUpdate* = Call_ActionRulesCreateUpdate_564290(
    name: "actionRulesCreateUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesCreateUpdate_564291, base: "",
    url: url_ActionRulesCreateUpdate_564292, schemes: {Scheme.Https})
type
  Call_ActionRulesGetByName_564279 = ref object of OpenApiRestCall_563556
proc url_ActionRulesGetByName_564281(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "actionRuleName" in path, "`actionRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/actionRules/"),
               (kind: VariableSegment, value: "actionRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActionRulesGetByName_564280(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   actionRuleName: JString (required)
  ##                 : The name of action rule that needs to be fetched
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name where the resource is created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `actionRuleName` field"
  var valid_564282 = path.getOrDefault("actionRuleName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "actionRuleName", valid_564282
  var valid_564283 = path.getOrDefault("subscriptionId")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "subscriptionId", valid_564283
  var valid_564284 = path.getOrDefault("resourceGroupName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "resourceGroupName", valid_564284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564285 = query.getOrDefault("api-version")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564285 != nil:
    section.add "api-version", valid_564285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564286: Call_ActionRulesGetByName_564279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific action rule
  ## 
  let valid = call_564286.validator(path, query, header, formData, body)
  let scheme = call_564286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564286.url(scheme.get, call_564286.host, call_564286.base,
                         call_564286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564286, url, valid)

proc call*(call_564287: Call_ActionRulesGetByName_564279; actionRuleName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2019-05-05-preview"): Recallable =
  ## actionRulesGetByName
  ## Get a specific action rule
  ##   apiVersion: string (required)
  ##             : client API version
  ##   actionRuleName: string (required)
  ##                 : The name of action rule that needs to be fetched
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name where the resource is created.
  var path_564288 = newJObject()
  var query_564289 = newJObject()
  add(query_564289, "api-version", newJString(apiVersion))
  add(path_564288, "actionRuleName", newJString(actionRuleName))
  add(path_564288, "subscriptionId", newJString(subscriptionId))
  add(path_564288, "resourceGroupName", newJString(resourceGroupName))
  result = call_564287.call(path_564288, query_564289, nil, nil, nil)

var actionRulesGetByName* = Call_ActionRulesGetByName_564279(
    name: "actionRulesGetByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesGetByName_564280, base: "",
    url: url_ActionRulesGetByName_564281, schemes: {Scheme.Https})
type
  Call_ActionRulesUpdate_564331 = ref object of OpenApiRestCall_563556
proc url_ActionRulesUpdate_564333(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "actionRuleName" in path, "`actionRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/actionRules/"),
               (kind: VariableSegment, value: "actionRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActionRulesUpdate_564332(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Update enabled flag and/or tags for the given action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   actionRuleName: JString (required)
  ##                 : The name that needs to be updated
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name where the resource is created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `actionRuleName` field"
  var valid_564334 = path.getOrDefault("actionRuleName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "actionRuleName", valid_564334
  var valid_564335 = path.getOrDefault("subscriptionId")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "subscriptionId", valid_564335
  var valid_564336 = path.getOrDefault("resourceGroupName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "resourceGroupName", valid_564336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564337 = query.getOrDefault("api-version")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564337 != nil:
    section.add "api-version", valid_564337
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

proc call*(call_564339: Call_ActionRulesUpdate_564331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update enabled flag and/or tags for the given action rule
  ## 
  let valid = call_564339.validator(path, query, header, formData, body)
  let scheme = call_564339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564339.url(scheme.get, call_564339.host, call_564339.base,
                         call_564339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564339, url, valid)

proc call*(call_564340: Call_ActionRulesUpdate_564331; actionRuleName: string;
          subscriptionId: string; resourceGroupName: string;
          actionRulePatch: JsonNode; apiVersion: string = "2019-05-05-preview"): Recallable =
  ## actionRulesUpdate
  ## Update enabled flag and/or tags for the given action rule
  ##   apiVersion: string (required)
  ##             : client API version
  ##   actionRuleName: string (required)
  ##                 : The name that needs to be updated
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name where the resource is created.
  ##   actionRulePatch: JObject (required)
  ##                  : Parameters supplied to the operation.
  var path_564341 = newJObject()
  var query_564342 = newJObject()
  var body_564343 = newJObject()
  add(query_564342, "api-version", newJString(apiVersion))
  add(path_564341, "actionRuleName", newJString(actionRuleName))
  add(path_564341, "subscriptionId", newJString(subscriptionId))
  add(path_564341, "resourceGroupName", newJString(resourceGroupName))
  if actionRulePatch != nil:
    body_564343 = actionRulePatch
  result = call_564340.call(path_564341, query_564342, nil, nil, body_564343)

var actionRulesUpdate* = Call_ActionRulesUpdate_564331(name: "actionRulesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesUpdate_564332, base: "",
    url: url_ActionRulesUpdate_564333, schemes: {Scheme.Https})
type
  Call_ActionRulesDelete_564320 = ref object of OpenApiRestCall_563556
proc url_ActionRulesDelete_564322(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "actionRuleName" in path, "`actionRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AlertsManagement/actionRules/"),
               (kind: VariableSegment, value: "actionRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActionRulesDelete_564321(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a given action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   actionRuleName: JString (required)
  ##                 : The name that needs to be deleted
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name where the resource is created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `actionRuleName` field"
  var valid_564323 = path.getOrDefault("actionRuleName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "actionRuleName", valid_564323
  var valid_564324 = path.getOrDefault("subscriptionId")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "subscriptionId", valid_564324
  var valid_564325 = path.getOrDefault("resourceGroupName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "resourceGroupName", valid_564325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564326 = query.getOrDefault("api-version")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_564326 != nil:
    section.add "api-version", valid_564326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564327: Call_ActionRulesDelete_564320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a given action rule
  ## 
  let valid = call_564327.validator(path, query, header, formData, body)
  let scheme = call_564327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564327.url(scheme.get, call_564327.host, call_564327.base,
                         call_564327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564327, url, valid)

proc call*(call_564328: Call_ActionRulesDelete_564320; actionRuleName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2019-05-05-preview"): Recallable =
  ## actionRulesDelete
  ## Deletes a given action rule
  ##   apiVersion: string (required)
  ##             : client API version
  ##   actionRuleName: string (required)
  ##                 : The name that needs to be deleted
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name where the resource is created.
  var path_564329 = newJObject()
  var query_564330 = newJObject()
  add(query_564330, "api-version", newJString(apiVersion))
  add(path_564329, "actionRuleName", newJString(actionRuleName))
  add(path_564329, "subscriptionId", newJString(subscriptionId))
  add(path_564329, "resourceGroupName", newJString(resourceGroupName))
  result = call_564328.call(path_564329, query_564330, nil, nil, nil)

var actionRulesDelete* = Call_ActionRulesDelete_564320(name: "actionRulesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesDelete_564321, base: "",
    url: url_ActionRulesDelete_564322, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
