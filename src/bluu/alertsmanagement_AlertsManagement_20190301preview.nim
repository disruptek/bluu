
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Alerts Management Service Resource Provider
## version: 2019-03-01-preview
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593821 = query.getOrDefault("api-version")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = newJString("2018-05-05"))
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
          apiVersion: string = "2018-05-05"): Recallable =
  ## operationsList
  ## List all operations available through Azure Alerts Management Resource Provider.
  ##   apiVersion: string (required)
  ##             : API version.
  var query_593916 = newJObject()
  add(query_593916, "api-version", newJString(apiVersion))
  result = call_593915.call(nil, query_593916, nil, nil, nil)

var operationsList* = Call_OperationsList_593647(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.AlertsManagement/operations",
    validator: validate_OperationsList_593648, base: "", url: url_OperationsList_593649,
    schemes: {Scheme.Https})
type
  Call_SmartGroupsGetAll_593956 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsGetAll_593958(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetAll_593957(path: JsonNode; query: JsonNode;
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
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   timeRange: JString
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   api-version: JString (required)
  ##              : API version.
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
  var valid_593974 = query.getOrDefault("timeRange")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = newJString("1h"))
  if valid_593974 != nil:
    section.add "timeRange", valid_593974
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  var valid_593976 = query.getOrDefault("targetResource")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "targetResource", valid_593976
  var valid_593977 = query.getOrDefault("targetResourceGroup")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "targetResourceGroup", valid_593977
  var valid_593978 = query.getOrDefault("sortBy")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("alertsCount"))
  if valid_593978 != nil:
    section.add "sortBy", valid_593978
  var valid_593979 = query.getOrDefault("severity")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_593979 != nil:
    section.add "severity", valid_593979
  var valid_593980 = query.getOrDefault("monitorCondition")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = newJString("Fired"))
  if valid_593980 != nil:
    section.add "monitorCondition", valid_593980
  var valid_593981 = query.getOrDefault("smartGroupState")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = newJString("New"))
  if valid_593981 != nil:
    section.add "smartGroupState", valid_593981
  var valid_593982 = query.getOrDefault("targetResourceType")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "targetResourceType", valid_593982
  var valid_593983 = query.getOrDefault("monitorService")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_593983 != nil:
    section.add "monitorService", valid_593983
  var valid_593984 = query.getOrDefault("sortOrder")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = newJString("asc"))
  if valid_593984 != nil:
    section.add "sortOrder", valid_593984
  var valid_593985 = query.getOrDefault("pageCount")
  valid_593985 = validateParameter(valid_593985, JInt, required = false, default = nil)
  if valid_593985 != nil:
    section.add "pageCount", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_SmartGroupsGetAll_593956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the Smart Groups within a specified subscription. 
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_SmartGroupsGetAll_593956; subscriptionId: string;
          timeRange: string = "1h"; apiVersion: string = "2018-05-05";
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
  ##             : API version.
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  add(query_593989, "timeRange", newJString(timeRange))
  add(query_593989, "api-version", newJString(apiVersion))
  add(query_593989, "targetResource", newJString(targetResource))
  add(path_593988, "subscriptionId", newJString(subscriptionId))
  add(query_593989, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_593989, "sortBy", newJString(sortBy))
  add(query_593989, "severity", newJString(severity))
  add(query_593989, "monitorCondition", newJString(monitorCondition))
  add(query_593989, "smartGroupState", newJString(smartGroupState))
  add(query_593989, "targetResourceType", newJString(targetResourceType))
  add(query_593989, "monitorService", newJString(monitorService))
  add(query_593989, "sortOrder", newJString(sortOrder))
  add(query_593989, "pageCount", newJInt(pageCount))
  result = call_593987.call(path_593988, query_593989, nil, nil, nil)

var smartGroupsGetAll* = Call_SmartGroupsGetAll_593956(name: "smartGroupsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups",
    validator: validate_SmartGroupsGetAll_593957, base: "",
    url: url_SmartGroupsGetAll_593958, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetById_593990 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsGetById_593992(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetById_593991(path: JsonNode; query: JsonNode;
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
  var valid_593993 = path.getOrDefault("subscriptionId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "subscriptionId", valid_593993
  var valid_593994 = path.getOrDefault("smartGroupId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "smartGroupId", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_593995 != nil:
    section.add "api-version", valid_593995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593996: Call_SmartGroupsGetById_593990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific Smart Group.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_SmartGroupsGetById_593990; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2018-05-05"): Recallable =
  ## smartGroupsGetById
  ## Get information related to a specific Smart Group.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart group unique id. 
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  add(query_593999, "api-version", newJString(apiVersion))
  add(path_593998, "subscriptionId", newJString(subscriptionId))
  add(path_593998, "smartGroupId", newJString(smartGroupId))
  result = call_593997.call(path_593998, query_593999, nil, nil, nil)

var smartGroupsGetById* = Call_SmartGroupsGetById_593990(
    name: "smartGroupsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}",
    validator: validate_SmartGroupsGetById_593991, base: "",
    url: url_SmartGroupsGetById_593992, schemes: {Scheme.Https})
type
  Call_SmartGroupsChangeState_594000 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsChangeState_594002(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsChangeState_594001(path: JsonNode; query: JsonNode;
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
  var valid_594003 = path.getOrDefault("subscriptionId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "subscriptionId", valid_594003
  var valid_594004 = path.getOrDefault("smartGroupId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "smartGroupId", valid_594004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   newState: JString (required)
  ##           : New state of the alert.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594005 = query.getOrDefault("api-version")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_594005 != nil:
    section.add "api-version", valid_594005
  var valid_594006 = query.getOrDefault("newState")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = newJString("New"))
  if valid_594006 != nil:
    section.add "newState", valid_594006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_SmartGroupsChangeState_594000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of a Smart Group.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_SmartGroupsChangeState_594000; subscriptionId: string;
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
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "subscriptionId", newJString(subscriptionId))
  add(path_594009, "smartGroupId", newJString(smartGroupId))
  add(query_594010, "newState", newJString(newState))
  result = call_594008.call(path_594009, query_594010, nil, nil, nil)

var smartGroupsChangeState* = Call_SmartGroupsChangeState_594000(
    name: "smartGroupsChangeState", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/changeState",
    validator: validate_SmartGroupsChangeState_594001, base: "",
    url: url_SmartGroupsChangeState_594002, schemes: {Scheme.Https})
type
  Call_SmartGroupsGetHistory_594011 = ref object of OpenApiRestCall_593425
proc url_SmartGroupsGetHistory_594013(protocol: Scheme; host: string; base: string;
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

proc validate_SmartGroupsGetHistory_594012(path: JsonNode; query: JsonNode;
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
  var valid_594014 = path.getOrDefault("subscriptionId")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "subscriptionId", valid_594014
  var valid_594015 = path.getOrDefault("smartGroupId")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "smartGroupId", valid_594015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594016 = query.getOrDefault("api-version")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_594016 != nil:
    section.add "api-version", valid_594016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_SmartGroupsGetHistory_594011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history a smart group, which captures any Smart Group state changes (New/Acknowledged/Closed) .
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_SmartGroupsGetHistory_594011; subscriptionId: string;
          smartGroupId: string; apiVersion: string = "2018-05-05"): Recallable =
  ## smartGroupsGetHistory
  ## Get the history a smart group, which captures any Smart Group state changes (New/Acknowledged/Closed) .
  ##   apiVersion: string (required)
  ##             : API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   smartGroupId: string (required)
  ##               : Smart group unique id. 
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  add(query_594020, "api-version", newJString(apiVersion))
  add(path_594019, "subscriptionId", newJString(subscriptionId))
  add(path_594019, "smartGroupId", newJString(smartGroupId))
  result = call_594018.call(path_594019, query_594020, nil, nil, nil)

var smartGroupsGetHistory* = Call_SmartGroupsGetHistory_594011(
    name: "smartGroupsGetHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/history",
    validator: validate_SmartGroupsGetHistory_594012, base: "",
    url: url_SmartGroupsGetHistory_594013, schemes: {Scheme.Https})
type
  Call_AlertsGetAll_594021 = ref object of OpenApiRestCall_593425
proc url_AlertsGetAll_594023(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetAll_594022(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594024 = path.getOrDefault("scope")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "scope", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   timeRange: JString
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   api-version: JString (required)
  ##              : API version.
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
  var valid_594025 = query.getOrDefault("timeRange")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = newJString("1h"))
  if valid_594025 != nil:
    section.add "timeRange", valid_594025
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  var valid_594027 = query.getOrDefault("includeContext")
  valid_594027 = validateParameter(valid_594027, JBool, required = false, default = nil)
  if valid_594027 != nil:
    section.add "includeContext", valid_594027
  var valid_594028 = query.getOrDefault("targetResource")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "targetResource", valid_594028
  var valid_594029 = query.getOrDefault("select")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "select", valid_594029
  var valid_594030 = query.getOrDefault("customTimeRange")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "customTimeRange", valid_594030
  var valid_594031 = query.getOrDefault("targetResourceGroup")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "targetResourceGroup", valid_594031
  var valid_594032 = query.getOrDefault("sortBy")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = newJString("name"))
  if valid_594032 != nil:
    section.add "sortBy", valid_594032
  var valid_594033 = query.getOrDefault("severity")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_594033 != nil:
    section.add "severity", valid_594033
  var valid_594034 = query.getOrDefault("monitorCondition")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = newJString("Fired"))
  if valid_594034 != nil:
    section.add "monitorCondition", valid_594034
  var valid_594035 = query.getOrDefault("targetResourceType")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "targetResourceType", valid_594035
  var valid_594036 = query.getOrDefault("monitorService")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_594036 != nil:
    section.add "monitorService", valid_594036
  var valid_594037 = query.getOrDefault("alertRule")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "alertRule", valid_594037
  var valid_594038 = query.getOrDefault("smartGroupId")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "smartGroupId", valid_594038
  var valid_594039 = query.getOrDefault("sortOrder")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = newJString("asc"))
  if valid_594039 != nil:
    section.add "sortOrder", valid_594039
  var valid_594040 = query.getOrDefault("pageCount")
  valid_594040 = validateParameter(valid_594040, JInt, required = false, default = nil)
  if valid_594040 != nil:
    section.add "pageCount", valid_594040
  var valid_594041 = query.getOrDefault("alertState")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = newJString("New"))
  if valid_594041 != nil:
    section.add "alertState", valid_594041
  var valid_594042 = query.getOrDefault("includeEgressConfig")
  valid_594042 = validateParameter(valid_594042, JBool, required = false, default = nil)
  if valid_594042 != nil:
    section.add "includeEgressConfig", valid_594042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_AlertsGetAll_594021; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all existing alerts, where the results can be filtered on the basis of multiple parameters (e.g. time range). The results can then be sorted on the basis specific fields, with the default being lastModifiedDateTime. 
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_AlertsGetAll_594021; scope: string;
          timeRange: string = "1h"; apiVersion: string = "2018-05-05";
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
  ##             : API version.
  ##   includeContext: bool
  ##                 : Include context which has contextual data specific to the monitor service. Default value is false'
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
  ##   select: string
  ##         : This filter allows to selection of the fields(comma separated) which would  be part of the essential section. This would allow to project only the  required fields rather than getting entire content.  Default is to fetch all the fields in the essentials section.
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
  ##   scope: string (required)
  ##        : scope here is resourceId for which alert is created.
  ##   alertState: string
  ##             : Filter by state of the alert instance. Default value is to select all.
  ##   includeEgressConfig: bool
  ##                      : Include egress config which would be used for displaying the content in portal.  Default value is 'false'.
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  add(query_594046, "timeRange", newJString(timeRange))
  add(query_594046, "api-version", newJString(apiVersion))
  add(query_594046, "includeContext", newJBool(includeContext))
  add(query_594046, "targetResource", newJString(targetResource))
  add(query_594046, "select", newJString(select))
  add(query_594046, "customTimeRange", newJString(customTimeRange))
  add(query_594046, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_594046, "sortBy", newJString(sortBy))
  add(query_594046, "severity", newJString(severity))
  add(query_594046, "monitorCondition", newJString(monitorCondition))
  add(query_594046, "targetResourceType", newJString(targetResourceType))
  add(query_594046, "monitorService", newJString(monitorService))
  add(query_594046, "alertRule", newJString(alertRule))
  add(query_594046, "smartGroupId", newJString(smartGroupId))
  add(query_594046, "sortOrder", newJString(sortOrder))
  add(query_594046, "pageCount", newJInt(pageCount))
  add(path_594045, "scope", newJString(scope))
  add(query_594046, "alertState", newJString(alertState))
  add(query_594046, "includeEgressConfig", newJBool(includeEgressConfig))
  result = call_594044.call(path_594045, query_594046, nil, nil, nil)

var alertsGetAll* = Call_AlertsGetAll_594021(name: "alertsGetAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.AlertsManagement/alerts",
    validator: validate_AlertsGetAll_594022, base: "", url: url_AlertsGetAll_594023,
    schemes: {Scheme.Https})
type
  Call_AlertsGetById_594047 = ref object of OpenApiRestCall_593425
proc url_AlertsGetById_594049(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetById_594048(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information related to a specific alert
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
  var valid_594050 = path.getOrDefault("alertId")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "alertId", valid_594050
  var valid_594051 = path.getOrDefault("scope")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "scope", valid_594051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594052 = query.getOrDefault("api-version")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_594052 != nil:
    section.add "api-version", valid_594052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594053: Call_AlertsGetById_594047; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information related to a specific alert
  ## 
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_AlertsGetById_594047; alertId: string; scope: string;
          apiVersion: string = "2018-05-05"): Recallable =
  ## alertsGetById
  ## Get information related to a specific alert
  ##   apiVersion: string (required)
  ##             : API version.
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  ##   scope: string (required)
  ##        : scope here is resourceId for which alert is created.
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  add(query_594056, "api-version", newJString(apiVersion))
  add(path_594055, "alertId", newJString(alertId))
  add(path_594055, "scope", newJString(scope))
  result = call_594054.call(path_594055, query_594056, nil, nil, nil)

var alertsGetById* = Call_AlertsGetById_594047(name: "alertsGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.AlertsManagement/alerts/{alertId}",
    validator: validate_AlertsGetById_594048, base: "", url: url_AlertsGetById_594049,
    schemes: {Scheme.Https})
type
  Call_AlertsChangeState_594057 = ref object of OpenApiRestCall_593425
proc url_AlertsChangeState_594059(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsChangeState_594058(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Change the state of an alert.
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
  var valid_594060 = path.getOrDefault("alertId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "alertId", valid_594060
  var valid_594061 = path.getOrDefault("scope")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "scope", valid_594061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  ##   newState: JString (required)
  ##           : New state of the alert.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594062 = query.getOrDefault("api-version")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_594062 != nil:
    section.add "api-version", valid_594062
  var valid_594063 = query.getOrDefault("newState")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = newJString("New"))
  if valid_594063 != nil:
    section.add "newState", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_AlertsChangeState_594057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Change the state of an alert.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_AlertsChangeState_594057; alertId: string;
          scope: string; apiVersion: string = "2018-05-05"; newState: string = "New"): Recallable =
  ## alertsChangeState
  ## Change the state of an alert.
  ##   apiVersion: string (required)
  ##             : API version.
  ##   newState: string (required)
  ##           : New state of the alert.
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  ##   scope: string (required)
  ##        : scope here is resourceId for which alert is created.
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(query_594067, "api-version", newJString(apiVersion))
  add(query_594067, "newState", newJString(newState))
  add(path_594066, "alertId", newJString(alertId))
  add(path_594066, "scope", newJString(scope))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var alertsChangeState* = Call_AlertsChangeState_594057(name: "alertsChangeState",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/{scope}/providers/Microsoft.AlertsManagement/alerts/{alertId}/changestate",
    validator: validate_AlertsChangeState_594058, base: "",
    url: url_AlertsChangeState_594059, schemes: {Scheme.Https})
type
  Call_AlertsGetHistory_594068 = ref object of OpenApiRestCall_593425
proc url_AlertsGetHistory_594070(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetHistory_594069(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved) and alert state changes (New/Acknowledged/Closed).
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
  var valid_594071 = path.getOrDefault("alertId")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "alertId", valid_594071
  var valid_594072 = path.getOrDefault("scope")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "scope", valid_594072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594073 = query.getOrDefault("api-version")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_594073 != nil:
    section.add "api-version", valid_594073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_AlertsGetHistory_594068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved) and alert state changes (New/Acknowledged/Closed).
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_AlertsGetHistory_594068; alertId: string; scope: string;
          apiVersion: string = "2018-05-05"): Recallable =
  ## alertsGetHistory
  ## Get the history of an alert, which captures any monitor condition changes (Fired/Resolved) and alert state changes (New/Acknowledged/Closed).
  ##   apiVersion: string (required)
  ##             : API version.
  ##   alertId: string (required)
  ##          : Unique ID of an alert instance.
  ##   scope: string (required)
  ##        : scope here is resourceId for which alert is created.
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(query_594077, "api-version", newJString(apiVersion))
  add(path_594076, "alertId", newJString(alertId))
  add(path_594076, "scope", newJString(scope))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var alertsGetHistory* = Call_AlertsGetHistory_594068(name: "alertsGetHistory",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.AlertsManagement/alerts/{alertId}/history",
    validator: validate_AlertsGetHistory_594069, base: "",
    url: url_AlertsGetHistory_594070, schemes: {Scheme.Https})
type
  Call_AlertsGetSummary_594078 = ref object of OpenApiRestCall_593425
proc url_AlertsGetSummary_594080(protocol: Scheme; host: string; base: string;
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

proc validate_AlertsGetSummary_594079(path: JsonNode; query: JsonNode;
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
  var valid_594081 = path.getOrDefault("scope")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "scope", valid_594081
  result.add "path", section
  ## parameters in `query` object:
  ##   timeRange: JString
  ##            : Filter by time range by below listed values. Default value is 1 day.
  ##   api-version: JString (required)
  ##              : API version.
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
  ##          : This parameter allows the result set to be grouped by input fields. For example, groupby=severity,alertstate.
  ##   monitorService: JString
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   alertRule: JString
  ##            : Filter by specific alert rule.  Default value is to select all.
  ##   alertState: JString
  ##             : Filter by state of the alert instance. Default value is to select all.
  section = newJObject()
  var valid_594082 = query.getOrDefault("timeRange")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = newJString("1h"))
  if valid_594082 != nil:
    section.add "timeRange", valid_594082
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594083 = query.getOrDefault("api-version")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = newJString("2018-05-05"))
  if valid_594083 != nil:
    section.add "api-version", valid_594083
  var valid_594084 = query.getOrDefault("targetResource")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "targetResource", valid_594084
  var valid_594085 = query.getOrDefault("customTimeRange")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "customTimeRange", valid_594085
  var valid_594086 = query.getOrDefault("targetResourceGroup")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "targetResourceGroup", valid_594086
  var valid_594087 = query.getOrDefault("severity")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = newJString("Sev0"))
  if valid_594087 != nil:
    section.add "severity", valid_594087
  var valid_594088 = query.getOrDefault("includeSmartGroupsCount")
  valid_594088 = validateParameter(valid_594088, JBool, required = false, default = nil)
  if valid_594088 != nil:
    section.add "includeSmartGroupsCount", valid_594088
  var valid_594089 = query.getOrDefault("monitorCondition")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = newJString("Fired"))
  if valid_594089 != nil:
    section.add "monitorCondition", valid_594089
  var valid_594090 = query.getOrDefault("targetResourceType")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "targetResourceType", valid_594090
  var valid_594091 = query.getOrDefault("groupby")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = newJString("severity"))
  if valid_594091 != nil:
    section.add "groupby", valid_594091
  var valid_594092 = query.getOrDefault("monitorService")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = newJString("Application Insights"))
  if valid_594092 != nil:
    section.add "monitorService", valid_594092
  var valid_594093 = query.getOrDefault("alertRule")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "alertRule", valid_594093
  var valid_594094 = query.getOrDefault("alertState")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = newJString("New"))
  if valid_594094 != nil:
    section.add "alertState", valid_594094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594095: Call_AlertsGetSummary_594078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a summarized count of your alerts grouped by various parameters (e.g. grouping by 'Severity' returns the count of alerts for each severity).
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_AlertsGetSummary_594078; scope: string;
          timeRange: string = "1h"; apiVersion: string = "2018-05-05";
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
  ##             : API version.
  ##   targetResource: string
  ##                 : Filter by target resource( which is full ARM ID) Default value is select all.
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
  ##          : This parameter allows the result set to be grouped by input fields. For example, groupby=severity,alertstate.
  ##   monitorService: string
  ##                 : Filter by monitor service which generates the alert instance. Default value is select all.
  ##   alertRule: string
  ##            : Filter by specific alert rule.  Default value is to select all.
  ##   scope: string (required)
  ##        : scope here is resourceId for which alert is created.
  ##   alertState: string
  ##             : Filter by state of the alert instance. Default value is to select all.
  var path_594097 = newJObject()
  var query_594098 = newJObject()
  add(query_594098, "timeRange", newJString(timeRange))
  add(query_594098, "api-version", newJString(apiVersion))
  add(query_594098, "targetResource", newJString(targetResource))
  add(query_594098, "customTimeRange", newJString(customTimeRange))
  add(query_594098, "targetResourceGroup", newJString(targetResourceGroup))
  add(query_594098, "severity", newJString(severity))
  add(query_594098, "includeSmartGroupsCount", newJBool(includeSmartGroupsCount))
  add(query_594098, "monitorCondition", newJString(monitorCondition))
  add(query_594098, "targetResourceType", newJString(targetResourceType))
  add(query_594098, "groupby", newJString(groupby))
  add(query_594098, "monitorService", newJString(monitorService))
  add(query_594098, "alertRule", newJString(alertRule))
  add(path_594097, "scope", newJString(scope))
  add(query_594098, "alertState", newJString(alertState))
  result = call_594096.call(path_594097, query_594098, nil, nil, nil)

var alertsGetSummary* = Call_AlertsGetSummary_594078(name: "alertsGetSummary",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.AlertsManagement/alertsSummary",
    validator: validate_AlertsGetSummary_594079, base: "",
    url: url_AlertsGetSummary_594080, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
