
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  Call_OperationsList_593647 = ref object of OpenApiRestCall_593425
proc url_OperationsList_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593648(path: JsonNode; query: JsonNode;
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
  var valid_593821 = query.getOrDefault("api-version")
  valid_593821 = validateParameter(valid_593821, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_593821 != nil:
    section.add "api-version", valid_593821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593844: Call_OperationsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all operations available through Azure Alerts Management Resource Provider.
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_OperationsList_593647;
          apiVersion: string = "2018-11-02-privatepreview"): Recallable =
  ## operationsList
  ## List all operations available through Azure Alerts Management Resource Provider.
  ##   apiVersion: string (required)
  ##             : client API version
  var query_593916 = newJObject()
  add(query_593916, "api-version", newJString(apiVersion))
  result = call_593915.call(nil, query_593916, nil, nil, nil)

var operationsList* = Call_OperationsList_593647(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.AlertsManagement/operations",
    validator: validate_OperationsList_593648, base: "", url: url_OperationsList_593649,
    schemes: {Scheme.Https})
type
  Call_ActionRulesGetAllSubscription_593956 = ref object of OpenApiRestCall_593425
proc url_ActionRulesGetAllSubscription_593958(protocol: Scheme; host: string;
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

proc validate_ActionRulesGetAllSubscription_593957(path: JsonNode; query: JsonNode;
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
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   targetResource: JString
  ##                 : filter by target resource
  ##   targetResourceGroup: JString
  ##                      : filter by target resource group name
  ##   severity: JString
  ##           : filter by severity
  ##   targetResourceType: JString
  ##                     : filter by target resource type
  ##   monitorService: JString
  ##                 : filter by monitor service which is the source of the alert object.
  section = newJObject()
  var valid_593974 = query.getOrDefault("targetResource")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "targetResource", valid_593974
  var valid_593975 = query.getOrDefault("targetResourceGroup")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "targetResourceGroup", valid_593975
  var valid_593976 = query.getOrDefault("severity")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_593976 != nil:
    section.add "severity", valid_593976
  var valid_593977 = query.getOrDefault("targetResourceType")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "targetResourceType", valid_593977
  var valid_593978 = query.getOrDefault("monitorService")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("Platform"))
  if valid_593978 != nil:
    section.add "monitorService", valid_593978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593979: Call_ActionRulesGetAllSubscription_593956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all action rules of the subscription and given input filters
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_ActionRulesGetAllSubscription_593956;
          subscriptionId: string; targetResource: string = "";
          targetResourceGroup: string = ""; severity: string = "Sev0";
          targetResourceType: string = ""; monitorService: string = "Platform"): Recallable =
  ## actionRulesGetAllSubscription
  ## List all action rules of the subscription and given input filters
  ##   targetResource: string
  ##                 : filter by target resource
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   targetResourceGroup: string
  ##                      : filter by target resource group name
  ##   severity: string
  ##           : filter by severity
  ##   targetResourceType: string
  ##                     : filter by target resource type
  ##   monitorService: string
  ##                 : filter by monitor service which is the source of the alert object.
  var path_593981 = newJObject()
  var query_593982 = newJObject()
  add(query_593982, "targetResource", newJString(targetResource))
  add(path_593981, "subscriptionId", newJString(subscriptionId))
  add(query_593982, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_593982, "severity", newJString(severity))
  add(query_593982, "targetResourceType", newJString(targetResourceType))
  add(query_593982, "monitorService", newJString(monitorService))
  result = call_593980.call(path_593981, query_593982, nil, nil, nil)

var actionRulesGetAllSubscription* = Call_ActionRulesGetAllSubscription_593956(
    name: "actionRulesGetAllSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/actionRules",
    validator: validate_ActionRulesGetAllSubscription_593957, base: "",
    url: url_ActionRulesGetAllSubscription_593958, schemes: {Scheme.Https})
type
  Call_AlertsGetAll_593983 = ref object of OpenApiRestCall_593425
proc url_AlertsGetAll_593985(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetAll_593984(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593986 = path.getOrDefault("subscriptionId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "subscriptionId", valid_593986
  result.add "path", section
  ## parameters in `query` object:
  ##   timeRange: JString
  ##            : filter by time range, default value is 1 day
  ##   api-version: JString (required)
  ##              : client API version
  ##   targetResource: JString
  ##                 : filter by target resource
  ##   includePayload: JBool
  ##                 : include payload field content, default value is 'false'.
  ##   targetResourceGroup: JString
  ##                      : filter by target resource group name
  ##   sortBy: JString
  ##         : sort the query results by input field, default value is 'lastModifiedDateTime'.
  ##   severity: JString
  ##           : filter by severity
  ##   monitorCondition: JString
  ##                   : filter by monitor condition which is the state of the alert at monitor service
  ##   targetResourceType: JString
  ##                     : filter by target resource type
  ##   monitorService: JString
  ##                 : filter by monitor service which is the source of the alert object.
  ##   smartGroupId: JString
  ##               : filter by smart Group Id
  ##   sortOrder: JString
  ##            : sort the query results order in either ascending or descending, default value is 'desc' for time fields and 'asc' for others.
  ##   pageCount: JInt
  ##            : number of items per page, default value is '25'.
  ##   alertState: JString
  ##             : filter by state
  section = newJObject()
  var valid_593987 = query.getOrDefault("timeRange")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = newJString("1h"))
  if valid_593987 != nil:
    section.add "timeRange", valid_593987
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_593988 != nil:
    section.add "api-version", valid_593988
  var valid_593989 = query.getOrDefault("targetResource")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "targetResource", valid_593989
  var valid_593990 = query.getOrDefault("includePayload")
  valid_593990 = validateParameter(valid_593990, JBool, required = false, default = nil)
  if valid_593990 != nil:
    section.add "includePayload", valid_593990
  var valid_593991 = query.getOrDefault("targetResourceGroup")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "targetResourceGroup", valid_593991
  var valid_593992 = query.getOrDefault("sortBy")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = newJString("name"))
  if valid_593992 != nil:
    section.add "sortBy", valid_593992
  var valid_593993 = query.getOrDefault("severity")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_593993 != nil:
    section.add "severity", valid_593993
  var valid_593994 = query.getOrDefault("monitorCondition")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = newJString("Fired"))
  if valid_593994 != nil:
    section.add "monitorCondition", valid_593994
  var valid_593995 = query.getOrDefault("targetResourceType")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "targetResourceType", valid_593995
  var valid_593996 = query.getOrDefault("monitorService")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = newJString("Platform"))
  if valid_593996 != nil:
    section.add "monitorService", valid_593996
  var valid_593997 = query.getOrDefault("smartGroupId")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "smartGroupId", valid_593997
  var valid_593998 = query.getOrDefault("sortOrder")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = newJString("asc"))
  if valid_593998 != nil:
    section.add "sortOrder", valid_593998
  var valid_593999 = query.getOrDefault("pageCount")
  valid_593999 = validateParameter(valid_593999, JInt, required = false, default = nil)
  if valid_593999 != nil:
    section.add "pageCount", valid_593999
  var valid_594000 = query.getOrDefault("alertState")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = newJString("New"))
  if valid_594000 != nil:
    section.add "alertState", valid_594000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594001: Call_AlertsGetAll_593983; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the existing alerts, where the results can be selective by passing multiple filter parameters including time range and sorted on specific fields. 
  ## 
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_AlertsGetAll_593983; subscriptionId: string;
          timeRange: string = "1h";
          apiVersion: string = "2018-11-02-privatepreview";
          targetResource: string = ""; includePayload: bool = false;
          targetResourceGroup: string = ""; sortBy: string = "name";
          severity: string = "Sev0"; monitorCondition: string = "Fired";
          targetResourceType: string = ""; monitorService: string = "Platform";
          smartGroupId: string = ""; sortOrder: string = "asc"; pageCount: int = 0;
          alertState: string = "New"): Recallable =
  ## alertsGetAll
  ## List all the existing alerts, where the results can be selective by passing multiple filter parameters including time range and sorted on specific fields. 
  ##   timeRange: string
  ##            : filter by time range, default value is 1 day
  ##   apiVersion: string (required)
  ##             : client API version
  ##   targetResource: string
  ##                 : filter by target resource
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   includePayload: bool
  ##                 : include payload field content, default value is 'false'.
  ##   targetResourceGroup: string
  ##                      : filter by target resource group name
  ##   sortBy: string
  ##         : sort the query results by input field, default value is 'lastModifiedDateTime'.
  ##   severity: string
  ##           : filter by severity
  ##   monitorCondition: string
  ##                   : filter by monitor condition which is the state of the alert at monitor service
  ##   targetResourceType: string
  ##                     : filter by target resource type
  ##   monitorService: string
  ##                 : filter by monitor service which is the source of the alert object.
  ##   smartGroupId: string
  ##               : filter by smart Group Id
  ##   sortOrder: string
  ##            : sort the query results order in either ascending or descending, default value is 'desc' for time fields and 'asc' for others.
  ##   pageCount: int
  ##            : number of items per page, default value is '25'.
  ##   alertState: string
  ##             : filter by state
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  add(query_594004, "timeRange", newJString(timeRange))
  add(query_594004, "api-version", newJString(apiVersion))
  add(query_594004, "targetResource", newJString(targetResource))
  add(path_594003, "subscriptionId", newJString(subscriptionId))
  add(query_594004, "includePayload", newJBool(includePayload))
  add(query_594004, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_594004, "sortBy", newJString(sortBy))
  add(query_594004, "severity", newJString(severity))
  add(query_594004, "monitorCondition", newJString(monitorCondition))
  add(query_594004, "targetResourceType", newJString(targetResourceType))
  add(query_594004, "monitorService", newJString(monitorService))
  add(query_594004, "smartGroupId", newJString(smartGroupId))
  add(query_594004, "sortOrder", newJString(sortOrder))
  add(query_594004, "pageCount", newJInt(pageCount))
  add(query_594004, "alertState", newJString(alertState))
  result = call_594002.call(path_594003, query_594004, nil, nil, nil)

var alertsGetAll* = Call_AlertsGetAll_593983(name: "alertsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts",
    validator: validate_AlertsGetAll_593984, base: "", url: url_AlertsGetAll_593985,
    schemes: {Scheme.Https})
type
  Call_AlertsGetById_594005 = ref object of OpenApiRestCall_593425
proc url_AlertsGetById_594007(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetById_594006(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information related to a specific alert
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alertId: JString (required)
  ##          : Unique ID of an alert object.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594008 = path.getOrDefault("subscriptionId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "subscriptionId", valid_594008
  var valid_594009 = path.getOrDefault("alertId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "alertId", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_594010 != nil:
    section.add "api-version", valid_594010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_AlertsGetById_594005; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific alert
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_AlertsGetById_594005; subscriptionId: string;
          alertId: string; apiVersion: string = "2018-11-02-privatepreview"): Recallable =
  ## alertsGetById
  ## Get information related to a specific alert
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alertId: string (required)
  ##          : Unique ID of an alert object.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  add(path_594013, "alertId", newJString(alertId))
  result = call_594012.call(path_594013, query_594014, nil, nil, nil)

var alertsGetById* = Call_AlertsGetById_594005(name: "alertsGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}",
    validator: validate_AlertsGetById_594006, base: "", url: url_AlertsGetById_594007,
    schemes: {Scheme.Https})
type
  Call_AlertsChangeState_594015 = ref object of OpenApiRestCall_593425
proc url_AlertsChangeState_594017(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsChangeState_594016(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Change the state of the alert.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alertId: JString (required)
  ##          : Unique ID of an alert object.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594018 = path.getOrDefault("subscriptionId")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "subscriptionId", valid_594018
  var valid_594019 = path.getOrDefault("alertId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "alertId", valid_594019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   newState: JString (required)
  ##           : filter by state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594020 = query.getOrDefault("api-version")
  valid_594020 = validateParameter(valid_594020, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_594020 != nil:
    section.add "api-version", valid_594020
  var valid_594021 = query.getOrDefault("newState")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = newJString("New"))
  if valid_594021 != nil:
    section.add "newState", valid_594021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594022: Call_AlertsChangeState_594015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of the alert.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_AlertsChangeState_594015; subscriptionId: string;
          alertId: string; apiVersion: string = "2018-11-02-privatepreview";
          newState: string = "New"): Recallable =
  ## alertsChangeState
  ## Change the state of the alert.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   newState: string (required)
  ##           : filter by state
  ##   alertId: string (required)
  ##          : Unique ID of an alert object.
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  add(query_594025, "api-version", newJString(apiVersion))
  add(path_594024, "subscriptionId", newJString(subscriptionId))
  add(query_594025, "newState", newJString(newState))
  add(path_594024, "alertId", newJString(alertId))
  result = call_594023.call(path_594024, query_594025, nil, nil, nil)

var alertsChangeState* = Call_AlertsChangeState_594015(name: "alertsChangeState",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/changestate",
    validator: validate_AlertsChangeState_594016, base: "",
    url: url_AlertsChangeState_594017, schemes: {Scheme.Https})
type
  Call_AlertsGetHistory_594026 = ref object of OpenApiRestCall_593425
proc url_AlertsGetHistory_594028(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetHistory_594027(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the history of the changes of an alert.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alertId: JString (required)
  ##          : Unique ID of an alert object.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594029 = path.getOrDefault("subscriptionId")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "subscriptionId", valid_594029
  var valid_594030 = path.getOrDefault("alertId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "alertId", valid_594030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594031 = query.getOrDefault("api-version")
  valid_594031 = validateParameter(valid_594031, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_594031 != nil:
    section.add "api-version", valid_594031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_AlertsGetHistory_594026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history of the changes of an alert.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_AlertsGetHistory_594026; subscriptionId: string;
          alertId: string; apiVersion: string = "2018-11-02-privatepreview"): Recallable =
  ## alertsGetHistory
  ## Get the history of the changes of an alert.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alertId: string (required)
  ##          : Unique ID of an alert object.
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  add(query_594035, "api-version", newJString(apiVersion))
  add(path_594034, "subscriptionId", newJString(subscriptionId))
  add(path_594034, "alertId", newJString(alertId))
  result = call_594033.call(path_594034, query_594035, nil, nil, nil)

var alertsGetHistory* = Call_AlertsGetHistory_594026(name: "alertsGetHistory",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/history",
    validator: validate_AlertsGetHistory_594027, base: "",
    url: url_AlertsGetHistory_594028, schemes: {Scheme.Https})
type
  Call_AlertsGetSummary_594036 = ref object of OpenApiRestCall_593425
proc url_AlertsGetSummary_594038(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetSummary_594037(path: JsonNode; query: JsonNode;
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
  var valid_594039 = path.getOrDefault("subscriptionId")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "subscriptionId", valid_594039
  result.add "path", section
  ## parameters in `query` object:
  ##   timeRange: JString
  ##            : filter by time range, default value is 1 day
  ##   api-version: JString (required)
  ##              : client API version
  ##   targetResourceGroup: JString
  ##                      : filter by target resource group name
  section = newJObject()
  var valid_594040 = query.getOrDefault("timeRange")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = newJString("1h"))
  if valid_594040 != nil:
    section.add "timeRange", valid_594040
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594041 = query.getOrDefault("api-version")
  valid_594041 = validateParameter(valid_594041, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_594041 != nil:
    section.add "api-version", valid_594041
  var valid_594042 = query.getOrDefault("targetResourceGroup")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "targetResourceGroup", valid_594042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_AlertsGetSummary_594036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Summary of alerts with the count each severity.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_AlertsGetSummary_594036; subscriptionId: string;
          timeRange: string = "1h";
          apiVersion: string = "2018-11-02-privatepreview";
          targetResourceGroup: string = ""): Recallable =
  ## alertsGetSummary
  ## Summary of alerts with the count each severity.
  ##   timeRange: string
  ##            : filter by time range, default value is 1 day
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   targetResourceGroup: string
  ##                      : filter by target resource group name
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  add(query_594046, "timeRange", newJString(timeRange))
  add(query_594046, "api-version", newJString(apiVersion))
  add(path_594045, "subscriptionId", newJString(subscriptionId))
  add(query_594046, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_594044.call(path_594045, query_594046, nil, nil, nil)

var alertsGetSummary* = Call_AlertsGetSummary_594036(name: "alertsGetSummary",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alertsSummary",
    validator: validate_AlertsGetSummary_594037, base: "",
    url: url_AlertsGetSummary_594038, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetAll_594047 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsGetAll_594049(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetAll_594048(path: JsonNode; query: JsonNode;
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
  var valid_594050 = path.getOrDefault("subscriptionId")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "subscriptionId", valid_594050
  result.add "path", section
  ## parameters in `query` object:
  ##   timeRange: JString
  ##            : filter by time range, default value is 1 day
  ##   api-version: JString (required)
  ##              : client API version
  ##   targetResource: JString
  ##                 : filter by target resource
  ##   targetResourceGroup: JString
  ##                      : filter by target resource group name
  ##   sortBy: JString
  ##         : sort the query results by input field, default value is 'lastModifiedDateTime'.
  ##   severity: JString
  ##           : filter by severity
  ##   monitorCondition: JString
  ##                   : filter by monitor condition which is the state of the alert at monitor service
  ##   smartGroupState: JString
  ##                  : filter by state
  ##   targetResourceType: JString
  ##                     : filter by target resource type
  ##   monitorService: JString
  ##                 : filter by monitor service which is the source of the alert object.
  ##   sortOrder: JString
  ##            : sort the query results order in either ascending or descending, default value is 'desc' for time fields and 'asc' for others.
  ##   pageCount: JInt
  ##            : number of items per page, default value is '25'.
  section = newJObject()
  var valid_594051 = query.getOrDefault("timeRange")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = newJString("1h"))
  if valid_594051 != nil:
    section.add "timeRange", valid_594051
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594052 = query.getOrDefault("api-version")
  valid_594052 = validateParameter(valid_594052, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_594052 != nil:
    section.add "api-version", valid_594052
  var valid_594053 = query.getOrDefault("targetResource")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "targetResource", valid_594053
  var valid_594054 = query.getOrDefault("targetResourceGroup")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "targetResourceGroup", valid_594054
  var valid_594055 = query.getOrDefault("sortBy")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = newJString("alertsCount"))
  if valid_594055 != nil:
    section.add "sortBy", valid_594055
  var valid_594056 = query.getOrDefault("severity")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_594056 != nil:
    section.add "severity", valid_594056
  var valid_594057 = query.getOrDefault("monitorCondition")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = newJString("Fired"))
  if valid_594057 != nil:
    section.add "monitorCondition", valid_594057
  var valid_594058 = query.getOrDefault("smartGroupState")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = newJString("New"))
  if valid_594058 != nil:
    section.add "smartGroupState", valid_594058
  var valid_594059 = query.getOrDefault("targetResourceType")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "targetResourceType", valid_594059
  var valid_594060 = query.getOrDefault("monitorService")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = newJString("Platform"))
  if valid_594060 != nil:
    section.add "monitorService", valid_594060
  var valid_594061 = query.getOrDefault("sortOrder")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = newJString("asc"))
  if valid_594061 != nil:
    section.add "sortOrder", valid_594061
  var valid_594062 = query.getOrDefault("pageCount")
  valid_594062 = validateParameter(valid_594062, JInt, required = false, default = nil)
  if valid_594062 != nil:
    section.add "pageCount", valid_594062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594063: Call_SmartGroupsGetAll_594047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the smartGroups within the specified subscription. 
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_SmartGroupsGetAll_594047; subscriptionId: string;
          timeRange: string = "1h";
          apiVersion: string = "2018-11-02-privatepreview";
          targetResource: string = ""; targetResourceGroup: string = "";
          sortBy: string = "alertsCount"; severity: string = "Sev0";
          monitorCondition: string = "Fired"; smartGroupState: string = "New";
          targetResourceType: string = ""; monitorService: string = "Platform";
          sortOrder: string = "asc"; pageCount: int = 0): Recallable =
  ## smartGroupsGetAll
  ## List all the smartGroups within the specified subscription. 
  ##   timeRange: string
  ##            : filter by time range, default value is 1 day
  ##   apiVersion: string (required)
  ##             : client API version
  ##   targetResource: string
  ##                 : filter by target resource
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   targetResourceGroup: string
  ##                      : filter by target resource group name
  ##   sortBy: string
  ##         : sort the query results by input field, default value is 'lastModifiedDateTime'.
  ##   severity: string
  ##           : filter by severity
  ##   monitorCondition: string
  ##                   : filter by monitor condition which is the state of the alert at monitor service
  ##   smartGroupState: string
  ##                  : filter by state
  ##   targetResourceType: string
  ##                     : filter by target resource type
  ##   monitorService: string
  ##                 : filter by monitor service which is the source of the alert object.
  ##   sortOrder: string
  ##            : sort the query results order in either ascending or descending, default value is 'desc' for time fields and 'asc' for others.
  ##   pageCount: int
  ##            : number of items per page, default value is '25'.
  var path_594065 = newJObject()
  var query_594066 = newJObject()
  add(query_594066, "timeRange", newJString(timeRange))
  add(query_594066, "api-version", newJString(apiVersion))
  add(query_594066, "targetResource", newJString(targetResource))
  add(path_594065, "subscriptionId", newJString(subscriptionId))
  add(query_594066, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_594066, "sortBy", newJString(sortBy))
  add(query_594066, "severity", newJString(severity))
  add(query_594066, "monitorCondition", newJString(monitorCondition))
  add(query_594066, "smartGroupState", newJString(smartGroupState))
  add(query_594066, "targetResourceType", newJString(targetResourceType))
  add(query_594066, "monitorService", newJString(monitorService))
  add(query_594066, "sortOrder", newJString(sortOrder))
  add(query_594066, "pageCount", newJInt(pageCount))
  result = call_594064.call(path_594065, query_594066, nil, nil, nil)

var smartGroupsGetAll* = Call_SmartGroupsGetAll_594047(name: "smartGroupsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups",
    validator: validate_SmartGroupsGetAll_594048, base: "",
    url: url_SmartGroupsGetAll_594049, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetById_594067 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsGetById_594069(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetById_594068(path: JsonNode; query: JsonNode;
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
  var valid_594070 = path.getOrDefault("subscriptionId")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "subscriptionId", valid_594070
  var valid_594071 = path.getOrDefault("smartGroupId")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "smartGroupId", valid_594071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_594072 != nil:
    section.add "api-version", valid_594072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_SmartGroupsGetById_594067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of smart group.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_SmartGroupsGetById_594067; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2018-11-02-privatepreview"): Recallable =
  ## smartGroupsGetById
  ## Get details of smart group.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart Group Id
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  add(path_594075, "smartGroupId", newJString(smartGroupId))
  result = call_594074.call(path_594075, query_594076, nil, nil, nil)

var smartGroupsGetById* = Call_SmartGroupsGetById_594067(
    name: "smartGroupsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}",
    validator: validate_SmartGroupsGetById_594068, base: "",
    url: url_SmartGroupsGetById_594069, schemes: {Scheme.Https})
type
  Call_SmartGroupsChangeState_594077 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsChangeState_594079(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsChangeState_594078(path: JsonNode; query: JsonNode;
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
  var valid_594080 = path.getOrDefault("subscriptionId")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "subscriptionId", valid_594080
  var valid_594081 = path.getOrDefault("smartGroupId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "smartGroupId", valid_594081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   newState: JString (required)
  ##           : filter by state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594082 = query.getOrDefault("api-version")
  valid_594082 = validateParameter(valid_594082, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_594082 != nil:
    section.add "api-version", valid_594082
  var valid_594083 = query.getOrDefault("newState")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = newJString("New"))
  if valid_594083 != nil:
    section.add "newState", valid_594083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594084: Call_SmartGroupsChangeState_594077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state from unresolved to resolved and all the alerts within the smart group will also be resolved.
  ## 
  let valid = call_594084.validator(path, query, header, formData, body)
  let scheme = call_594084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594084.url(scheme.get, call_594084.host, call_594084.base,
                         call_594084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594084, url, valid)

proc call*(call_594085: Call_SmartGroupsChangeState_594077; subscriptionId: string;
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
  var path_594086 = newJObject()
  var query_594087 = newJObject()
  add(query_594087, "api-version", newJString(apiVersion))
  add(path_594086, "subscriptionId", newJString(subscriptionId))
  add(path_594086, "smartGroupId", newJString(smartGroupId))
  add(query_594087, "newState", newJString(newState))
  result = call_594085.call(path_594086, query_594087, nil, nil, nil)

var smartGroupsChangeState* = Call_SmartGroupsChangeState_594077(
    name: "smartGroupsChangeState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/changeState",
    validator: validate_SmartGroupsChangeState_594078, base: "",
    url: url_SmartGroupsChangeState_594079, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetHistory_594088 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsGetHistory_594090(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetHistory_594089(path: JsonNode; query: JsonNode;
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
  var valid_594091 = path.getOrDefault("subscriptionId")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "subscriptionId", valid_594091
  var valid_594092 = path.getOrDefault("smartGroupId")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "smartGroupId", valid_594092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594093 = query.getOrDefault("api-version")
  valid_594093 = validateParameter(valid_594093, JString, required = true, default = newJString(
      "2018-11-02-privatepreview"))
  if valid_594093 != nil:
    section.add "api-version", valid_594093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594094: Call_SmartGroupsGetHistory_594088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history of the changes of smart group.
  ## 
  let valid = call_594094.validator(path, query, header, formData, body)
  let scheme = call_594094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594094.url(scheme.get, call_594094.host, call_594094.base,
                         call_594094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594094, url, valid)

proc call*(call_594095: Call_SmartGroupsGetHistory_594088; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2018-11-02-privatepreview"): Recallable =
  ## smartGroupsGetHistory
  ## Get the history of the changes of smart group.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart Group Id
  var path_594096 = newJObject()
  var query_594097 = newJObject()
  add(query_594097, "api-version", newJString(apiVersion))
  add(path_594096, "subscriptionId", newJString(subscriptionId))
  add(path_594096, "smartGroupId", newJString(smartGroupId))
  result = call_594095.call(path_594096, query_594097, nil, nil, nil)

var smartGroupsGetHistory* = Call_SmartGroupsGetHistory_594088(
    name: "smartGroupsGetHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/history",
    validator: validate_SmartGroupsGetHistory_594089, base: "",
    url: url_SmartGroupsGetHistory_594090, schemes: {Scheme.Https})
type
  Call_ActionRulesGetAllResourceGroup_594098 = ref object of OpenApiRestCall_593425
proc url_ActionRulesGetAllResourceGroup_594100(protocol: Scheme; host: string;
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

proc validate_ActionRulesGetAllResourceGroup_594099(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all action rules of the subscription, created in given resource group and given input filters
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Resource group name where the resource is created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594101 = path.getOrDefault("subscriptionId")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "subscriptionId", valid_594101
  var valid_594102 = path.getOrDefault("resourceGroup")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "resourceGroup", valid_594102
  result.add "path", section
  ## parameters in `query` object:
  ##   targetResource: JString
  ##                 : filter by target resource
  ##   targetResourceGroup: JString
  ##                      : filter by target resource group name
  ##   severity: JString
  ##           : filter by severity
  ##   targetResourceType: JString
  ##                     : filter by target resource type
  ##   monitorService: JString
  ##                 : filter by monitor service which is the source of the alert object.
  section = newJObject()
  var valid_594103 = query.getOrDefault("targetResource")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "targetResource", valid_594103
  var valid_594104 = query.getOrDefault("targetResourceGroup")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "targetResourceGroup", valid_594104
  var valid_594105 = query.getOrDefault("severity")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_594105 != nil:
    section.add "severity", valid_594105
  var valid_594106 = query.getOrDefault("targetResourceType")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "targetResourceType", valid_594106
  var valid_594107 = query.getOrDefault("monitorService")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = newJString("Platform"))
  if valid_594107 != nil:
    section.add "monitorService", valid_594107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594108: Call_ActionRulesGetAllResourceGroup_594098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all action rules of the subscription, created in given resource group and given input filters
  ## 
  let valid = call_594108.validator(path, query, header, formData, body)
  let scheme = call_594108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594108.url(scheme.get, call_594108.host, call_594108.base,
                         call_594108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594108, url, valid)

proc call*(call_594109: Call_ActionRulesGetAllResourceGroup_594098;
          subscriptionId: string; resourceGroup: string;
          targetResource: string = ""; targetResourceGroup: string = "";
          severity: string = "Sev0"; targetResourceType: string = "";
          monitorService: string = "Platform"): Recallable =
  ## actionRulesGetAllResourceGroup
  ## List all action rules of the subscription, created in given resource group and given input filters
  ##   targetResource: string
  ##                 : filter by target resource
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Resource group name where the resource is created.
  ##   targetResourceGroup: string
  ##                      : filter by target resource group name
  ##   severity: string
  ##           : filter by severity
  ##   targetResourceType: string
  ##                     : filter by target resource type
  ##   monitorService: string
  ##                 : filter by monitor service which is the source of the alert object.
  var path_594110 = newJObject()
  var query_594111 = newJObject()
  add(query_594111, "targetResource", newJString(targetResource))
  add(path_594110, "subscriptionId", newJString(subscriptionId))
  add(path_594110, "resourceGroup", newJString(resourceGroup))
  add(query_594111, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_594111, "severity", newJString(severity))
  add(query_594111, "targetResourceType", newJString(targetResourceType))
  add(query_594111, "monitorService", newJString(monitorService))
  result = call_594109.call(path_594110, query_594111, nil, nil, nil)

var actionRulesGetAllResourceGroup* = Call_ActionRulesGetAllResourceGroup_594098(
    name: "actionRulesGetAllResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/actionRules",
    validator: validate_ActionRulesGetAllResourceGroup_594099, base: "",
    url: url_ActionRulesGetAllResourceGroup_594100, schemes: {Scheme.Https})
type
  Call_ActionRulesCreateUpdate_594121 = ref object of OpenApiRestCall_593425
proc url_ActionRulesCreateUpdate_594123(protocol: Scheme; host: string; base: string;
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

proc validate_ActionRulesCreateUpdate_594122(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates/Updates a specific action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: JString (required)
  ##                 : The name of action rule that needs to be created/updated
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594141 = path.getOrDefault("subscriptionId")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "subscriptionId", valid_594141
  var valid_594142 = path.getOrDefault("resourceGroup")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "resourceGroup", valid_594142
  var valid_594143 = path.getOrDefault("actionRuleName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "actionRuleName", valid_594143
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

proc call*(call_594145: Call_ActionRulesCreateUpdate_594121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates/Updates a specific action rule
  ## 
  let valid = call_594145.validator(path, query, header, formData, body)
  let scheme = call_594145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594145.url(scheme.get, call_594145.host, call_594145.base,
                         call_594145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594145, url, valid)

proc call*(call_594146: Call_ActionRulesCreateUpdate_594121;
          subscriptionId: string; resourceGroup: string; actionRule: JsonNode;
          actionRuleName: string): Recallable =
  ## actionRulesCreateUpdate
  ## Creates/Updates a specific action rule
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Resource group name where the resource is created.
  ##   actionRule: JObject (required)
  ##             : action rule to be created/updated
  ##   actionRuleName: string (required)
  ##                 : The name of action rule that needs to be created/updated
  var path_594147 = newJObject()
  var body_594148 = newJObject()
  add(path_594147, "subscriptionId", newJString(subscriptionId))
  add(path_594147, "resourceGroup", newJString(resourceGroup))
  if actionRule != nil:
    body_594148 = actionRule
  add(path_594147, "actionRuleName", newJString(actionRuleName))
  result = call_594146.call(path_594147, nil, nil, nil, body_594148)

var actionRulesCreateUpdate* = Call_ActionRulesCreateUpdate_594121(
    name: "actionRulesCreateUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesCreateUpdate_594122, base: "",
    url: url_ActionRulesCreateUpdate_594123, schemes: {Scheme.Https})
type
  Call_ActionRulesGetByName_594112 = ref object of OpenApiRestCall_593425
proc url_ActionRulesGetByName_594114(protocol: Scheme; host: string; base: string;
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

proc validate_ActionRulesGetByName_594113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: JString (required)
  ##                 : The name of action rule that needs to be fetched
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594115 = path.getOrDefault("subscriptionId")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "subscriptionId", valid_594115
  var valid_594116 = path.getOrDefault("resourceGroup")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "resourceGroup", valid_594116
  var valid_594117 = path.getOrDefault("actionRuleName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "actionRuleName", valid_594117
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594118: Call_ActionRulesGetByName_594112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific action rule
  ## 
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_ActionRulesGetByName_594112; subscriptionId: string;
          resourceGroup: string; actionRuleName: string): Recallable =
  ## actionRulesGetByName
  ## Get a specific action rule
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: string (required)
  ##                 : The name of action rule that needs to be fetched
  var path_594120 = newJObject()
  add(path_594120, "subscriptionId", newJString(subscriptionId))
  add(path_594120, "resourceGroup", newJString(resourceGroup))
  add(path_594120, "actionRuleName", newJString(actionRuleName))
  result = call_594119.call(path_594120, nil, nil, nil, nil)

var actionRulesGetByName* = Call_ActionRulesGetByName_594112(
    name: "actionRulesGetByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesGetByName_594113, base: "",
    url: url_ActionRulesGetByName_594114, schemes: {Scheme.Https})
type
  Call_ActionRulesPatch_594158 = ref object of OpenApiRestCall_593425
proc url_ActionRulesPatch_594160(protocol: Scheme; host: string; base: string;
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

proc validate_ActionRulesPatch_594159(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Update enabled flag and/or tags for the given action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: JString (required)
  ##                 : The name that needs to be updated
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594161 = path.getOrDefault("subscriptionId")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "subscriptionId", valid_594161
  var valid_594162 = path.getOrDefault("resourceGroup")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "resourceGroup", valid_594162
  var valid_594163 = path.getOrDefault("actionRuleName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "actionRuleName", valid_594163
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

proc call*(call_594165: Call_ActionRulesPatch_594158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update enabled flag and/or tags for the given action rule
  ## 
  let valid = call_594165.validator(path, query, header, formData, body)
  let scheme = call_594165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594165.url(scheme.get, call_594165.host, call_594165.base,
                         call_594165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594165, url, valid)

proc call*(call_594166: Call_ActionRulesPatch_594158; subscriptionId: string;
          resourceGroup: string; actionRulePatch: JsonNode; actionRuleName: string): Recallable =
  ## actionRulesPatch
  ## Update enabled flag and/or tags for the given action rule
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Resource group name where the resource is created.
  ##   actionRulePatch: JObject (required)
  ##                  : Parameters supplied to the operation.
  ##   actionRuleName: string (required)
  ##                 : The name that needs to be updated
  var path_594167 = newJObject()
  var body_594168 = newJObject()
  add(path_594167, "subscriptionId", newJString(subscriptionId))
  add(path_594167, "resourceGroup", newJString(resourceGroup))
  if actionRulePatch != nil:
    body_594168 = actionRulePatch
  add(path_594167, "actionRuleName", newJString(actionRuleName))
  result = call_594166.call(path_594167, nil, nil, nil, body_594168)

var actionRulesPatch* = Call_ActionRulesPatch_594158(name: "actionRulesPatch",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesPatch_594159, base: "",
    url: url_ActionRulesPatch_594160, schemes: {Scheme.Https})
type
  Call_ActionRulesDelete_594149 = ref object of OpenApiRestCall_593425
proc url_ActionRulesDelete_594151(protocol: Scheme; host: string; base: string;
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

proc validate_ActionRulesDelete_594150(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes a given action rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: JString (required)
  ##                 : The name that needs to be deleted
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594152 = path.getOrDefault("subscriptionId")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "subscriptionId", valid_594152
  var valid_594153 = path.getOrDefault("resourceGroup")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "resourceGroup", valid_594153
  var valid_594154 = path.getOrDefault("actionRuleName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "actionRuleName", valid_594154
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594155: Call_ActionRulesDelete_594149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a given action rule
  ## 
  let valid = call_594155.validator(path, query, header, formData, body)
  let scheme = call_594155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594155.url(scheme.get, call_594155.host, call_594155.base,
                         call_594155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594155, url, valid)

proc call*(call_594156: Call_ActionRulesDelete_594149; subscriptionId: string;
          resourceGroup: string; actionRuleName: string): Recallable =
  ## actionRulesDelete
  ## Deletes a given action rule
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Resource group name where the resource is created.
  ##   actionRuleName: string (required)
  ##                 : The name that needs to be deleted
  var path_594157 = newJObject()
  add(path_594157, "subscriptionId", newJString(subscriptionId))
  add(path_594157, "resourceGroup", newJString(resourceGroup))
  add(path_594157, "actionRuleName", newJString(actionRuleName))
  result = call_594156.call(path_594157, nil, nil, nil, nil)

var actionRulesDelete* = Call_ActionRulesDelete_594149(name: "actionRulesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AlertsManagement/actionRules/{actionRuleName}",
    validator: validate_ActionRulesDelete_594150, base: "",
    url: url_ActionRulesDelete_594151, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
