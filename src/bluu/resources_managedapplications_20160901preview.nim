
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ManagedApplicationClient
## version: 2016-09-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## ARM managed applications (appliances)
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
  macServiceName = "resources-managedapplications"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ListOperations_593647 = ref object of OpenApiRestCall_593425
proc url_ListOperations_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListOperations_593648(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Microsoft.Solutions REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "api-version", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593831: Call_ListOperations_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Solutions REST API operations.
  ## 
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_ListOperations_593647; apiVersion: string): Recallable =
  ## listOperations
  ## Lists all of the available Microsoft.Solutions REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  result = call_593902.call(nil, query_593903, nil, nil, nil)

var listOperations* = Call_ListOperations_593647(name: "listOperations",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Solutions/operations",
    validator: validate_ListOperations_593648, base: "", url: url_ListOperations_593649,
    schemes: {Scheme.Https})
type
  Call_AppliancesListBySubscription_593943 = ref object of OpenApiRestCall_593425
proc url_AppliancesListBySubscription_593945(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Solutions/appliances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppliancesListBySubscription_593944(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the appliances within a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593960 = path.getOrDefault("subscriptionId")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "subscriptionId", valid_593960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_AppliancesListBySubscription_593943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the appliances within a subscription.
  ## 
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_AppliancesListBySubscription_593943;
          apiVersion: string; subscriptionId: string): Recallable =
  ## appliancesListBySubscription
  ## Gets all the appliances within a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_593964 = newJObject()
  var query_593965 = newJObject()
  add(query_593965, "api-version", newJString(apiVersion))
  add(path_593964, "subscriptionId", newJString(subscriptionId))
  result = call_593963.call(path_593964, query_593965, nil, nil, nil)

var appliancesListBySubscription* = Call_AppliancesListBySubscription_593943(
    name: "appliancesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Solutions/appliances",
    validator: validate_AppliancesListBySubscription_593944, base: "",
    url: url_AppliancesListBySubscription_593945, schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsListByResourceGroup_593966 = ref object of OpenApiRestCall_593425
proc url_ApplianceDefinitionsListByResourceGroup_593968(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.Solutions/applianceDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplianceDefinitionsListByResourceGroup_593967(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the appliance definitions in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593969 = path.getOrDefault("resourceGroupName")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "resourceGroupName", valid_593969
  var valid_593970 = path.getOrDefault("subscriptionId")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "subscriptionId", valid_593970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_ApplianceDefinitionsListByResourceGroup_593966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the appliance definitions in a resource group.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_ApplianceDefinitionsListByResourceGroup_593966;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## applianceDefinitionsListByResourceGroup
  ## Lists the appliance definitions in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  add(path_593974, "resourceGroupName", newJString(resourceGroupName))
  add(query_593975, "api-version", newJString(apiVersion))
  add(path_593974, "subscriptionId", newJString(subscriptionId))
  result = call_593973.call(path_593974, query_593975, nil, nil, nil)

var applianceDefinitionsListByResourceGroup* = Call_ApplianceDefinitionsListByResourceGroup_593966(
    name: "applianceDefinitionsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applianceDefinitions",
    validator: validate_ApplianceDefinitionsListByResourceGroup_593967, base: "",
    url: url_ApplianceDefinitionsListByResourceGroup_593968,
    schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsCreateOrUpdate_593987 = ref object of OpenApiRestCall_593425
proc url_ApplianceDefinitionsCreateOrUpdate_593989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applianceDefinitionName" in path,
        "`applianceDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Solutions/applianceDefinitions/"),
               (kind: VariableSegment, value: "applianceDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplianceDefinitionsCreateOrUpdate_593988(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new appliance definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applianceDefinitionName: JString (required)
  ##                          : The name of the appliance definition.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594007 = path.getOrDefault("resourceGroupName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "resourceGroupName", valid_594007
  var valid_594008 = path.getOrDefault("applianceDefinitionName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "applianceDefinitionName", valid_594008
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "api-version", valid_594010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update an appliance definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594012: Call_ApplianceDefinitionsCreateOrUpdate_593987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new appliance definition.
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_ApplianceDefinitionsCreateOrUpdate_593987;
          resourceGroupName: string; applianceDefinitionName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## applianceDefinitionsCreateOrUpdate
  ## Creates a new appliance definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applianceDefinitionName: string (required)
  ##                          : The name of the appliance definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update an appliance definition.
  var path_594014 = newJObject()
  var query_594015 = newJObject()
  var body_594016 = newJObject()
  add(path_594014, "resourceGroupName", newJString(resourceGroupName))
  add(path_594014, "applianceDefinitionName", newJString(applianceDefinitionName))
  add(query_594015, "api-version", newJString(apiVersion))
  add(path_594014, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594016 = parameters
  result = call_594013.call(path_594014, query_594015, nil, nil, body_594016)

var applianceDefinitionsCreateOrUpdate* = Call_ApplianceDefinitionsCreateOrUpdate_593987(
    name: "applianceDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applianceDefinitions/{applianceDefinitionName}",
    validator: validate_ApplianceDefinitionsCreateOrUpdate_593988, base: "",
    url: url_ApplianceDefinitionsCreateOrUpdate_593989, schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsGet_593976 = ref object of OpenApiRestCall_593425
proc url_ApplianceDefinitionsGet_593978(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applianceDefinitionName" in path,
        "`applianceDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Solutions/applianceDefinitions/"),
               (kind: VariableSegment, value: "applianceDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplianceDefinitionsGet_593977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the appliance definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applianceDefinitionName: JString (required)
  ##                          : The name of the appliance definition.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593979 = path.getOrDefault("resourceGroupName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "resourceGroupName", valid_593979
  var valid_593980 = path.getOrDefault("applianceDefinitionName")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "applianceDefinitionName", valid_593980
  var valid_593981 = path.getOrDefault("subscriptionId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "subscriptionId", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_ApplianceDefinitionsGet_593976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the appliance definition.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_ApplianceDefinitionsGet_593976;
          resourceGroupName: string; applianceDefinitionName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applianceDefinitionsGet
  ## Gets the appliance definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applianceDefinitionName: string (required)
  ##                          : The name of the appliance definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  add(path_593985, "resourceGroupName", newJString(resourceGroupName))
  add(path_593985, "applianceDefinitionName", newJString(applianceDefinitionName))
  add(query_593986, "api-version", newJString(apiVersion))
  add(path_593985, "subscriptionId", newJString(subscriptionId))
  result = call_593984.call(path_593985, query_593986, nil, nil, nil)

var applianceDefinitionsGet* = Call_ApplianceDefinitionsGet_593976(
    name: "applianceDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applianceDefinitions/{applianceDefinitionName}",
    validator: validate_ApplianceDefinitionsGet_593977, base: "",
    url: url_ApplianceDefinitionsGet_593978, schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsDelete_594017 = ref object of OpenApiRestCall_593425
proc url_ApplianceDefinitionsDelete_594019(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applianceDefinitionName" in path,
        "`applianceDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Solutions/applianceDefinitions/"),
               (kind: VariableSegment, value: "applianceDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplianceDefinitionsDelete_594018(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the appliance definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applianceDefinitionName: JString (required)
  ##                          : The name of the appliance definition to delete.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594020 = path.getOrDefault("resourceGroupName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "resourceGroupName", valid_594020
  var valid_594021 = path.getOrDefault("applianceDefinitionName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "applianceDefinitionName", valid_594021
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "api-version", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_ApplianceDefinitionsDelete_594017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the appliance definition.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_ApplianceDefinitionsDelete_594017;
          resourceGroupName: string; applianceDefinitionName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applianceDefinitionsDelete
  ## Deletes the appliance definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applianceDefinitionName: string (required)
  ##                          : The name of the appliance definition to delete.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  add(path_594026, "resourceGroupName", newJString(resourceGroupName))
  add(path_594026, "applianceDefinitionName", newJString(applianceDefinitionName))
  add(query_594027, "api-version", newJString(apiVersion))
  add(path_594026, "subscriptionId", newJString(subscriptionId))
  result = call_594025.call(path_594026, query_594027, nil, nil, nil)

var applianceDefinitionsDelete* = Call_ApplianceDefinitionsDelete_594017(
    name: "applianceDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applianceDefinitions/{applianceDefinitionName}",
    validator: validate_ApplianceDefinitionsDelete_594018, base: "",
    url: url_ApplianceDefinitionsDelete_594019, schemes: {Scheme.Https})
type
  Call_AppliancesListByResourceGroup_594028 = ref object of OpenApiRestCall_593425
proc url_AppliancesListByResourceGroup_594030(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Solutions/appliances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppliancesListByResourceGroup_594029(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the appliances within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594031 = path.getOrDefault("resourceGroupName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "resourceGroupName", valid_594031
  var valid_594032 = path.getOrDefault("subscriptionId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "subscriptionId", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594034: Call_AppliancesListByResourceGroup_594028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the appliances within a resource group.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_AppliancesListByResourceGroup_594028;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## appliancesListByResourceGroup
  ## Gets all the appliances within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  add(path_594036, "resourceGroupName", newJString(resourceGroupName))
  add(query_594037, "api-version", newJString(apiVersion))
  add(path_594036, "subscriptionId", newJString(subscriptionId))
  result = call_594035.call(path_594036, query_594037, nil, nil, nil)

var appliancesListByResourceGroup* = Call_AppliancesListByResourceGroup_594028(
    name: "appliancesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/appliances",
    validator: validate_AppliancesListByResourceGroup_594029, base: "",
    url: url_AppliancesListByResourceGroup_594030, schemes: {Scheme.Https})
type
  Call_AppliancesCreateOrUpdate_594049 = ref object of OpenApiRestCall_593425
proc url_AppliancesCreateOrUpdate_594051(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applianceName" in path, "`applianceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Solutions/appliances/"),
               (kind: VariableSegment, value: "applianceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppliancesCreateOrUpdate_594050(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new appliance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   applianceName: JString (required)
  ##                : The name of the appliance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594052 = path.getOrDefault("resourceGroupName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "resourceGroupName", valid_594052
  var valid_594053 = path.getOrDefault("subscriptionId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "subscriptionId", valid_594053
  var valid_594054 = path.getOrDefault("applianceName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "applianceName", valid_594054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594055 = query.getOrDefault("api-version")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "api-version", valid_594055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update an appliance.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594057: Call_AppliancesCreateOrUpdate_594049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new appliance.
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_AppliancesCreateOrUpdate_594049;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applianceName: string; parameters: JsonNode): Recallable =
  ## appliancesCreateOrUpdate
  ## Creates a new appliance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   applianceName: string (required)
  ##                : The name of the appliance.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update an appliance.
  var path_594059 = newJObject()
  var query_594060 = newJObject()
  var body_594061 = newJObject()
  add(path_594059, "resourceGroupName", newJString(resourceGroupName))
  add(query_594060, "api-version", newJString(apiVersion))
  add(path_594059, "subscriptionId", newJString(subscriptionId))
  add(path_594059, "applianceName", newJString(applianceName))
  if parameters != nil:
    body_594061 = parameters
  result = call_594058.call(path_594059, query_594060, nil, nil, body_594061)

var appliancesCreateOrUpdate* = Call_AppliancesCreateOrUpdate_594049(
    name: "appliancesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/appliances/{applianceName}",
    validator: validate_AppliancesCreateOrUpdate_594050, base: "",
    url: url_AppliancesCreateOrUpdate_594051, schemes: {Scheme.Https})
type
  Call_AppliancesGet_594038 = ref object of OpenApiRestCall_593425
proc url_AppliancesGet_594040(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applianceName" in path, "`applianceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Solutions/appliances/"),
               (kind: VariableSegment, value: "applianceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppliancesGet_594039(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the appliance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   applianceName: JString (required)
  ##                : The name of the appliance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594041 = path.getOrDefault("resourceGroupName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "resourceGroupName", valid_594041
  var valid_594042 = path.getOrDefault("subscriptionId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "subscriptionId", valid_594042
  var valid_594043 = path.getOrDefault("applianceName")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "applianceName", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594044 = query.getOrDefault("api-version")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "api-version", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_AppliancesGet_594038; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the appliance.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_AppliancesGet_594038; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; applianceName: string): Recallable =
  ## appliancesGet
  ## Gets the appliance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   applianceName: string (required)
  ##                : The name of the appliance.
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(path_594047, "resourceGroupName", newJString(resourceGroupName))
  add(query_594048, "api-version", newJString(apiVersion))
  add(path_594047, "subscriptionId", newJString(subscriptionId))
  add(path_594047, "applianceName", newJString(applianceName))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var appliancesGet* = Call_AppliancesGet_594038(name: "appliancesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/appliances/{applianceName}",
    validator: validate_AppliancesGet_594039, base: "", url: url_AppliancesGet_594040,
    schemes: {Scheme.Https})
type
  Call_AppliancesUpdate_594073 = ref object of OpenApiRestCall_593425
proc url_AppliancesUpdate_594075(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applianceName" in path, "`applianceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Solutions/appliances/"),
               (kind: VariableSegment, value: "applianceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppliancesUpdate_594074(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates an existing appliance. The only value that can be updated via PATCH currently is the tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   applianceName: JString (required)
  ##                : The name of the appliance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594076 = path.getOrDefault("resourceGroupName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "resourceGroupName", valid_594076
  var valid_594077 = path.getOrDefault("subscriptionId")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "subscriptionId", valid_594077
  var valid_594078 = path.getOrDefault("applianceName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "applianceName", valid_594078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594079 = query.getOrDefault("api-version")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "api-version", valid_594079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to update an existing appliance.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594081: Call_AppliancesUpdate_594073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing appliance. The only value that can be updated via PATCH currently is the tags.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_AppliancesUpdate_594073; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; applianceName: string;
          parameters: JsonNode = nil): Recallable =
  ## appliancesUpdate
  ## Updates an existing appliance. The only value that can be updated via PATCH currently is the tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   applianceName: string (required)
  ##                : The name of the appliance.
  ##   parameters: JObject
  ##             : Parameters supplied to update an existing appliance.
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  var body_594085 = newJObject()
  add(path_594083, "resourceGroupName", newJString(resourceGroupName))
  add(query_594084, "api-version", newJString(apiVersion))
  add(path_594083, "subscriptionId", newJString(subscriptionId))
  add(path_594083, "applianceName", newJString(applianceName))
  if parameters != nil:
    body_594085 = parameters
  result = call_594082.call(path_594083, query_594084, nil, nil, body_594085)

var appliancesUpdate* = Call_AppliancesUpdate_594073(name: "appliancesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/appliances/{applianceName}",
    validator: validate_AppliancesUpdate_594074, base: "",
    url: url_AppliancesUpdate_594075, schemes: {Scheme.Https})
type
  Call_AppliancesDelete_594062 = ref object of OpenApiRestCall_593425
proc url_AppliancesDelete_594064(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applianceName" in path, "`applianceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Solutions/appliances/"),
               (kind: VariableSegment, value: "applianceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppliancesDelete_594063(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the appliance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   applianceName: JString (required)
  ##                : The name of the appliance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594065 = path.getOrDefault("resourceGroupName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "resourceGroupName", valid_594065
  var valid_594066 = path.getOrDefault("subscriptionId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "subscriptionId", valid_594066
  var valid_594067 = path.getOrDefault("applianceName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "applianceName", valid_594067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594068 = query.getOrDefault("api-version")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "api-version", valid_594068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594069: Call_AppliancesDelete_594062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the appliance.
  ## 
  let valid = call_594069.validator(path, query, header, formData, body)
  let scheme = call_594069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594069.url(scheme.get, call_594069.host, call_594069.base,
                         call_594069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594069, url, valid)

proc call*(call_594070: Call_AppliancesDelete_594062; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; applianceName: string): Recallable =
  ## appliancesDelete
  ## Deletes the appliance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   applianceName: string (required)
  ##                : The name of the appliance.
  var path_594071 = newJObject()
  var query_594072 = newJObject()
  add(path_594071, "resourceGroupName", newJString(resourceGroupName))
  add(query_594072, "api-version", newJString(apiVersion))
  add(path_594071, "subscriptionId", newJString(subscriptionId))
  add(path_594071, "applianceName", newJString(applianceName))
  result = call_594070.call(path_594071, query_594072, nil, nil, nil)

var appliancesDelete* = Call_AppliancesDelete_594062(name: "appliancesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/appliances/{applianceName}",
    validator: validate_AppliancesDelete_594063, base: "",
    url: url_AppliancesDelete_594064, schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsCreateOrUpdateById_594095 = ref object of OpenApiRestCall_593425
proc url_ApplianceDefinitionsCreateOrUpdateById_594097(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applianceDefinitionId" in path,
        "`applianceDefinitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "applianceDefinitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplianceDefinitionsCreateOrUpdateById_594096(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new appliance definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applianceDefinitionId: JString (required)
  ##                        : The fully qualified ID of the appliance definition, including the appliance name and the appliance definition resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applianceDefinitions/{applianceDefinition-name}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `applianceDefinitionId` field"
  var valid_594098 = path.getOrDefault("applianceDefinitionId")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "applianceDefinitionId", valid_594098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594099 = query.getOrDefault("api-version")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "api-version", valid_594099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update an appliance definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_ApplianceDefinitionsCreateOrUpdateById_594095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new appliance definition.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_ApplianceDefinitionsCreateOrUpdateById_594095;
          apiVersion: string; parameters: JsonNode; applianceDefinitionId: string): Recallable =
  ## applianceDefinitionsCreateOrUpdateById
  ## Creates a new appliance definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update an appliance definition.
  ##   applianceDefinitionId: string (required)
  ##                        : The fully qualified ID of the appliance definition, including the appliance name and the appliance definition resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applianceDefinitions/{applianceDefinition-name}
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  var body_594105 = newJObject()
  add(query_594104, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594105 = parameters
  add(path_594103, "applianceDefinitionId", newJString(applianceDefinitionId))
  result = call_594102.call(path_594103, query_594104, nil, nil, body_594105)

var applianceDefinitionsCreateOrUpdateById* = Call_ApplianceDefinitionsCreateOrUpdateById_594095(
    name: "applianceDefinitionsCreateOrUpdateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{applianceDefinitionId}",
    validator: validate_ApplianceDefinitionsCreateOrUpdateById_594096, base: "",
    url: url_ApplianceDefinitionsCreateOrUpdateById_594097,
    schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsGetById_594086 = ref object of OpenApiRestCall_593425
proc url_ApplianceDefinitionsGetById_594088(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applianceDefinitionId" in path,
        "`applianceDefinitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "applianceDefinitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplianceDefinitionsGetById_594087(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the appliance definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applianceDefinitionId: JString (required)
  ##                        : The fully qualified ID of the appliance definition, including the appliance name and the appliance definition resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applianceDefinitions/{applianceDefinition-name}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `applianceDefinitionId` field"
  var valid_594089 = path.getOrDefault("applianceDefinitionId")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "applianceDefinitionId", valid_594089
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594090 = query.getOrDefault("api-version")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "api-version", valid_594090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594091: Call_ApplianceDefinitionsGetById_594086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the appliance definition.
  ## 
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_ApplianceDefinitionsGetById_594086;
          apiVersion: string; applianceDefinitionId: string): Recallable =
  ## applianceDefinitionsGetById
  ## Gets the appliance definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applianceDefinitionId: string (required)
  ##                        : The fully qualified ID of the appliance definition, including the appliance name and the appliance definition resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applianceDefinitions/{applianceDefinition-name}
  var path_594093 = newJObject()
  var query_594094 = newJObject()
  add(query_594094, "api-version", newJString(apiVersion))
  add(path_594093, "applianceDefinitionId", newJString(applianceDefinitionId))
  result = call_594092.call(path_594093, query_594094, nil, nil, nil)

var applianceDefinitionsGetById* = Call_ApplianceDefinitionsGetById_594086(
    name: "applianceDefinitionsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{applianceDefinitionId}",
    validator: validate_ApplianceDefinitionsGetById_594087, base: "",
    url: url_ApplianceDefinitionsGetById_594088, schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsDeleteById_594106 = ref object of OpenApiRestCall_593425
proc url_ApplianceDefinitionsDeleteById_594108(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applianceDefinitionId" in path,
        "`applianceDefinitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "applianceDefinitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplianceDefinitionsDeleteById_594107(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the appliance definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applianceDefinitionId: JString (required)
  ##                        : The fully qualified ID of the appliance definition, including the appliance name and the appliance definition resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applianceDefinitions/{applianceDefinition-name}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `applianceDefinitionId` field"
  var valid_594109 = path.getOrDefault("applianceDefinitionId")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "applianceDefinitionId", valid_594109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594110 = query.getOrDefault("api-version")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "api-version", valid_594110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594111: Call_ApplianceDefinitionsDeleteById_594106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the appliance definition.
  ## 
  let valid = call_594111.validator(path, query, header, formData, body)
  let scheme = call_594111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594111.url(scheme.get, call_594111.host, call_594111.base,
                         call_594111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594111, url, valid)

proc call*(call_594112: Call_ApplianceDefinitionsDeleteById_594106;
          apiVersion: string; applianceDefinitionId: string): Recallable =
  ## applianceDefinitionsDeleteById
  ## Deletes the appliance definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applianceDefinitionId: string (required)
  ##                        : The fully qualified ID of the appliance definition, including the appliance name and the appliance definition resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applianceDefinitions/{applianceDefinition-name}
  var path_594113 = newJObject()
  var query_594114 = newJObject()
  add(query_594114, "api-version", newJString(apiVersion))
  add(path_594113, "applianceDefinitionId", newJString(applianceDefinitionId))
  result = call_594112.call(path_594113, query_594114, nil, nil, nil)

var applianceDefinitionsDeleteById* = Call_ApplianceDefinitionsDeleteById_594106(
    name: "applianceDefinitionsDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{applianceDefinitionId}",
    validator: validate_ApplianceDefinitionsDeleteById_594107, base: "",
    url: url_ApplianceDefinitionsDeleteById_594108, schemes: {Scheme.Https})
type
  Call_AppliancesCreateOrUpdateById_594124 = ref object of OpenApiRestCall_593425
proc url_AppliancesCreateOrUpdateById_594126(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applianceId" in path, "`applianceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "applianceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppliancesCreateOrUpdateById_594125(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new appliance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applianceId: JString (required)
  ##              : The fully qualified ID of the appliance, including the appliance name and the appliance resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/appliances/{appliance-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applianceId` field"
  var valid_594127 = path.getOrDefault("applianceId")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "applianceId", valid_594127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594128 = query.getOrDefault("api-version")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "api-version", valid_594128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update an appliance.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594130: Call_AppliancesCreateOrUpdateById_594124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new appliance.
  ## 
  let valid = call_594130.validator(path, query, header, formData, body)
  let scheme = call_594130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594130.url(scheme.get, call_594130.host, call_594130.base,
                         call_594130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594130, url, valid)

proc call*(call_594131: Call_AppliancesCreateOrUpdateById_594124;
          apiVersion: string; applianceId: string; parameters: JsonNode): Recallable =
  ## appliancesCreateOrUpdateById
  ## Creates a new appliance.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applianceId: string (required)
  ##              : The fully qualified ID of the appliance, including the appliance name and the appliance resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/appliances/{appliance-name}
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update an appliance.
  var path_594132 = newJObject()
  var query_594133 = newJObject()
  var body_594134 = newJObject()
  add(query_594133, "api-version", newJString(apiVersion))
  add(path_594132, "applianceId", newJString(applianceId))
  if parameters != nil:
    body_594134 = parameters
  result = call_594131.call(path_594132, query_594133, nil, nil, body_594134)

var appliancesCreateOrUpdateById* = Call_AppliancesCreateOrUpdateById_594124(
    name: "appliancesCreateOrUpdateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{applianceId}",
    validator: validate_AppliancesCreateOrUpdateById_594125, base: "",
    url: url_AppliancesCreateOrUpdateById_594126, schemes: {Scheme.Https})
type
  Call_AppliancesGetById_594115 = ref object of OpenApiRestCall_593425
proc url_AppliancesGetById_594117(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applianceId" in path, "`applianceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "applianceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppliancesGetById_594116(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the appliance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applianceId: JString (required)
  ##              : The fully qualified ID of the appliance, including the appliance name and the appliance resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/appliances/{appliance-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applianceId` field"
  var valid_594118 = path.getOrDefault("applianceId")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "applianceId", valid_594118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594119 = query.getOrDefault("api-version")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "api-version", valid_594119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594120: Call_AppliancesGetById_594115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the appliance.
  ## 
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_AppliancesGetById_594115; apiVersion: string;
          applianceId: string): Recallable =
  ## appliancesGetById
  ## Gets the appliance.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applianceId: string (required)
  ##              : The fully qualified ID of the appliance, including the appliance name and the appliance resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/appliances/{appliance-name}
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  add(query_594123, "api-version", newJString(apiVersion))
  add(path_594122, "applianceId", newJString(applianceId))
  result = call_594121.call(path_594122, query_594123, nil, nil, nil)

var appliancesGetById* = Call_AppliancesGetById_594115(name: "appliancesGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{applianceId}",
    validator: validate_AppliancesGetById_594116, base: "",
    url: url_AppliancesGetById_594117, schemes: {Scheme.Https})
type
  Call_AppliancesUpdateById_594144 = ref object of OpenApiRestCall_593425
proc url_AppliancesUpdateById_594146(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applianceId" in path, "`applianceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "applianceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppliancesUpdateById_594145(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing appliance. The only value that can be updated via PATCH currently is the tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applianceId: JString (required)
  ##              : The fully qualified ID of the appliance, including the appliance name and the appliance resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/appliances/{appliance-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applianceId` field"
  var valid_594147 = path.getOrDefault("applianceId")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "applianceId", valid_594147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594148 = query.getOrDefault("api-version")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "api-version", valid_594148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to update an existing appliance.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594150: Call_AppliancesUpdateById_594144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing appliance. The only value that can be updated via PATCH currently is the tags.
  ## 
  let valid = call_594150.validator(path, query, header, formData, body)
  let scheme = call_594150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594150.url(scheme.get, call_594150.host, call_594150.base,
                         call_594150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594150, url, valid)

proc call*(call_594151: Call_AppliancesUpdateById_594144; apiVersion: string;
          applianceId: string; parameters: JsonNode = nil): Recallable =
  ## appliancesUpdateById
  ## Updates an existing appliance. The only value that can be updated via PATCH currently is the tags.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applianceId: string (required)
  ##              : The fully qualified ID of the appliance, including the appliance name and the appliance resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/appliances/{appliance-name}
  ##   parameters: JObject
  ##             : Parameters supplied to update an existing appliance.
  var path_594152 = newJObject()
  var query_594153 = newJObject()
  var body_594154 = newJObject()
  add(query_594153, "api-version", newJString(apiVersion))
  add(path_594152, "applianceId", newJString(applianceId))
  if parameters != nil:
    body_594154 = parameters
  result = call_594151.call(path_594152, query_594153, nil, nil, body_594154)

var appliancesUpdateById* = Call_AppliancesUpdateById_594144(
    name: "appliancesUpdateById", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{applianceId}",
    validator: validate_AppliancesUpdateById_594145, base: "",
    url: url_AppliancesUpdateById_594146, schemes: {Scheme.Https})
type
  Call_AppliancesDeleteById_594135 = ref object of OpenApiRestCall_593425
proc url_AppliancesDeleteById_594137(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applianceId" in path, "`applianceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "applianceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppliancesDeleteById_594136(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the appliance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applianceId: JString (required)
  ##              : The fully qualified ID of the appliance, including the appliance name and the appliance resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/appliances/{appliance-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applianceId` field"
  var valid_594138 = path.getOrDefault("applianceId")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "applianceId", valid_594138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594139 = query.getOrDefault("api-version")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "api-version", valid_594139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594140: Call_AppliancesDeleteById_594135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the appliance.
  ## 
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_AppliancesDeleteById_594135; apiVersion: string;
          applianceId: string): Recallable =
  ## appliancesDeleteById
  ## Deletes the appliance.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applianceId: string (required)
  ##              : The fully qualified ID of the appliance, including the appliance name and the appliance resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/appliances/{appliance-name}
  var path_594142 = newJObject()
  var query_594143 = newJObject()
  add(query_594143, "api-version", newJString(apiVersion))
  add(path_594142, "applianceId", newJString(applianceId))
  result = call_594141.call(path_594142, query_594143, nil, nil, nil)

var appliancesDeleteById* = Call_AppliancesDeleteById_594135(
    name: "appliancesDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{applianceId}",
    validator: validate_AppliancesDeleteById_594136, base: "",
    url: url_AppliancesDeleteById_594137, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
