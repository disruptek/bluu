
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "resources-managedapplications"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ListOperations_567880 = ref object of OpenApiRestCall_567658
proc url_ListOperations_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListOperations_567881(path: JsonNode; query: JsonNode;
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
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_ListOperations_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Solutions REST API operations.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_ListOperations_567880; apiVersion: string): Recallable =
  ## listOperations
  ## Lists all of the available Microsoft.Solutions REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var listOperations* = Call_ListOperations_567880(name: "listOperations",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Solutions/operations",
    validator: validate_ListOperations_567881, base: "", url: url_ListOperations_567882,
    schemes: {Scheme.Https})
type
  Call_AppliancesListBySubscription_568176 = ref object of OpenApiRestCall_567658
proc url_AppliancesListBySubscription_568178(protocol: Scheme; host: string;
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

proc validate_AppliancesListBySubscription_568177(path: JsonNode; query: JsonNode;
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
  var valid_568193 = path.getOrDefault("subscriptionId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "subscriptionId", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568194 = query.getOrDefault("api-version")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "api-version", valid_568194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568195: Call_AppliancesListBySubscription_568176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the appliances within a subscription.
  ## 
  let valid = call_568195.validator(path, query, header, formData, body)
  let scheme = call_568195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568195.url(scheme.get, call_568195.host, call_568195.base,
                         call_568195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568195, url, valid)

proc call*(call_568196: Call_AppliancesListBySubscription_568176;
          apiVersion: string; subscriptionId: string): Recallable =
  ## appliancesListBySubscription
  ## Gets all the appliances within a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568197 = newJObject()
  var query_568198 = newJObject()
  add(query_568198, "api-version", newJString(apiVersion))
  add(path_568197, "subscriptionId", newJString(subscriptionId))
  result = call_568196.call(path_568197, query_568198, nil, nil, nil)

var appliancesListBySubscription* = Call_AppliancesListBySubscription_568176(
    name: "appliancesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Solutions/appliances",
    validator: validate_AppliancesListBySubscription_568177, base: "",
    url: url_AppliancesListBySubscription_568178, schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsListByResourceGroup_568199 = ref object of OpenApiRestCall_567658
proc url_ApplianceDefinitionsListByResourceGroup_568201(protocol: Scheme;
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

proc validate_ApplianceDefinitionsListByResourceGroup_568200(path: JsonNode;
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
  var valid_568202 = path.getOrDefault("resourceGroupName")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "resourceGroupName", valid_568202
  var valid_568203 = path.getOrDefault("subscriptionId")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "subscriptionId", valid_568203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "api-version", valid_568204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568205: Call_ApplianceDefinitionsListByResourceGroup_568199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the appliance definitions in a resource group.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_ApplianceDefinitionsListByResourceGroup_568199;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## applianceDefinitionsListByResourceGroup
  ## Lists the appliance definitions in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568207 = newJObject()
  var query_568208 = newJObject()
  add(path_568207, "resourceGroupName", newJString(resourceGroupName))
  add(query_568208, "api-version", newJString(apiVersion))
  add(path_568207, "subscriptionId", newJString(subscriptionId))
  result = call_568206.call(path_568207, query_568208, nil, nil, nil)

var applianceDefinitionsListByResourceGroup* = Call_ApplianceDefinitionsListByResourceGroup_568199(
    name: "applianceDefinitionsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applianceDefinitions",
    validator: validate_ApplianceDefinitionsListByResourceGroup_568200, base: "",
    url: url_ApplianceDefinitionsListByResourceGroup_568201,
    schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsCreateOrUpdate_568220 = ref object of OpenApiRestCall_567658
proc url_ApplianceDefinitionsCreateOrUpdate_568222(protocol: Scheme; host: string;
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

proc validate_ApplianceDefinitionsCreateOrUpdate_568221(path: JsonNode;
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
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("applianceDefinitionName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "applianceDefinitionName", valid_568241
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
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

proc call*(call_568245: Call_ApplianceDefinitionsCreateOrUpdate_568220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new appliance definition.
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_ApplianceDefinitionsCreateOrUpdate_568220;
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
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  var body_568249 = newJObject()
  add(path_568247, "resourceGroupName", newJString(resourceGroupName))
  add(path_568247, "applianceDefinitionName", newJString(applianceDefinitionName))
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568249 = parameters
  result = call_568246.call(path_568247, query_568248, nil, nil, body_568249)

var applianceDefinitionsCreateOrUpdate* = Call_ApplianceDefinitionsCreateOrUpdate_568220(
    name: "applianceDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applianceDefinitions/{applianceDefinitionName}",
    validator: validate_ApplianceDefinitionsCreateOrUpdate_568221, base: "",
    url: url_ApplianceDefinitionsCreateOrUpdate_568222, schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsGet_568209 = ref object of OpenApiRestCall_567658
proc url_ApplianceDefinitionsGet_568211(protocol: Scheme; host: string; base: string;
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

proc validate_ApplianceDefinitionsGet_568210(path: JsonNode; query: JsonNode;
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
  var valid_568212 = path.getOrDefault("resourceGroupName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "resourceGroupName", valid_568212
  var valid_568213 = path.getOrDefault("applianceDefinitionName")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "applianceDefinitionName", valid_568213
  var valid_568214 = path.getOrDefault("subscriptionId")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "subscriptionId", valid_568214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568215 = query.getOrDefault("api-version")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "api-version", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_ApplianceDefinitionsGet_568209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the appliance definition.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_ApplianceDefinitionsGet_568209;
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
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  add(path_568218, "resourceGroupName", newJString(resourceGroupName))
  add(path_568218, "applianceDefinitionName", newJString(applianceDefinitionName))
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "subscriptionId", newJString(subscriptionId))
  result = call_568217.call(path_568218, query_568219, nil, nil, nil)

var applianceDefinitionsGet* = Call_ApplianceDefinitionsGet_568209(
    name: "applianceDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applianceDefinitions/{applianceDefinitionName}",
    validator: validate_ApplianceDefinitionsGet_568210, base: "",
    url: url_ApplianceDefinitionsGet_568211, schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsDelete_568250 = ref object of OpenApiRestCall_567658
proc url_ApplianceDefinitionsDelete_568252(protocol: Scheme; host: string;
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

proc validate_ApplianceDefinitionsDelete_568251(path: JsonNode; query: JsonNode;
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
  var valid_568253 = path.getOrDefault("resourceGroupName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "resourceGroupName", valid_568253
  var valid_568254 = path.getOrDefault("applianceDefinitionName")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "applianceDefinitionName", valid_568254
  var valid_568255 = path.getOrDefault("subscriptionId")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "subscriptionId", valid_568255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568256 = query.getOrDefault("api-version")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "api-version", valid_568256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568257: Call_ApplianceDefinitionsDelete_568250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the appliance definition.
  ## 
  let valid = call_568257.validator(path, query, header, formData, body)
  let scheme = call_568257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568257.url(scheme.get, call_568257.host, call_568257.base,
                         call_568257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568257, url, valid)

proc call*(call_568258: Call_ApplianceDefinitionsDelete_568250;
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
  var path_568259 = newJObject()
  var query_568260 = newJObject()
  add(path_568259, "resourceGroupName", newJString(resourceGroupName))
  add(path_568259, "applianceDefinitionName", newJString(applianceDefinitionName))
  add(query_568260, "api-version", newJString(apiVersion))
  add(path_568259, "subscriptionId", newJString(subscriptionId))
  result = call_568258.call(path_568259, query_568260, nil, nil, nil)

var applianceDefinitionsDelete* = Call_ApplianceDefinitionsDelete_568250(
    name: "applianceDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applianceDefinitions/{applianceDefinitionName}",
    validator: validate_ApplianceDefinitionsDelete_568251, base: "",
    url: url_ApplianceDefinitionsDelete_568252, schemes: {Scheme.Https})
type
  Call_AppliancesListByResourceGroup_568261 = ref object of OpenApiRestCall_567658
proc url_AppliancesListByResourceGroup_568263(protocol: Scheme; host: string;
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

proc validate_AppliancesListByResourceGroup_568262(path: JsonNode; query: JsonNode;
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
  var valid_568264 = path.getOrDefault("resourceGroupName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceGroupName", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "api-version", valid_568266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568267: Call_AppliancesListByResourceGroup_568261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the appliances within a resource group.
  ## 
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_AppliancesListByResourceGroup_568261;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## appliancesListByResourceGroup
  ## Gets all the appliances within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568269 = newJObject()
  var query_568270 = newJObject()
  add(path_568269, "resourceGroupName", newJString(resourceGroupName))
  add(query_568270, "api-version", newJString(apiVersion))
  add(path_568269, "subscriptionId", newJString(subscriptionId))
  result = call_568268.call(path_568269, query_568270, nil, nil, nil)

var appliancesListByResourceGroup* = Call_AppliancesListByResourceGroup_568261(
    name: "appliancesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/appliances",
    validator: validate_AppliancesListByResourceGroup_568262, base: "",
    url: url_AppliancesListByResourceGroup_568263, schemes: {Scheme.Https})
type
  Call_AppliancesCreateOrUpdate_568282 = ref object of OpenApiRestCall_567658
proc url_AppliancesCreateOrUpdate_568284(protocol: Scheme; host: string;
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

proc validate_AppliancesCreateOrUpdate_568283(path: JsonNode; query: JsonNode;
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
  var valid_568285 = path.getOrDefault("resourceGroupName")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "resourceGroupName", valid_568285
  var valid_568286 = path.getOrDefault("subscriptionId")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "subscriptionId", valid_568286
  var valid_568287 = path.getOrDefault("applianceName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "applianceName", valid_568287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568288 = query.getOrDefault("api-version")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "api-version", valid_568288
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

proc call*(call_568290: Call_AppliancesCreateOrUpdate_568282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new appliance.
  ## 
  let valid = call_568290.validator(path, query, header, formData, body)
  let scheme = call_568290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568290.url(scheme.get, call_568290.host, call_568290.base,
                         call_568290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568290, url, valid)

proc call*(call_568291: Call_AppliancesCreateOrUpdate_568282;
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
  var path_568292 = newJObject()
  var query_568293 = newJObject()
  var body_568294 = newJObject()
  add(path_568292, "resourceGroupName", newJString(resourceGroupName))
  add(query_568293, "api-version", newJString(apiVersion))
  add(path_568292, "subscriptionId", newJString(subscriptionId))
  add(path_568292, "applianceName", newJString(applianceName))
  if parameters != nil:
    body_568294 = parameters
  result = call_568291.call(path_568292, query_568293, nil, nil, body_568294)

var appliancesCreateOrUpdate* = Call_AppliancesCreateOrUpdate_568282(
    name: "appliancesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/appliances/{applianceName}",
    validator: validate_AppliancesCreateOrUpdate_568283, base: "",
    url: url_AppliancesCreateOrUpdate_568284, schemes: {Scheme.Https})
type
  Call_AppliancesGet_568271 = ref object of OpenApiRestCall_567658
proc url_AppliancesGet_568273(protocol: Scheme; host: string; base: string;
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

proc validate_AppliancesGet_568272(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568274 = path.getOrDefault("resourceGroupName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "resourceGroupName", valid_568274
  var valid_568275 = path.getOrDefault("subscriptionId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "subscriptionId", valid_568275
  var valid_568276 = path.getOrDefault("applianceName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "applianceName", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_AppliancesGet_568271; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the appliance.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_AppliancesGet_568271; resourceGroupName: string;
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
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  add(path_568280, "resourceGroupName", newJString(resourceGroupName))
  add(query_568281, "api-version", newJString(apiVersion))
  add(path_568280, "subscriptionId", newJString(subscriptionId))
  add(path_568280, "applianceName", newJString(applianceName))
  result = call_568279.call(path_568280, query_568281, nil, nil, nil)

var appliancesGet* = Call_AppliancesGet_568271(name: "appliancesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/appliances/{applianceName}",
    validator: validate_AppliancesGet_568272, base: "", url: url_AppliancesGet_568273,
    schemes: {Scheme.Https})
type
  Call_AppliancesUpdate_568306 = ref object of OpenApiRestCall_567658
proc url_AppliancesUpdate_568308(protocol: Scheme; host: string; base: string;
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

proc validate_AppliancesUpdate_568307(path: JsonNode; query: JsonNode;
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
  var valid_568309 = path.getOrDefault("resourceGroupName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "resourceGroupName", valid_568309
  var valid_568310 = path.getOrDefault("subscriptionId")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "subscriptionId", valid_568310
  var valid_568311 = path.getOrDefault("applianceName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "applianceName", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "api-version", valid_568312
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

proc call*(call_568314: Call_AppliancesUpdate_568306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing appliance. The only value that can be updated via PATCH currently is the tags.
  ## 
  let valid = call_568314.validator(path, query, header, formData, body)
  let scheme = call_568314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568314.url(scheme.get, call_568314.host, call_568314.base,
                         call_568314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568314, url, valid)

proc call*(call_568315: Call_AppliancesUpdate_568306; resourceGroupName: string;
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
  var path_568316 = newJObject()
  var query_568317 = newJObject()
  var body_568318 = newJObject()
  add(path_568316, "resourceGroupName", newJString(resourceGroupName))
  add(query_568317, "api-version", newJString(apiVersion))
  add(path_568316, "subscriptionId", newJString(subscriptionId))
  add(path_568316, "applianceName", newJString(applianceName))
  if parameters != nil:
    body_568318 = parameters
  result = call_568315.call(path_568316, query_568317, nil, nil, body_568318)

var appliancesUpdate* = Call_AppliancesUpdate_568306(name: "appliancesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/appliances/{applianceName}",
    validator: validate_AppliancesUpdate_568307, base: "",
    url: url_AppliancesUpdate_568308, schemes: {Scheme.Https})
type
  Call_AppliancesDelete_568295 = ref object of OpenApiRestCall_567658
proc url_AppliancesDelete_568297(protocol: Scheme; host: string; base: string;
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

proc validate_AppliancesDelete_568296(path: JsonNode; query: JsonNode;
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
  var valid_568298 = path.getOrDefault("resourceGroupName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "resourceGroupName", valid_568298
  var valid_568299 = path.getOrDefault("subscriptionId")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "subscriptionId", valid_568299
  var valid_568300 = path.getOrDefault("applianceName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "applianceName", valid_568300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568302: Call_AppliancesDelete_568295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the appliance.
  ## 
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_AppliancesDelete_568295; resourceGroupName: string;
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
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  add(path_568304, "resourceGroupName", newJString(resourceGroupName))
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "subscriptionId", newJString(subscriptionId))
  add(path_568304, "applianceName", newJString(applianceName))
  result = call_568303.call(path_568304, query_568305, nil, nil, nil)

var appliancesDelete* = Call_AppliancesDelete_568295(name: "appliancesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/appliances/{applianceName}",
    validator: validate_AppliancesDelete_568296, base: "",
    url: url_AppliancesDelete_568297, schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsCreateOrUpdateById_568328 = ref object of OpenApiRestCall_567658
proc url_ApplianceDefinitionsCreateOrUpdateById_568330(protocol: Scheme;
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

proc validate_ApplianceDefinitionsCreateOrUpdateById_568329(path: JsonNode;
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
  var valid_568331 = path.getOrDefault("applianceDefinitionId")
  valid_568331 = validateParameter(valid_568331, JString, required = true,
                                 default = nil)
  if valid_568331 != nil:
    section.add "applianceDefinitionId", valid_568331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "api-version", valid_568332
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

proc call*(call_568334: Call_ApplianceDefinitionsCreateOrUpdateById_568328;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new appliance definition.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_ApplianceDefinitionsCreateOrUpdateById_568328;
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
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  var body_568338 = newJObject()
  add(query_568337, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568338 = parameters
  add(path_568336, "applianceDefinitionId", newJString(applianceDefinitionId))
  result = call_568335.call(path_568336, query_568337, nil, nil, body_568338)

var applianceDefinitionsCreateOrUpdateById* = Call_ApplianceDefinitionsCreateOrUpdateById_568328(
    name: "applianceDefinitionsCreateOrUpdateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{applianceDefinitionId}",
    validator: validate_ApplianceDefinitionsCreateOrUpdateById_568329, base: "",
    url: url_ApplianceDefinitionsCreateOrUpdateById_568330,
    schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsGetById_568319 = ref object of OpenApiRestCall_567658
proc url_ApplianceDefinitionsGetById_568321(protocol: Scheme; host: string;
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

proc validate_ApplianceDefinitionsGetById_568320(path: JsonNode; query: JsonNode;
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
  var valid_568322 = path.getOrDefault("applianceDefinitionId")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "applianceDefinitionId", valid_568322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568323 = query.getOrDefault("api-version")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "api-version", valid_568323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568324: Call_ApplianceDefinitionsGetById_568319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the appliance definition.
  ## 
  let valid = call_568324.validator(path, query, header, formData, body)
  let scheme = call_568324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568324.url(scheme.get, call_568324.host, call_568324.base,
                         call_568324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568324, url, valid)

proc call*(call_568325: Call_ApplianceDefinitionsGetById_568319;
          apiVersion: string; applianceDefinitionId: string): Recallable =
  ## applianceDefinitionsGetById
  ## Gets the appliance definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applianceDefinitionId: string (required)
  ##                        : The fully qualified ID of the appliance definition, including the appliance name and the appliance definition resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applianceDefinitions/{applianceDefinition-name}
  var path_568326 = newJObject()
  var query_568327 = newJObject()
  add(query_568327, "api-version", newJString(apiVersion))
  add(path_568326, "applianceDefinitionId", newJString(applianceDefinitionId))
  result = call_568325.call(path_568326, query_568327, nil, nil, nil)

var applianceDefinitionsGetById* = Call_ApplianceDefinitionsGetById_568319(
    name: "applianceDefinitionsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{applianceDefinitionId}",
    validator: validate_ApplianceDefinitionsGetById_568320, base: "",
    url: url_ApplianceDefinitionsGetById_568321, schemes: {Scheme.Https})
type
  Call_ApplianceDefinitionsDeleteById_568339 = ref object of OpenApiRestCall_567658
proc url_ApplianceDefinitionsDeleteById_568341(protocol: Scheme; host: string;
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

proc validate_ApplianceDefinitionsDeleteById_568340(path: JsonNode;
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
  var valid_568342 = path.getOrDefault("applianceDefinitionId")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "applianceDefinitionId", valid_568342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568343 = query.getOrDefault("api-version")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "api-version", valid_568343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568344: Call_ApplianceDefinitionsDeleteById_568339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the appliance definition.
  ## 
  let valid = call_568344.validator(path, query, header, formData, body)
  let scheme = call_568344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568344.url(scheme.get, call_568344.host, call_568344.base,
                         call_568344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568344, url, valid)

proc call*(call_568345: Call_ApplianceDefinitionsDeleteById_568339;
          apiVersion: string; applianceDefinitionId: string): Recallable =
  ## applianceDefinitionsDeleteById
  ## Deletes the appliance definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applianceDefinitionId: string (required)
  ##                        : The fully qualified ID of the appliance definition, including the appliance name and the appliance definition resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applianceDefinitions/{applianceDefinition-name}
  var path_568346 = newJObject()
  var query_568347 = newJObject()
  add(query_568347, "api-version", newJString(apiVersion))
  add(path_568346, "applianceDefinitionId", newJString(applianceDefinitionId))
  result = call_568345.call(path_568346, query_568347, nil, nil, nil)

var applianceDefinitionsDeleteById* = Call_ApplianceDefinitionsDeleteById_568339(
    name: "applianceDefinitionsDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{applianceDefinitionId}",
    validator: validate_ApplianceDefinitionsDeleteById_568340, base: "",
    url: url_ApplianceDefinitionsDeleteById_568341, schemes: {Scheme.Https})
type
  Call_AppliancesCreateOrUpdateById_568357 = ref object of OpenApiRestCall_567658
proc url_AppliancesCreateOrUpdateById_568359(protocol: Scheme; host: string;
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

proc validate_AppliancesCreateOrUpdateById_568358(path: JsonNode; query: JsonNode;
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
  var valid_568360 = path.getOrDefault("applianceId")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "applianceId", valid_568360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568361 = query.getOrDefault("api-version")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "api-version", valid_568361
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

proc call*(call_568363: Call_AppliancesCreateOrUpdateById_568357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new appliance.
  ## 
  let valid = call_568363.validator(path, query, header, formData, body)
  let scheme = call_568363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568363.url(scheme.get, call_568363.host, call_568363.base,
                         call_568363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568363, url, valid)

proc call*(call_568364: Call_AppliancesCreateOrUpdateById_568357;
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
  var path_568365 = newJObject()
  var query_568366 = newJObject()
  var body_568367 = newJObject()
  add(query_568366, "api-version", newJString(apiVersion))
  add(path_568365, "applianceId", newJString(applianceId))
  if parameters != nil:
    body_568367 = parameters
  result = call_568364.call(path_568365, query_568366, nil, nil, body_568367)

var appliancesCreateOrUpdateById* = Call_AppliancesCreateOrUpdateById_568357(
    name: "appliancesCreateOrUpdateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{applianceId}",
    validator: validate_AppliancesCreateOrUpdateById_568358, base: "",
    url: url_AppliancesCreateOrUpdateById_568359, schemes: {Scheme.Https})
type
  Call_AppliancesGetById_568348 = ref object of OpenApiRestCall_567658
proc url_AppliancesGetById_568350(protocol: Scheme; host: string; base: string;
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

proc validate_AppliancesGetById_568349(path: JsonNode; query: JsonNode;
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
  var valid_568351 = path.getOrDefault("applianceId")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "applianceId", valid_568351
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568352 = query.getOrDefault("api-version")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "api-version", valid_568352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568353: Call_AppliancesGetById_568348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the appliance.
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_AppliancesGetById_568348; apiVersion: string;
          applianceId: string): Recallable =
  ## appliancesGetById
  ## Gets the appliance.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applianceId: string (required)
  ##              : The fully qualified ID of the appliance, including the appliance name and the appliance resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/appliances/{appliance-name}
  var path_568355 = newJObject()
  var query_568356 = newJObject()
  add(query_568356, "api-version", newJString(apiVersion))
  add(path_568355, "applianceId", newJString(applianceId))
  result = call_568354.call(path_568355, query_568356, nil, nil, nil)

var appliancesGetById* = Call_AppliancesGetById_568348(name: "appliancesGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{applianceId}",
    validator: validate_AppliancesGetById_568349, base: "",
    url: url_AppliancesGetById_568350, schemes: {Scheme.Https})
type
  Call_AppliancesUpdateById_568377 = ref object of OpenApiRestCall_567658
proc url_AppliancesUpdateById_568379(protocol: Scheme; host: string; base: string;
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

proc validate_AppliancesUpdateById_568378(path: JsonNode; query: JsonNode;
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
  var valid_568380 = path.getOrDefault("applianceId")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "applianceId", valid_568380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568381 = query.getOrDefault("api-version")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "api-version", valid_568381
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

proc call*(call_568383: Call_AppliancesUpdateById_568377; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing appliance. The only value that can be updated via PATCH currently is the tags.
  ## 
  let valid = call_568383.validator(path, query, header, formData, body)
  let scheme = call_568383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568383.url(scheme.get, call_568383.host, call_568383.base,
                         call_568383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568383, url, valid)

proc call*(call_568384: Call_AppliancesUpdateById_568377; apiVersion: string;
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
  var path_568385 = newJObject()
  var query_568386 = newJObject()
  var body_568387 = newJObject()
  add(query_568386, "api-version", newJString(apiVersion))
  add(path_568385, "applianceId", newJString(applianceId))
  if parameters != nil:
    body_568387 = parameters
  result = call_568384.call(path_568385, query_568386, nil, nil, body_568387)

var appliancesUpdateById* = Call_AppliancesUpdateById_568377(
    name: "appliancesUpdateById", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{applianceId}",
    validator: validate_AppliancesUpdateById_568378, base: "",
    url: url_AppliancesUpdateById_568379, schemes: {Scheme.Https})
type
  Call_AppliancesDeleteById_568368 = ref object of OpenApiRestCall_567658
proc url_AppliancesDeleteById_568370(protocol: Scheme; host: string; base: string;
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

proc validate_AppliancesDeleteById_568369(path: JsonNode; query: JsonNode;
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
  var valid_568371 = path.getOrDefault("applianceId")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "applianceId", valid_568371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568372 = query.getOrDefault("api-version")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "api-version", valid_568372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568373: Call_AppliancesDeleteById_568368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the appliance.
  ## 
  let valid = call_568373.validator(path, query, header, formData, body)
  let scheme = call_568373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568373.url(scheme.get, call_568373.host, call_568373.base,
                         call_568373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568373, url, valid)

proc call*(call_568374: Call_AppliancesDeleteById_568368; apiVersion: string;
          applianceId: string): Recallable =
  ## appliancesDeleteById
  ## Deletes the appliance.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applianceId: string (required)
  ##              : The fully qualified ID of the appliance, including the appliance name and the appliance resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/appliances/{appliance-name}
  var path_568375 = newJObject()
  var query_568376 = newJObject()
  add(query_568376, "api-version", newJString(apiVersion))
  add(path_568375, "applianceId", newJString(applianceId))
  result = call_568374.call(path_568375, query_568376, nil, nil, nil)

var appliancesDeleteById* = Call_AppliancesDeleteById_568368(
    name: "appliancesDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{applianceId}",
    validator: validate_AppliancesDeleteById_568369, base: "",
    url: url_AppliancesDeleteById_568370, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
