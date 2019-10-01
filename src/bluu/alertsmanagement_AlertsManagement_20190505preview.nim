
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "alertsmanagement-AlertsManagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AlertsMetaData_593647 = ref object of OpenApiRestCall_593425
proc url_AlertsMetaData_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AlertsMetaData_593648(path: JsonNode; query: JsonNode;
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
  var valid_593821 = query.getOrDefault("api-version")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_593821 != nil:
    section.add "api-version", valid_593821
  var valid_593822 = query.getOrDefault("identifier")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = newJString("MonitorServiceList"))
  if valid_593822 != nil:
    section.add "identifier", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_AlertsMetaData_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List alerts meta data information based on value of identifier parameter.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_AlertsMetaData_593647;
          apiVersion: string = "2019-05-05-preview";
          identifier: string = "MonitorServiceList"): Recallable =
  ## alertsMetaData
  ## List alerts meta data information based on value of identifier parameter.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   identifier: string (required)
  ##             : Identification of the information to be retrieved by API call.
  var query_593917 = newJObject()
  add(query_593917, "api-version", newJString(apiVersion))
  add(query_593917, "identifier", newJString(identifier))
  result = call_593916.call(nil, query_593917, nil, nil, nil)

var alertsMetaData* = Call_AlertsMetaData_593647(name: "alertsMetaData",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.AlertsManagement/alertsMetaData",
    validator: validate_AlertsMetaData_593648, base: "", url: url_AlertsMetaData_593649,
    schemes: {Scheme.Https})
type
  Call_OperationsList_593957 = ref object of OpenApiRestCall_593425
proc url_OperationsList_593959(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593958(path: JsonNode; query: JsonNode;
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
  var valid_593960 = query.getOrDefault("api-version")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_593960 != nil:
    section.add "api-version", valid_593960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593961: Call_OperationsList_593957; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all operations available through Azure Alerts Management Resource Provider.
  ## 
  let valid = call_593961.validator(path, query, header, formData, body)
  let scheme = call_593961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593961.url(scheme.get, call_593961.host, call_593961.base,
                         call_593961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593961, url, valid)

proc call*(call_593962: Call_OperationsList_593957;
          apiVersion: string = "2019-05-05-preview"): Recallable =
  ## operationsList
  ## List all operations available through Azure Alerts Management Resource Provider.
  ##   apiVersion: string (required)
  ##             : client API version
  var query_593963 = newJObject()
  add(query_593963, "api-version", newJString(apiVersion))
  result = call_593962.call(nil, query_593963, nil, nil, nil)

var operationsList* = Call_OperationsList_593957(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.AlertsManagement/operations",
    validator: validate_OperationsList_593958, base: "", url: url_OperationsList_593959,
    schemes: {Scheme.Https})
type
  Call_ActionRulesListBySubscription_593964 = ref object of OpenApiRestCall_593425
proc url_ActionRulesListBySubscription_593966(protocol: Scheme; host: string;
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

proc validate_ActionRulesListBySubscription_593965(path: JsonNode; query: JsonNode;
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
  var valid_593981 = path.getOrDefault("subscriptionId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "subscriptionId", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   impactedScope: JString
  ##                : filter by impacted/target scope (provide comma separated list for multiple scopes). The value should be an well constructed ARM id of the scope.
  ##   targetResource: JString
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   alertRuleId: JString
  ##              : filter by alert rule id
  ##   actionGroup: JString
  ##              : filter by action group configured as part of action rule
  ##   targetResourceGroup: JString
  ##                      : Filter by target resource group name. Default value is select all.
  ##   severity: JString
  ##           : Filter by severity.  Default value is select all.
  ##   name: JString
  ##       : filter by action rule name
  ##   targetResourceType: JString
  ##                     : Filter by target resource type. Default value is select all.
  ##   monitorService: JString
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   description: JString
  ##              : filter by alert rule description
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  var valid_593983 = query.getOrDefault("impactedScope")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "impactedScope", valid_593983
  var valid_593984 = query.getOrDefault("targetResource")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "targetResource", valid_593984
  var valid_593985 = query.getOrDefault("alertRuleId")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "alertRuleId", valid_593985
  var valid_593986 = query.getOrDefault("actionGroup")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "actionGroup", valid_593986
  var valid_593987 = query.getOrDefault("targetResourceGroup")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "targetResourceGroup", valid_593987
  var valid_593988 = query.getOrDefault("severity")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_593988 != nil:
    section.add "severity", valid_593988
  var valid_593989 = query.getOrDefault("name")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "name", valid_593989
  var valid_593990 = query.getOrDefault("targetResourceType")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "targetResourceType", valid_593990
  var valid_593991 = query.getOrDefault("monitorService")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_593991 != nil:
    section.add "monitorService", valid_593991
  var valid_593992 = query.getOrDefault("description")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "description", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_ActionRulesListBySubscription_593964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all action rules of the subscription and given input filters
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_ActionRulesListBySubscription_593964;
          subscriptionId: string; apiVersion: string = "2019-05-05-preview";
          impactedScope: string = ""; targetResource: string = "";
          alertRuleId: string = ""; actionGroup: string = "";
          targetResourceGroup: string = ""; severity: string = "Sev0";
          name: string = ""; targetResourceType: string = "";
          monitorService: string = "Application Insights"; description: string = ""): Recallable =
  ## actionRulesListBySubscription
  ## List all action rules of the subscription and given input filters
  ##   apiVersion: string (required)
  ##             : client API version
  ##   impactedScope: string
  ##                : filter by impacted/target scope (provide comma separated list for multiple scopes). The value should be an well constructed ARM id of the scope.
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   alertRuleId: string
  ##              : filter by alert rule id
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   actionGroup: string
  ##              : filter by action group configured as part of action rule
  ##   targetResourceGroup: string
  ##                      : Filter by target resource group name. Default value is select all.
  ##   severity: string
  ##           : Filter by severity.  Default value is select all.
  ##   name: string
  ##       : filter by action rule name
  ##   targetResourceType: string
  ##                     : Filter by target resource type. Default value is select all.
  ##   monitorService: string
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   description: string
  ##              : filter by alert rule description
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "api-version", newJString(apiVersion))
  add(query_593996, "impactedScope", newJString(impactedScope))
  add(query_593996, "targetResource", newJString(targetResource))
  add(query_593996, "alertRuleId", newJString(alertRuleId))
  add(path_593995, "subscriptionId", newJString(subscriptionId))
  add(query_593996, "actionGroup", newJString(actionGroup))
  add(query_593996, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_593996, "severity", newJString(severity))
  add(query_593996, "name", newJString(name))
  add(query_593996, "targetResourceType", newJString(targetResourceType))
  add(query_593996, "monitorService", newJString(monitorService))
  add(query_593996, "description", newJString(description))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var actionRulesListBySubscription* = Call_ActionRulesListBySubscription_593964(
    name: "actionRulesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/actionRules",
    validator: validate_ActionRulesListBySubscription_593965, base: "",
    url: url_ActionRulesListBySubscription_593966, schemes: {Scheme.Https})
type
  Call_AlertsGetAll_593997 = ref object of OpenApiRestCall_593425
proc url_AlertsGetAll_593999(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetAll_593998(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594000 = path.getOrDefault("subscriptionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "subscriptionId", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   timeRange: JString
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   api-version: JString (required)
  ##              : client API version
  ##   includeContext: JBool
  ##                 : Include context which has contextual data specific to the monitor service. Default value is false'
  ##   targetResource: JString
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   select: JString
  ##         : This filter allows to selection of the fields(comma separated) which would  be part of the essential section. This would allow to project only the  required fields rather than getting entire content.  Default is to fetch all the fields in the essentials section.
  ##   customTimeRange: JString
  ##                  : Filter by custom time range in the format <start-time>/<end-time>  where time is in (ISO-8601 format)'. Permissible values is within 30 days from  query time. Either timeRange or customTimeRange could be used but not both. Default is none.
  ##   targetResourceGroup: JString
  ##                      : Filter by target resource group name. Default value is select all.
  ##   sortBy: JString
  ##         : Sort the query results by input field,  Default value is 'lastModifiedDateTime'.
  ##   severity: JString
  ##           : Filter by severity.  Default value is select all.
  ##   monitorCondition: JString
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   targetResourceType: JString
  ##                     : Filter by target resource type. Default value is select all.
  ##   monitorService: JString
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   alertRule: JString
  ##            : Filter by specific alert rule.  Default value is to select all.
  ##   smartGroupId: JString
  ##               : Filter the alerts list by the Smart Group Id. Default value is none.
  ##   sortOrder: JString
  ##            : Sort the query results order in either ascending or descending.  Default value is 'desc' for time fields and 'asc' for others.
  ##   pageCount: JInt
  ##            : Determines number of alerts returned per page in response. Permissible value is between 1 to 250. When the "includeContent"  filter is selected, maximum value allowed is 25. Default value is 25.
  ##   alertState: JString
  ##             : Filter by state of the alert instance. Default value is to select all.
  ##   includeEgressConfig: JBool
  ##                      : Include egress config which would be used for displaying the content in portal.  Default value is 'false'.
  section = newJObject()
  var valid_594001 = query.getOrDefault("timeRange")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = newJString("1h"))
  if valid_594001 != nil:
    section.add "timeRange", valid_594001
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  var valid_594003 = query.getOrDefault("includeContext")
  valid_594003 = validateParameter(valid_594003, JBool, required = false, default = nil)
  if valid_594003 != nil:
    section.add "includeContext", valid_594003
  var valid_594004 = query.getOrDefault("targetResource")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "targetResource", valid_594004
  var valid_594005 = query.getOrDefault("select")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "select", valid_594005
  var valid_594006 = query.getOrDefault("customTimeRange")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "customTimeRange", valid_594006
  var valid_594007 = query.getOrDefault("targetResourceGroup")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "targetResourceGroup", valid_594007
  var valid_594008 = query.getOrDefault("sortBy")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = newJString("name"))
  if valid_594008 != nil:
    section.add "sortBy", valid_594008
  var valid_594009 = query.getOrDefault("severity")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_594009 != nil:
    section.add "severity", valid_594009
  var valid_594010 = query.getOrDefault("monitorCondition")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = newJString("Fired"))
  if valid_594010 != nil:
    section.add "monitorCondition", valid_594010
  var valid_594011 = query.getOrDefault("targetResourceType")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "targetResourceType", valid_594011
  var valid_594012 = query.getOrDefault("monitorService")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_594012 != nil:
    section.add "monitorService", valid_594012
  var valid_594013 = query.getOrDefault("alertRule")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "alertRule", valid_594013
  var valid_594014 = query.getOrDefault("smartGroupId")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "smartGroupId", valid_594014
  var valid_594015 = query.getOrDefault("sortOrder")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = newJString("asc"))
  if valid_594015 != nil:
    section.add "sortOrder", valid_594015
  var valid_594016 = query.getOrDefault("pageCount")
  valid_594016 = validateParameter(valid_594016, JInt, required = false, default = nil)
  if valid_594016 != nil:
    section.add "pageCount", valid_594016
  var valid_594017 = query.getOrDefault("alertState")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = newJString("New"))
  if valid_594017 != nil:
    section.add "alertState", valid_594017
  var valid_594018 = query.getOrDefault("includeEgressConfig")
  valid_594018 = validateParameter(valid_594018, JBool, required = false, default = nil)
  if valid_594018 != nil:
    section.add "includeEgressConfig", valid_594018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594019: Call_AlertsGetAll_593997; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all existing alerts, where the results can be filtered on the basis of multiple parameters (e.g. time range). The results can then be sorted on the basis specific fields, with the default being lastModifiedDateTime. 
  ## 
  let valid = call_594019.validator(path, query, header, formData, body)
  let scheme = call_594019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594019.url(scheme.get, call_594019.host, call_594019.base,
                         call_594019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594019, url, valid)

proc call*(call_594020: Call_AlertsGetAll_593997; subscriptionId: string;
          timeRange: string = "1h"; apiVersion: string = "2019-05-05-preview";
          includeContext: bool = false; targetResource: string = "";
          select: string = ""; customTimeRange: string = "";
          targetResourceGroup: string = ""; sortBy: string = "name";
          severity: string = "Sev0"; monitorCondition: string = "Fired";
          targetResourceType: string = "";
          monitorService: string = "Application Insights"; alertRule: string = "";
          smartGroupId: string = ""; sortOrder: string = "asc"; pageCount: int = 0;
          alertState: string = "New"; includeEgressConfig: bool = false): Recallable =
  ## alertsGetAll
  ## List all existing alerts, where the results can be filtered on the basis of multiple parameters (e.g. time range). The results can then be sorted on the basis specific fields, with the default being lastModifiedDateTime. 
  ##   timeRange: string
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   includeContext: bool
  ##                 : Include context which has contextual data specific to the monitor service. Default value is false'
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   select: string
  ##         : This filter allows to selection of the fields(comma separated) which would  be part of the essential section. This would allow to project only the  required fields rather than getting entire content.  Default is to fetch all the fields in the essentials section.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   customTimeRange: string
  ##                  : Filter by custom time range in the format <start-time>/<end-time>  where time is in (ISO-8601 format)'. Permissible values is within 30 days from  query time. Either timeRange or customTimeRange could be used but not both. Default is none.
  ##   targetResourceGroup: string
  ##                      : Filter by target resource group name. Default value is select all.
  ##   sortBy: string
  ##         : Sort the query results by input field,  Default value is 'lastModifiedDateTime'.
  ##   severity: string
  ##           : Filter by severity.  Default value is select all.
  ##   monitorCondition: string
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   targetResourceType: string
  ##                     : Filter by target resource type. Default value is select all.
  ##   monitorService: string
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   alertRule: string
  ##            : Filter by specific alert rule.  Default value is to select all.
  ##   smartGroupId: string
  ##               : Filter the alerts list by the Smart Group Id. Default value is none.
  ##   sortOrder: string
  ##            : Sort the query results order in either ascending or descending.  Default value is 'desc' for time fields and 'asc' for others.
  ##   pageCount: int
  ##            : Determines number of alerts returned per page in response. Permissible value is between 1 to 250. When the "includeContent"  filter is selected, maximum value allowed is 25. Default value is 25.
  ##   alertState: string
  ##             : Filter by state of the alert instance. Default value is to select all.
  ##   includeEgressConfig: bool
  ##                      : Include egress config which would be used for displaying the content in portal.  Default value is 'false'.
  var path_594021 = newJObject()
  var query_594022 = newJObject()
  add(query_594022, "timeRange", newJString(timeRange))
  add(query_594022, "api-version", newJString(apiVersion))
  add(query_594022, "includeContext", newJBool(includeContext))
  add(query_594022, "targetResource", newJString(targetResource))
  add(query_594022, "select", newJString(select))
  add(path_594021, "subscriptionId", newJString(subscriptionId))
  add(query_594022, "customTimeRange", newJString(customTimeRange))
  add(query_594022, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_594022, "sortBy", newJString(sortBy))
  add(query_594022, "severity", newJString(severity))
  add(query_594022, "monitorCondition", newJString(monitorCondition))
  add(query_594022, "targetResourceType", newJString(targetResourceType))
  add(query_594022, "monitorService", newJString(monitorService))
  add(query_594022, "alertRule", newJString(alertRule))
  add(query_594022, "smartGroupId", newJString(smartGroupId))
  add(query_594022, "sortOrder", newJString(sortOrder))
  add(query_594022, "pageCount", newJInt(pageCount))
  add(query_594022, "alertState", newJString(alertState))
  add(query_594022, "includeEgressConfig", newJBool(includeEgressConfig))
  result = call_594020.call(path_594021, query_594022, nil, nil, nil)

var alertsGetAll* = Call_AlertsGetAll_593997(name: "alertsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts",
    validator: validate_AlertsGetAll_593998, base: "", url: url_AlertsGetAll_593999,
    schemes: {Scheme.Https})
type
  Call_AlertsGetById_594023 = ref object of OpenApiRestCall_593425
proc url_AlertsGetById_594025(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetById_594024(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information related to a specific alert
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   alertId: JString (required)
  ##          : Unique ID of an alert instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594026 = path.getOrDefault("subscriptionId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "subscriptionId", valid_594026
  var valid_594027 = path.getOrDefault("alertId")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "alertId", valid_594027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_AlertsGetById_594023; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific alert
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_AlertsGetById_594023; subscriptionId: string;
          alertId: string; apiVersion: string = "2019-05-05-preview"): Recallable =
  ## alertsGetById
  ## Get information related to a specific alert
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  add(path_594031, "alertId", newJString(alertId))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var alertsGetById* = Call_AlertsGetById_594023(name: "alertsGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}",
    validator: validate_AlertsGetById_594024, base: "", url: url_AlertsGetById_594025,
    schemes: {Scheme.Https})
type
  Call_AlertsChangeState_594033 = ref object of OpenApiRestCall_593425
proc url_AlertsChangeState_594035(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsChangeState_594034(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Change the state of an alert.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   alertId: JString (required)
  ##          : Unique ID of an alert instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594036 = path.getOrDefault("subscriptionId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "subscriptionId", valid_594036
  var valid_594037 = path.getOrDefault("alertId")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "alertId", valid_594037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   newState: JString (required)
  ##           : New state of the alert.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594038 = query.getOrDefault("api-version")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594038 != nil:
    section.add "api-version", valid_594038
  var valid_594039 = query.getOrDefault("newState")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = newJString("New"))
  if valid_594039 != nil:
    section.add "newState", valid_594039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_AlertsChangeState_594033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of an alert.
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_AlertsChangeState_594033; subscriptionId: string;
          alertId: string; apiVersion: string = "2019-05-05-preview";
          newState: string = "New"): Recallable =
  ## alertsChangeState
  ## Change the state of an alert.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   newState: string (required)
  ##           : New state of the alert.
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  add(query_594043, "api-version", newJString(apiVersion))
  add(path_594042, "subscriptionId", newJString(subscriptionId))
  add(query_594043, "newState", newJString(newState))
  add(path_594042, "alertId", newJString(alertId))
  result = call_594041.call(path_594042, query_594043, nil, nil, nil)

var alertsChangeState* = Call_AlertsChangeState_594033(name: "alertsChangeState",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/changestate",
    validator: validate_AlertsChangeState_594034, base: "",
    url: url_AlertsChangeState_594035, schemes: {Scheme.Https})
type
  Call_AlertsGetHistory_594044 = ref object of OpenApiRestCall_593425
proc url_AlertsGetHistory_594046(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetHistory_594045(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved) and alert state changes (New/Acknowledged/Closed).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   alertId: JString (required)
  ##          : Unique ID of an alert instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594047 = path.getOrDefault("subscriptionId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "subscriptionId", valid_594047
  var valid_594048 = path.getOrDefault("alertId")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "alertId", valid_594048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594049 = query.getOrDefault("api-version")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594049 != nil:
    section.add "api-version", valid_594049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_AlertsGetHistory_594044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved) and alert state changes (New/Acknowledged/Closed).
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_AlertsGetHistory_594044; subscriptionId: string;
          alertId: string; apiVersion: string = "2019-05-05-preview"): Recallable =
  ## alertsGetHistory
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved) and alert state changes (New/Acknowledged/Closed).
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  add(query_594053, "api-version", newJString(apiVersion))
  add(path_594052, "subscriptionId", newJString(subscriptionId))
  add(path_594052, "alertId", newJString(alertId))
  result = call_594051.call(path_594052, query_594053, nil, nil, nil)

var alertsGetHistory* = Call_AlertsGetHistory_594044(name: "alertsGetHistory",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/history",
    validator: validate_AlertsGetHistory_594045, base: "",
    url: url_AlertsGetHistory_594046, schemes: {Scheme.Https})
type
  Call_AlertsGetSummary_594054 = ref object of OpenApiRestCall_593425
proc url_AlertsGetSummary_594056(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetSummary_594055(path: JsonNode; query: JsonNode;
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
  var valid_594057 = path.getOrDefault("subscriptionId")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "subscriptionId", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   timeRange: JString
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   api-version: JString (required)
  ##              : client API version
  ##   targetResource: JString
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   customTimeRange: JString
  ##                  : Filter by custom time range in the format <start-time>/<end-time>  where time is in (ISO-8601 format)'. Permissible values is within 30 days from  query time. Either timeRange or customTimeRange could be used but not both. Default is none.
  ##   targetResourceGroup: JString
  ##                      : Filter by target resource group name. Default value is select all.
  ##   severity: JString
  ##           : Filter by severity.  Default value is select all.
  ##   includeSmartGroupsCount: JBool
  ##                          : Include count of the SmartGroups as part of the summary. Default value is 'false'.
  ##   monitorCondition: JString
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   targetResourceType: JString
  ##                     : Filter by target resource type. Default value is select all.
  ##   groupby: JString (required)
  ##          : This parameter allows the result set to be grouped by input fields (Maximum 2 comma separated fields supported). For example, groupby=severity or groupby=severity,alertstate.
  ##   monitorService: JString
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   alertRule: JString
  ##            : Filter by specific alert rule.  Default value is to select all.
  ##   alertState: JString
  ##             : Filter by state of the alert instance. Default value is to select all.
  section = newJObject()
  var valid_594058 = query.getOrDefault("timeRange")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = newJString("1h"))
  if valid_594058 != nil:
    section.add "timeRange", valid_594058
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594059 = query.getOrDefault("api-version")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594059 != nil:
    section.add "api-version", valid_594059
  var valid_594060 = query.getOrDefault("targetResource")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "targetResource", valid_594060
  var valid_594061 = query.getOrDefault("customTimeRange")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "customTimeRange", valid_594061
  var valid_594062 = query.getOrDefault("targetResourceGroup")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "targetResourceGroup", valid_594062
  var valid_594063 = query.getOrDefault("severity")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_594063 != nil:
    section.add "severity", valid_594063
  var valid_594064 = query.getOrDefault("includeSmartGroupsCount")
  valid_594064 = validateParameter(valid_594064, JBool, required = false, default = nil)
  if valid_594064 != nil:
    section.add "includeSmartGroupsCount", valid_594064
  var valid_594065 = query.getOrDefault("monitorCondition")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = newJString("Fired"))
  if valid_594065 != nil:
    section.add "monitorCondition", valid_594065
  var valid_594066 = query.getOrDefault("targetResourceType")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "targetResourceType", valid_594066
  var valid_594067 = query.getOrDefault("groupby")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = newJString("severity"))
  if valid_594067 != nil:
    section.add "groupby", valid_594067
  var valid_594068 = query.getOrDefault("monitorService")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_594068 != nil:
    section.add "monitorService", valid_594068
  var valid_594069 = query.getOrDefault("alertRule")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "alertRule", valid_594069
  var valid_594070 = query.getOrDefault("alertState")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = newJString("New"))
  if valid_594070 != nil:
    section.add "alertState", valid_594070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_AlertsGetSummary_594054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a summarized count of your alerts grouped by various parameters (e.g. grouping by 'Severity' returns the count of alerts for each severity).
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_AlertsGetSummary_594054; subscriptionId: string;
          timeRange: string = "1h"; apiVersion: string = "2019-05-05-preview";
          targetResource: string = ""; customTimeRange: string = "";
          targetResourceGroup: string = ""; severity: string = "Sev0";
          includeSmartGroupsCount: bool = false; monitorCondition: string = "Fired";
          targetResourceType: string = ""; groupby: string = "severity";
          monitorService: string = "Application Insights"; alertRule: string = "";
          alertState: string = "New"): Recallable =
  ## alertsGetSummary
  ## Get a summarized count of your alerts grouped by various parameters (e.g. grouping by 'Severity' returns the count of alerts for each severity).
  ##   timeRange: string
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   customTimeRange: string
  ##                  : Filter by custom time range in the format <start-time>/<end-time>  where time is in (ISO-8601 format)'. Permissible values is within 30 days from  query time. Either timeRange or customTimeRange could be used but not both. Default is none.
  ##   targetResourceGroup: string
  ##                      : Filter by target resource group name. Default value is select all.
  ##   severity: string
  ##           : Filter by severity.  Default value is select all.
  ##   includeSmartGroupsCount: bool
  ##                          : Include count of the SmartGroups as part of the summary. Default value is 'false'.
  ##   monitorCondition: string
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   targetResourceType: string
  ##                     : Filter by target resource type. Default value is select all.
  ##   groupby: string (required)
  ##          : This parameter allows the result set to be grouped by input fields (Maximum 2 comma separated fields supported). For example, groupby=severity or groupby=severity,alertstate.
  ##   monitorService: string
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   alertRule: string
  ##            : Filter by specific alert rule.  Default value is to select all.
  ##   alertState: string
  ##             : Filter by state of the alert instance. Default value is to select all.
  var path_594073 = newJObject()
  var query_594074 = newJObject()
  add(query_594074, "timeRange", newJString(timeRange))
  add(query_594074, "api-version", newJString(apiVersion))
  add(query_594074, "targetResource", newJString(targetResource))
  add(path_594073, "subscriptionId", newJString(subscriptionId))
  add(query_594074, "customTimeRange", newJString(customTimeRange))
  add(query_594074, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_594074, "severity", newJString(severity))
  add(query_594074, "includeSmartGroupsCount", newJBool(includeSmartGroupsCount))
  add(query_594074, "monitorCondition", newJString(monitorCondition))
  add(query_594074, "targetResourceType", newJString(targetResourceType))
  add(query_594074, "groupby", newJString(groupby))
  add(query_594074, "monitorService", newJString(monitorService))
  add(query_594074, "alertRule", newJString(alertRule))
  add(query_594074, "alertState", newJString(alertState))
  result = call_594072.call(path_594073, query_594074, nil, nil, nil)

var alertsGetSummary* = Call_AlertsGetSummary_594054(name: "alertsGetSummary",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alertsSummary",
    validator: validate_AlertsGetSummary_594055, base: "",
    url: url_AlertsGetSummary_594056, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetAll_594075 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsGetAll_594077(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetAll_594076(path: JsonNode; query: JsonNode;
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
  var valid_594078 = path.getOrDefault("subscriptionId")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "subscriptionId", valid_594078
  result.add "path", section
  ## parameters in `query` object:
  ##   timeRange: JString
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   api-version: JString (required)
  ##              : client API version
  ##   targetResource: JString
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   targetResourceGroup: JString
  ##                      : Filter by target resource group name. Default value is select all.
  ##   sortBy: JString
  ##         : Sort the query results by input field. Default value is sort by 'lastModifiedDateTime'.
  ##   severity: JString
  ##           : Filter by severity.  Default value is select all.
  ##   monitorCondition: JString
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   smartGroupState: JString
  ##                  : Filter by state of the smart group. Default value is to select all.
  ##   targetResourceType: JString
  ##                     : Filter by target resource type. Default value is select all.
  ##   monitorService: JString
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   sortOrder: JString
  ##            : Sort the query results order in either ascending or descending.  Default value is 'desc' for time fields and 'asc' for others.
  ##   pageCount: JInt
  ##            : Determines number of alerts returned per page in response. Permissible value is between 1 to 250. When the "includeContent"  filter is selected, maximum value allowed is 25. Default value is 25.
  section = newJObject()
  var valid_594079 = query.getOrDefault("timeRange")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = newJString("1h"))
  if valid_594079 != nil:
    section.add "timeRange", valid_594079
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594080 = query.getOrDefault("api-version")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594080 != nil:
    section.add "api-version", valid_594080
  var valid_594081 = query.getOrDefault("targetResource")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "targetResource", valid_594081
  var valid_594082 = query.getOrDefault("targetResourceGroup")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "targetResourceGroup", valid_594082
  var valid_594083 = query.getOrDefault("sortBy")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = newJString("alertsCount"))
  if valid_594083 != nil:
    section.add "sortBy", valid_594083
  var valid_594084 = query.getOrDefault("severity")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_594084 != nil:
    section.add "severity", valid_594084
  var valid_594085 = query.getOrDefault("monitorCondition")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = newJString("Fired"))
  if valid_594085 != nil:
    section.add "monitorCondition", valid_594085
  var valid_594086 = query.getOrDefault("smartGroupState")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = newJString("New"))
  if valid_594086 != nil:
    section.add "smartGroupState", valid_594086
  var valid_594087 = query.getOrDefault("targetResourceType")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "targetResourceType", valid_594087
  var valid_594088 = query.getOrDefault("monitorService")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_594088 != nil:
    section.add "monitorService", valid_594088
  var valid_594089 = query.getOrDefault("sortOrder")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = newJString("asc"))
  if valid_594089 != nil:
    section.add "sortOrder", valid_594089
  var valid_594090 = query.getOrDefault("pageCount")
  valid_594090 = validateParameter(valid_594090, JInt, required = false, default = nil)
  if valid_594090 != nil:
    section.add "pageCount", valid_594090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594091: Call_SmartGroupsGetAll_594075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the Smart Groups within a specified subscription. 
  ## 
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_SmartGroupsGetAll_594075; subscriptionId: string;
          timeRange: string = "1h"; apiVersion: string = "2019-05-05-preview";
          targetResource: string = ""; targetResourceGroup: string = "";
          sortBy: string = "alertsCount"; severity: string = "Sev0";
          monitorCondition: string = "Fired"; smartGroupState: string = "New";
          targetResourceType: string = "";
          monitorService: string = "Application Insights";
          sortOrder: string = "asc"; pageCount: int = 0): Recallable =
  ## smartGroupsGetAll
  ## List all the Smart Groups within a specified subscription. 
  ##   timeRange: string
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   targetResourceGroup: string
  ##                      : Filter by target resource group name. Default value is select all.
  ##   sortBy: string
  ##         : Sort the query results by input field. Default value is sort by 'lastModifiedDateTime'.
  ##   severity: string
  ##           : Filter by severity.  Default value is select all.
  ##   monitorCondition: string
  ##                   : Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
  ##   smartGroupState: string
  ##                  : Filter by state of the smart group. Default value is to select all.
  ##   targetResourceType: string
  ##                     : Filter by target resource type. Default value is select all.
  ##   monitorService: string
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   sortOrder: string
  ##            : Sort the query results order in either ascending or descending.  Default value is 'desc' for time fields and 'asc' for others.
  ##   pageCount: int
  ##            : Determines number of alerts returned per page in response. Permissible value is between 1 to 250. When the "includeContent"  filter is selected, maximum value allowed is 25. Default value is 25.
  var path_594093 = newJObject()
  var query_594094 = newJObject()
  add(query_594094, "timeRange", newJString(timeRange))
  add(query_594094, "api-version", newJString(apiVersion))
  add(query_594094, "targetResource", newJString(targetResource))
  add(path_594093, "subscriptionId", newJString(subscriptionId))
  add(query_594094, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_594094, "sortBy", newJString(sortBy))
  add(query_594094, "severity", newJString(severity))
  add(query_594094, "monitorCondition", newJString(monitorCondition))
  add(query_594094, "smartGroupState", newJString(smartGroupState))
  add(query_594094, "targetResourceType", newJString(targetResourceType))
  add(query_594094, "monitorService", newJString(monitorService))
  add(query_594094, "sortOrder", newJString(sortOrder))
  add(query_594094, "pageCount", newJInt(pageCount))
  result = call_594092.call(path_594093, query_594094, nil, nil, nil)

var smartGroupsGetAll* = Call_SmartGroupsGetAll_594075(name: "smartGroupsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups",
    validator: validate_SmartGroupsGetAll_594076, base: "",
    url: url_SmartGroupsGetAll_594077, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetById_594095 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsGetById_594097(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetById_594096(path: JsonNode; query: JsonNode;
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
  var valid_594098 = path.getOrDefault("subscriptionId")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "subscriptionId", valid_594098
  var valid_594099 = path.getOrDefault("smartGroupId")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "smartGroupId", valid_594099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594100 != nil:
    section.add "api-version", valid_594100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_SmartGroupsGetById_594095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific Smart Group.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_SmartGroupsGetById_594095; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2019-05-05-preview"): Recallable =
  ## smartGroupsGetById
  ## Get information related to a specific Smart Group.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   smartGroupId: string (required)
  ##               : Smart group unique id. 
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  add(query_594104, "api-version", newJString(apiVersion))
  add(path_594103, "subscriptionId", newJString(subscriptionId))
  add(path_594103, "smartGroupId", newJString(smartGroupId))
  result = call_594102.call(path_594103, query_594104, nil, nil, nil)

var smartGroupsGetById* = Call_SmartGroupsGetById_594095(
    name: "smartGroupsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}",
    validator: validate_SmartGroupsGetById_594096, base: "",
    url: url_SmartGroupsGetById_594097, schemes: {Scheme.Https})
type
  Call_SmartGroupsChangeState_594105 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsChangeState_594107(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsChangeState_594106(path: JsonNode; query: JsonNode;
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
  var valid_594108 = path.getOrDefault("subscriptionId")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "subscriptionId", valid_594108
  var valid_594109 = path.getOrDefault("smartGroupId")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "smartGroupId", valid_594109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   newState: JString (required)
  ##           : New state of the alert.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594110 = query.getOrDefault("api-version")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594110 != nil:
    section.add "api-version", valid_594110
  var valid_594111 = query.getOrDefault("newState")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = newJString("New"))
  if valid_594111 != nil:
    section.add "newState", valid_594111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594112: Call_SmartGroupsChangeState_594105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of a Smart Group.
  ## 
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_SmartGroupsChangeState_594105; subscriptionId: string;
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
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  add(query_594115, "api-version", newJString(apiVersion))
  add(path_594114, "subscriptionId", newJString(subscriptionId))
  add(path_594114, "smartGroupId", newJString(smartGroupId))
  add(query_594115, "newState", newJString(newState))
  result = call_594113.call(path_594114, query_594115, nil, nil, nil)

var smartGroupsChangeState* = Call_SmartGroupsChangeState_594105(
    name: "smartGroupsChangeState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/changeState",
    validator: validate_SmartGroupsChangeState_594106, base: "",
    url: url_SmartGroupsChangeState_594107, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetHistory_594116 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsGetHistory_594118(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetHistory_594117(path: JsonNode; query: JsonNode;
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
  var valid_594119 = path.getOrDefault("subscriptionId")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "subscriptionId", valid_594119
  var valid_594120 = path.getOrDefault("smartGroupId")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "smartGroupId", valid_594120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594121 = query.getOrDefault("api-version")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594121 != nil:
    section.add "api-version", valid_594121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594122: Call_SmartGroupsGetHistory_594116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history a smart group, which captures any Smart Group state changes (New/Acknowledged/Closed) .
  ## 
  let valid = call_594122.validator(path, query, header, formData, body)
  let scheme = call_594122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594122.url(scheme.get, call_594122.host, call_594122.base,
                         call_594122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594122, url, valid)

proc call*(call_594123: Call_SmartGroupsGetHistory_594116; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2019-05-05-preview"): Recallable =
  ## smartGroupsGetHistory
  ## Get the history a smart group, which captures any Smart Group state changes (New/Acknowledged/Closed) .
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   smartGroupId: string (required)
  ##               : Smart group unique id. 
  var path_594124 = newJObject()
  var query_594125 = newJObject()
  add(query_594125, "api-version", newJString(apiVersion))
  add(path_594124, "subscriptionId", newJString(subscriptionId))
  add(path_594124, "smartGroupId", newJString(smartGroupId))
  result = call_594123.call(path_594124, query_594125, nil, nil, nil)

var smartGroupsGetHistory* = Call_SmartGroupsGetHistory_594116(
    name: "smartGroupsGetHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/history",
    validator: validate_SmartGroupsGetHistory_594117, base: "",
    url: url_SmartGroupsGetHistory_594118, schemes: {Scheme.Https})
type
  Call_ActionRulesListByResourceGroup_594126 = ref object of OpenApiRestCall_593425
proc url_ActionRulesListByResourceGroup_594128(protocol: Scheme; host: string;
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

proc validate_ActionRulesListByResourceGroup_594127(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all action rules of the subscription, created in given resource group and given input filters
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name where the resource is created.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594129 = path.getOrDefault("resourceGroupName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "resourceGroupName", valid_594129
  var valid_594130 = path.getOrDefault("subscriptionId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "subscriptionId", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   impactedScope: JString
  ##                : filter by impacted/target scope (provide comma separated list for multiple scopes). The value should be an well constructed ARM id of the scope.
  ##   targetResource: JString
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   alertRuleId: JString
  ##              : filter by alert rule id
  ##   actionGroup: JString
  ##              : filter by action group configured as part of action rule
  ##   targetResourceGroup: JString
  ##                      : Filter by target resource group name. Default value is select all.
  ##   severity: JString
  ##           : Filter by severity.  Default value is select all.
  ##   name: JString
  ##       : filter by action rule name
  ##   targetResourceType: JString
  ##                     : Filter by target resource type. Default value is select all.
  ##   monitorService: JString
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   description: JString
  ##              : filter by alert rule description
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594131 = query.getOrDefault("api-version")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594131 != nil:
    section.add "api-version", valid_594131
  var valid_594132 = query.getOrDefault("impactedScope")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "impactedScope", valid_594132
  var valid_594133 = query.getOrDefault("targetResource")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "targetResource", valid_594133
  var valid_594134 = query.getOrDefault("alertRuleId")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "alertRuleId", valid_594134
  var valid_594135 = query.getOrDefault("actionGroup")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "actionGroup", valid_594135
  var valid_594136 = query.getOrDefault("targetResourceGroup")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "targetResourceGroup", valid_594136
  var valid_594137 = query.getOrDefault("severity")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_594137 != nil:
    section.add "severity", valid_594137
  var valid_594138 = query.getOrDefault("name")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "name", valid_594138
  var valid_594139 = query.getOrDefault("targetResourceType")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "targetResourceType", valid_594139
  var valid_594140 = query.getOrDefault("monitorService")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_594140 != nil:
    section.add "monitorService", valid_594140
  var valid_594141 = query.getOrDefault("description")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "description", valid_594141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594142: Call_ActionRulesListByResourceGroup_594126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all action rules of the subscription, created in given resource group and given input filters
  ## 
  let valid = call_594142.validator(path, query, header, formData, body)
  let scheme = call_594142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594142.url(scheme.get, call_594142.host, call_594142.base,
                         call_594142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594142, url, valid)

proc call*(call_594143: Call_ActionRulesListByResourceGroup_594126;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2019-05-05-preview"; impactedScope: string = "";
          targetResource: string = ""; alertRuleId: string = "";
          actionGroup: string = ""; targetResourceGroup: string = "";
          severity: string = "Sev0"; name: string = ""; targetResourceType: string = "";
          monitorService: string = "Application Insights"; description: string = ""): Recallable =
  ## actionRulesListByResourceGroup
  ## List all action rules of the subscription, created in given resource group and given input filters
  ##   resourceGroupName: string (required)
  ##                    : Resource group name where the resource is created.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   impactedScope: string
  ##                : filter by impacted/target scope (provide comma separated list for multiple scopes). The value should be an well constructed ARM id of the scope.
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   alertRuleId: string
  ##              : filter by alert rule id
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   actionGroup: string
  ##              : filter by action group configured as part of action rule
  ##   targetResourceGroup: string
  ##                      : Filter by target resource group name. Default value is select all.
  ##   severity: string
  ##           : Filter by severity.  Default value is select all.
  ##   name: string
  ##       : filter by action rule name
  ##   targetResourceType: string
  ##                     : Filter by target resource type. Default value is select all.
  ##   monitorService: string
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   description: string
  ##              : filter by alert rule description
  var path_594144 = newJObject()
  var query_594145 = newJObject()
  add(path_594144, "resourceGroupName", newJString(resourceGroupName))
  add(query_594145, "api-version", newJString(apiVersion))
  add(query_594145, "impactedScope", newJString(impactedScope))
  add(query_594145, "targetResource", newJString(targetResource))
  add(query_594145, "alertRuleId", newJString(alertRuleId))
  add(path_594144, "subscriptionId", newJString(subscriptionId))
  add(query_594145, "actionGroup", newJString(actionGroup))
  add(query_594145, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_594145, "severity", newJString(severity))
  add(query_594145, "name", newJString(name))
  add(query_594145, "targetResourceType", newJString(targetResourceType))
  add(query_594145, "monitorService", newJString(monitorService))
  add(query_594145, "description", newJString(description))
  result = call_594143.call(path_594144, query_594145, nil, nil, nil)

var actionRulesListByResourceGroup* = Call_ActionRulesListByResourceGroup_594126(
    name: "actionRulesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AlertsManagement/actionRules",
    validator: validate_ActionRulesListByResourceGroup_594127, base: "",
    url: url_ActionRulesListByResourceGroup_594128, schemes: {Scheme.Https})
type
  Call_ActionRulesCreateUpdate_594157 = ref object of OpenApiRestCall_593425
proc url_ActionRulesCreateUpdate_594159(protocol: Scheme; host: string; base: string;
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

proc validate_ActionRulesCreateUpdate_594158(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates/Updates a specific action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name where the resource is created.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   actionRuleName: JString (required)
  ##                 : The name of action rule that needs to be created/updated
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594177 = path.getOrDefault("resourceGroupName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "resourceGroupName", valid_594177
  var valid_594178 = path.getOrDefault("subscriptionId")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "subscriptionId", valid_594178
  var valid_594179 = path.getOrDefault("actionRuleName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "actionRuleName", valid_594179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594180 = query.getOrDefault("api-version")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594180 != nil:
    section.add "api-version", valid_594180
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

proc call*(call_594182: Call_ActionRulesCreateUpdate_594157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates/Updates a specific action rule
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_ActionRulesCreateUpdate_594157;
          resourceGroupName: string; subscriptionId: string; actionRule: JsonNode;
          actionRuleName: string; apiVersion: string = "2019-05-05-preview"): Recallable =
  ## actionRulesCreateUpdate
  ## Creates/Updates a specific action rule
  ##   resourceGroupName: string (required)
  ##                    : Resource group name where the resource is created.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   actionRule: JObject (required)
  ##             : action rule to be created/updated
  ##   actionRuleName: string (required)
  ##                 : The name of action rule that needs to be created/updated
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  var body_594186 = newJObject()
  add(path_594184, "resourceGroupName", newJString(resourceGroupName))
  add(query_594185, "api-version", newJString(apiVersion))
  add(path_594184, "subscriptionId", newJString(subscriptionId))
  if actionRule != nil:
    body_594186 = actionRule
  add(path_594184, "actionRuleName", newJString(actionRuleName))
  result = call_594183.call(path_594184, query_594185, nil, nil, body_594186)

var actionRulesCreateUpdate* = Call_ActionRulesCreateUpdate_594157(
    name: "actionRulesCreateUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesCreateUpdate_594158, base: "",
    url: url_ActionRulesCreateUpdate_594159, schemes: {Scheme.Https})
type
  Call_ActionRulesGetByName_594146 = ref object of OpenApiRestCall_593425
proc url_ActionRulesGetByName_594148(protocol: Scheme; host: string; base: string;
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

proc validate_ActionRulesGetByName_594147(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name where the resource is created.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   actionRuleName: JString (required)
  ##                 : The name of action rule that needs to be fetched
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594149 = path.getOrDefault("resourceGroupName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "resourceGroupName", valid_594149
  var valid_594150 = path.getOrDefault("subscriptionId")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "subscriptionId", valid_594150
  var valid_594151 = path.getOrDefault("actionRuleName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "actionRuleName", valid_594151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594152 = query.getOrDefault("api-version")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594152 != nil:
    section.add "api-version", valid_594152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594153: Call_ActionRulesGetByName_594146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific action rule
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_ActionRulesGetByName_594146;
          resourceGroupName: string; subscriptionId: string; actionRuleName: string;
          apiVersion: string = "2019-05-05-preview"): Recallable =
  ## actionRulesGetByName
  ## Get a specific action rule
  ##   resourceGroupName: string (required)
  ##                    : Resource group name where the resource is created.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   actionRuleName: string (required)
  ##                 : The name of action rule that needs to be fetched
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  add(path_594155, "resourceGroupName", newJString(resourceGroupName))
  add(query_594156, "api-version", newJString(apiVersion))
  add(path_594155, "subscriptionId", newJString(subscriptionId))
  add(path_594155, "actionRuleName", newJString(actionRuleName))
  result = call_594154.call(path_594155, query_594156, nil, nil, nil)

var actionRulesGetByName* = Call_ActionRulesGetByName_594146(
    name: "actionRulesGetByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesGetByName_594147, base: "",
    url: url_ActionRulesGetByName_594148, schemes: {Scheme.Https})
type
  Call_ActionRulesUpdate_594198 = ref object of OpenApiRestCall_593425
proc url_ActionRulesUpdate_594200(protocol: Scheme; host: string; base: string;
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

proc validate_ActionRulesUpdate_594199(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Update enabled flag and/or tags for the given action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name where the resource is created.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   actionRuleName: JString (required)
  ##                 : The name that needs to be updated
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594201 = path.getOrDefault("resourceGroupName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "resourceGroupName", valid_594201
  var valid_594202 = path.getOrDefault("subscriptionId")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "subscriptionId", valid_594202
  var valid_594203 = path.getOrDefault("actionRuleName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "actionRuleName", valid_594203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594204 = query.getOrDefault("api-version")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594204 != nil:
    section.add "api-version", valid_594204
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

proc call*(call_594206: Call_ActionRulesUpdate_594198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update enabled flag and/or tags for the given action rule
  ## 
  let valid = call_594206.validator(path, query, header, formData, body)
  let scheme = call_594206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594206.url(scheme.get, call_594206.host, call_594206.base,
                         call_594206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594206, url, valid)

proc call*(call_594207: Call_ActionRulesUpdate_594198; resourceGroupName: string;
          subscriptionId: string; actionRulePatch: JsonNode; actionRuleName: string;
          apiVersion: string = "2019-05-05-preview"): Recallable =
  ## actionRulesUpdate
  ## Update enabled flag and/or tags for the given action rule
  ##   resourceGroupName: string (required)
  ##                    : Resource group name where the resource is created.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   actionRulePatch: JObject (required)
  ##                  : Parameters supplied to the operation.
  ##   actionRuleName: string (required)
  ##                 : The name that needs to be updated
  var path_594208 = newJObject()
  var query_594209 = newJObject()
  var body_594210 = newJObject()
  add(path_594208, "resourceGroupName", newJString(resourceGroupName))
  add(query_594209, "api-version", newJString(apiVersion))
  add(path_594208, "subscriptionId", newJString(subscriptionId))
  if actionRulePatch != nil:
    body_594210 = actionRulePatch
  add(path_594208, "actionRuleName", newJString(actionRuleName))
  result = call_594207.call(path_594208, query_594209, nil, nil, body_594210)

var actionRulesUpdate* = Call_ActionRulesUpdate_594198(name: "actionRulesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesUpdate_594199, base: "",
    url: url_ActionRulesUpdate_594200, schemes: {Scheme.Https})
type
  Call_ActionRulesDelete_594187 = ref object of OpenApiRestCall_593425
proc url_ActionRulesDelete_594189(protocol: Scheme; host: string; base: string;
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

proc validate_ActionRulesDelete_594188(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a given action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name where the resource is created.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   actionRuleName: JString (required)
  ##                 : The name that needs to be deleted
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594190 = path.getOrDefault("resourceGroupName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "resourceGroupName", valid_594190
  var valid_594191 = path.getOrDefault("subscriptionId")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "subscriptionId", valid_594191
  var valid_594192 = path.getOrDefault("actionRuleName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "actionRuleName", valid_594192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594193 = query.getOrDefault("api-version")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = newJString("2019-05-05-preview"))
  if valid_594193 != nil:
    section.add "api-version", valid_594193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594194: Call_ActionRulesDelete_594187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a given action rule
  ## 
  let valid = call_594194.validator(path, query, header, formData, body)
  let scheme = call_594194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594194.url(scheme.get, call_594194.host, call_594194.base,
                         call_594194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594194, url, valid)

proc call*(call_594195: Call_ActionRulesDelete_594187; resourceGroupName: string;
          subscriptionId: string; actionRuleName: string;
          apiVersion: string = "2019-05-05-preview"): Recallable =
  ## actionRulesDelete
  ## Deletes a given action rule
  ##   resourceGroupName: string (required)
  ##                    : Resource group name where the resource is created.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   actionRuleName: string (required)
  ##                 : The name that needs to be deleted
  var path_594196 = newJObject()
  var query_594197 = newJObject()
  add(path_594196, "resourceGroupName", newJString(resourceGroupName))
  add(query_594197, "api-version", newJString(apiVersion))
  add(path_594196, "subscriptionId", newJString(subscriptionId))
  add(path_594196, "actionRuleName", newJString(actionRuleName))
  result = call_594195.call(path_594196, query_594197, nil, nil, nil)

var actionRulesDelete* = Call_ActionRulesDelete_594187(name: "actionRulesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesDelete_594188, base: "",
    url: url_ActionRulesDelete_594189, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
