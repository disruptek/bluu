
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
      "2017-11-15-privatepreview"))
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
          apiVersion: string = "2017-11-15-privatepreview"): Recallable =
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
  Call_AlertsGetAll_593956 = ref object of OpenApiRestCall_593425
proc url_AlertsGetAll_593958(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetAll_593957(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
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
  var valid_593974 = query.getOrDefault("timeRange")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = newJString("1h"))
  if valid_593974 != nil:
    section.add "timeRange", valid_593974
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  var valid_593976 = query.getOrDefault("targetResource")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "targetResource", valid_593976
  var valid_593977 = query.getOrDefault("includePayload")
  valid_593977 = validateParameter(valid_593977, JBool, required = false, default = nil)
  if valid_593977 != nil:
    section.add "includePayload", valid_593977
  var valid_593978 = query.getOrDefault("targetResourceGroup")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "targetResourceGroup", valid_593978
  var valid_593979 = query.getOrDefault("sortBy")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = newJString("name"))
  if valid_593979 != nil:
    section.add "sortBy", valid_593979
  var valid_593980 = query.getOrDefault("severity")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_593980 != nil:
    section.add "severity", valid_593980
  var valid_593981 = query.getOrDefault("monitorCondition")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = newJString("Fired"))
  if valid_593981 != nil:
    section.add "monitorCondition", valid_593981
  var valid_593982 = query.getOrDefault("targetResourceType")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "targetResourceType", valid_593982
  var valid_593983 = query.getOrDefault("monitorService")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = newJString("Platform"))
  if valid_593983 != nil:
    section.add "monitorService", valid_593983
  var valid_593984 = query.getOrDefault("smartGroupId")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "smartGroupId", valid_593984
  var valid_593985 = query.getOrDefault("sortOrder")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("asc"))
  if valid_593985 != nil:
    section.add "sortOrder", valid_593985
  var valid_593986 = query.getOrDefault("pageCount")
  valid_593986 = validateParameter(valid_593986, JInt, required = false, default = nil)
  if valid_593986 != nil:
    section.add "pageCount", valid_593986
  var valid_593987 = query.getOrDefault("alertState")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = newJString("New"))
  if valid_593987 != nil:
    section.add "alertState", valid_593987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593988: Call_AlertsGetAll_593956; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the existing alerts, where the results can be selective by passing multiple filter parameters including time range and sorted on specific fields. 
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_AlertsGetAll_593956; subscriptionId: string;
          timeRange: string = "1h";
          apiVersion: string = "2017-11-15-privatepreview";
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
  var path_593990 = newJObject()
  var query_593991 = newJObject()
  add(query_593991, "timeRange", newJString(timeRange))
  add(query_593991, "api-version", newJString(apiVersion))
  add(query_593991, "targetResource", newJString(targetResource))
  add(path_593990, "subscriptionId", newJString(subscriptionId))
  add(query_593991, "includePayload", newJBool(includePayload))
  add(query_593991, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_593991, "sortBy", newJString(sortBy))
  add(query_593991, "severity", newJString(severity))
  add(query_593991, "monitorCondition", newJString(monitorCondition))
  add(query_593991, "targetResourceType", newJString(targetResourceType))
  add(query_593991, "monitorService", newJString(monitorService))
  add(query_593991, "smartGroupId", newJString(smartGroupId))
  add(query_593991, "sortOrder", newJString(sortOrder))
  add(query_593991, "pageCount", newJInt(pageCount))
  add(query_593991, "alertState", newJString(alertState))
  result = call_593989.call(path_593990, query_593991, nil, nil, nil)

var alertsGetAll* = Call_AlertsGetAll_593956(name: "alertsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts",
    validator: validate_AlertsGetAll_593957, base: "", url: url_AlertsGetAll_593958,
    schemes: {Scheme.Https})
type
  Call_AlertsGetById_593992 = ref object of OpenApiRestCall_593425
proc url_AlertsGetById_593994(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetById_593993(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593995 = path.getOrDefault("subscriptionId")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "subscriptionId", valid_593995
  var valid_593996 = path.getOrDefault("alertId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "alertId", valid_593996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593997 = query.getOrDefault("api-version")
  valid_593997 = validateParameter(valid_593997, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_593997 != nil:
    section.add "api-version", valid_593997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_AlertsGetById_593992; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific alert
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_AlertsGetById_593992; subscriptionId: string;
          alertId: string; apiVersion: string = "2017-11-15-privatepreview"): Recallable =
  ## alertsGetById
  ## Get information related to a specific alert
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alertId: string (required)
  ##          : Unique ID of an alert object.
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "subscriptionId", newJString(subscriptionId))
  add(path_594000, "alertId", newJString(alertId))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var alertsGetById* = Call_AlertsGetById_593992(name: "alertsGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}",
    validator: validate_AlertsGetById_593993, base: "", url: url_AlertsGetById_593994,
    schemes: {Scheme.Https})
type
  Call_AlertsChangeState_594002 = ref object of OpenApiRestCall_593425
proc url_AlertsChangeState_594004(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsChangeState_594003(path: JsonNode; query: JsonNode;
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
  var valid_594005 = path.getOrDefault("subscriptionId")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "subscriptionId", valid_594005
  var valid_594006 = path.getOrDefault("alertId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "alertId", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   newState: JString (required)
  ##           : filter by state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  var valid_594008 = query.getOrDefault("newState")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = newJString("New"))
  if valid_594008 != nil:
    section.add "newState", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_AlertsChangeState_594002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of the alert.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_AlertsChangeState_594002; subscriptionId: string;
          alertId: string; apiVersion: string = "2017-11-15-privatepreview";
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
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(query_594012, "api-version", newJString(apiVersion))
  add(path_594011, "subscriptionId", newJString(subscriptionId))
  add(query_594012, "newState", newJString(newState))
  add(path_594011, "alertId", newJString(alertId))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var alertsChangeState* = Call_AlertsChangeState_594002(name: "alertsChangeState",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/changestate",
    validator: validate_AlertsChangeState_594003, base: "",
    url: url_AlertsChangeState_594004, schemes: {Scheme.Https})
type
  Call_AlertsGetHistory_594013 = ref object of OpenApiRestCall_593425
proc url_AlertsGetHistory_594015(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetHistory_594014(path: JsonNode; query: JsonNode;
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
  var valid_594016 = path.getOrDefault("subscriptionId")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "subscriptionId", valid_594016
  var valid_594017 = path.getOrDefault("alertId")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "alertId", valid_594017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594018 = query.getOrDefault("api-version")
  valid_594018 = validateParameter(valid_594018, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_594018 != nil:
    section.add "api-version", valid_594018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594019: Call_AlertsGetHistory_594013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history of the changes of an alert.
  ## 
  let valid = call_594019.validator(path, query, header, formData, body)
  let scheme = call_594019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594019.url(scheme.get, call_594019.host, call_594019.base,
                         call_594019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594019, url, valid)

proc call*(call_594020: Call_AlertsGetHistory_594013; subscriptionId: string;
          alertId: string; apiVersion: string = "2017-11-15-privatepreview"): Recallable =
  ## alertsGetHistory
  ## Get the history of the changes of an alert.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alertId: string (required)
  ##          : Unique ID of an alert object.
  var path_594021 = newJObject()
  var query_594022 = newJObject()
  add(query_594022, "api-version", newJString(apiVersion))
  add(path_594021, "subscriptionId", newJString(subscriptionId))
  add(path_594021, "alertId", newJString(alertId))
  result = call_594020.call(path_594021, query_594022, nil, nil, nil)

var alertsGetHistory* = Call_AlertsGetHistory_594013(name: "alertsGetHistory",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/history",
    validator: validate_AlertsGetHistory_594014, base: "",
    url: url_AlertsGetHistory_594015, schemes: {Scheme.Https})
type
  Call_AlertsGetSummary_594023 = ref object of OpenApiRestCall_593425
proc url_AlertsGetSummary_594025(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetSummary_594024(path: JsonNode; query: JsonNode;
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
  var valid_594026 = path.getOrDefault("subscriptionId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "subscriptionId", valid_594026
  result.add "path", section
  ## parameters in `query` object:
  ##   timeRange: JString
  ##            : filter by time range, default value is 1 day
  ##   api-version: JString (required)
  ##              : client API version
  ##   targetResourceGroup: JString
  ##                      : filter by target resource group name
  section = newJObject()
  var valid_594027 = query.getOrDefault("timeRange")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = newJString("1h"))
  if valid_594027 != nil:
    section.add "timeRange", valid_594027
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  var valid_594029 = query.getOrDefault("targetResourceGroup")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "targetResourceGroup", valid_594029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594030: Call_AlertsGetSummary_594023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Summary of alerts with the count each severity.
  ## 
  let valid = call_594030.validator(path, query, header, formData, body)
  let scheme = call_594030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594030.url(scheme.get, call_594030.host, call_594030.base,
                         call_594030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594030, url, valid)

proc call*(call_594031: Call_AlertsGetSummary_594023; subscriptionId: string;
          timeRange: string = "1h";
          apiVersion: string = "2017-11-15-privatepreview";
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
  var path_594032 = newJObject()
  var query_594033 = newJObject()
  add(query_594033, "timeRange", newJString(timeRange))
  add(query_594033, "api-version", newJString(apiVersion))
  add(path_594032, "subscriptionId", newJString(subscriptionId))
  add(query_594033, "targetResourceGroup", newJString(targetResourceGroup))
  result = call_594031.call(path_594032, query_594033, nil, nil, nil)

var alertsGetSummary* = Call_AlertsGetSummary_594023(name: "alertsGetSummary",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alertsSummary",
    validator: validate_AlertsGetSummary_594024, base: "",
    url: url_AlertsGetSummary_594025, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetAll_594034 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsGetAll_594036(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetAll_594035(path: JsonNode; query: JsonNode;
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
  var valid_594037 = path.getOrDefault("subscriptionId")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "subscriptionId", valid_594037
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
  var valid_594038 = query.getOrDefault("timeRange")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = newJString("1h"))
  if valid_594038 != nil:
    section.add "timeRange", valid_594038
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594039 = query.getOrDefault("api-version")
  valid_594039 = validateParameter(valid_594039, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_594039 != nil:
    section.add "api-version", valid_594039
  var valid_594040 = query.getOrDefault("targetResource")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "targetResource", valid_594040
  var valid_594041 = query.getOrDefault("targetResourceGroup")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "targetResourceGroup", valid_594041
  var valid_594042 = query.getOrDefault("sortBy")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = newJString("alertsCount"))
  if valid_594042 != nil:
    section.add "sortBy", valid_594042
  var valid_594043 = query.getOrDefault("severity")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_594043 != nil:
    section.add "severity", valid_594043
  var valid_594044 = query.getOrDefault("monitorCondition")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = newJString("Fired"))
  if valid_594044 != nil:
    section.add "monitorCondition", valid_594044
  var valid_594045 = query.getOrDefault("smartGroupState")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = newJString("New"))
  if valid_594045 != nil:
    section.add "smartGroupState", valid_594045
  var valid_594046 = query.getOrDefault("targetResourceType")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "targetResourceType", valid_594046
  var valid_594047 = query.getOrDefault("monitorService")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = newJString("Platform"))
  if valid_594047 != nil:
    section.add "monitorService", valid_594047
  var valid_594048 = query.getOrDefault("sortOrder")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = newJString("asc"))
  if valid_594048 != nil:
    section.add "sortOrder", valid_594048
  var valid_594049 = query.getOrDefault("pageCount")
  valid_594049 = validateParameter(valid_594049, JInt, required = false, default = nil)
  if valid_594049 != nil:
    section.add "pageCount", valid_594049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_SmartGroupsGetAll_594034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the smartGroups within the specified subscription. 
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_SmartGroupsGetAll_594034; subscriptionId: string;
          timeRange: string = "1h";
          apiVersion: string = "2017-11-15-privatepreview";
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
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  add(query_594053, "timeRange", newJString(timeRange))
  add(query_594053, "api-version", newJString(apiVersion))
  add(query_594053, "targetResource", newJString(targetResource))
  add(path_594052, "subscriptionId", newJString(subscriptionId))
  add(query_594053, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_594053, "sortBy", newJString(sortBy))
  add(query_594053, "severity", newJString(severity))
  add(query_594053, "monitorCondition", newJString(monitorCondition))
  add(query_594053, "smartGroupState", newJString(smartGroupState))
  add(query_594053, "targetResourceType", newJString(targetResourceType))
  add(query_594053, "monitorService", newJString(monitorService))
  add(query_594053, "sortOrder", newJString(sortOrder))
  add(query_594053, "pageCount", newJInt(pageCount))
  result = call_594051.call(path_594052, query_594053, nil, nil, nil)

var smartGroupsGetAll* = Call_SmartGroupsGetAll_594034(name: "smartGroupsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups",
    validator: validate_SmartGroupsGetAll_594035, base: "",
    url: url_SmartGroupsGetAll_594036, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetById_594054 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsGetById_594056(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetById_594055(path: JsonNode; query: JsonNode;
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
  var valid_594057 = path.getOrDefault("subscriptionId")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "subscriptionId", valid_594057
  var valid_594058 = path.getOrDefault("smartGroupId")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "smartGroupId", valid_594058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594059 = query.getOrDefault("api-version")
  valid_594059 = validateParameter(valid_594059, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_594059 != nil:
    section.add "api-version", valid_594059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_SmartGroupsGetById_594054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of smart group.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_SmartGroupsGetById_594054; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2017-11-15-privatepreview"): Recallable =
  ## smartGroupsGetById
  ## Get details of smart group.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart Group Id
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  add(query_594063, "api-version", newJString(apiVersion))
  add(path_594062, "subscriptionId", newJString(subscriptionId))
  add(path_594062, "smartGroupId", newJString(smartGroupId))
  result = call_594061.call(path_594062, query_594063, nil, nil, nil)

var smartGroupsGetById* = Call_SmartGroupsGetById_594054(
    name: "smartGroupsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}",
    validator: validate_SmartGroupsGetById_594055, base: "",
    url: url_SmartGroupsGetById_594056, schemes: {Scheme.Https})
type
  Call_SmartGroupsChangeState_594064 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsChangeState_594066(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsChangeState_594065(path: JsonNode; query: JsonNode;
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
  var valid_594067 = path.getOrDefault("subscriptionId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "subscriptionId", valid_594067
  var valid_594068 = path.getOrDefault("smartGroupId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "smartGroupId", valid_594068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  ##   newState: JString (required)
  ##           : filter by state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594069 = query.getOrDefault("api-version")
  valid_594069 = validateParameter(valid_594069, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_594069 != nil:
    section.add "api-version", valid_594069
  var valid_594070 = query.getOrDefault("newState")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = newJString("New"))
  if valid_594070 != nil:
    section.add "newState", valid_594070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_SmartGroupsChangeState_594064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state from unresolved to resolved and all the alerts within the smart group will also be resolved.
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_SmartGroupsChangeState_594064; subscriptionId: string;
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
  var path_594073 = newJObject()
  var query_594074 = newJObject()
  add(query_594074, "api-version", newJString(apiVersion))
  add(path_594073, "subscriptionId", newJString(subscriptionId))
  add(path_594073, "smartGroupId", newJString(smartGroupId))
  add(query_594074, "newState", newJString(newState))
  result = call_594072.call(path_594073, query_594074, nil, nil, nil)

var smartGroupsChangeState* = Call_SmartGroupsChangeState_594064(
    name: "smartGroupsChangeState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/changeState",
    validator: validate_SmartGroupsChangeState_594065, base: "",
    url: url_SmartGroupsChangeState_594066, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetHistory_594075 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsGetHistory_594077(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetHistory_594076(path: JsonNode; query: JsonNode;
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
  var valid_594078 = path.getOrDefault("subscriptionId")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "subscriptionId", valid_594078
  var valid_594079 = path.getOrDefault("smartGroupId")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "smartGroupId", valid_594079
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : client API version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594080 = query.getOrDefault("api-version")
  valid_594080 = validateParameter(valid_594080, JString, required = true, default = newJString(
      "2017-11-15-privatepreview"))
  if valid_594080 != nil:
    section.add "api-version", valid_594080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594081: Call_SmartGroupsGetHistory_594075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history of the changes of smart group.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_SmartGroupsGetHistory_594075; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2017-11-15-privatepreview"): Recallable =
  ## smartGroupsGetHistory
  ## Get the history of the changes of smart group.
  ##   apiVersion: string (required)
  ##             : client API version
  ##   subscriptionId: string (required)
  ##                 : subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart Group Id
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  add(query_594084, "api-version", newJString(apiVersion))
  add(path_594083, "subscriptionId", newJString(subscriptionId))
  add(path_594083, "smartGroupId", newJString(smartGroupId))
  result = call_594082.call(path_594083, query_594084, nil, nil, nil)

var smartGroupsGetHistory* = Call_SmartGroupsGetHistory_594075(
    name: "smartGroupsGetHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/history",
    validator: validate_SmartGroupsGetHistory_594076, base: "",
    url: url_SmartGroupsGetHistory_594077, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
