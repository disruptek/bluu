
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApplicationClient
## version: 2018-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## ARM applications
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
  Call_ApplicationsListBySubscription_567880 = ref object of OpenApiRestCall_567658
proc url_ApplicationsListBySubscription_567882(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Solutions/applications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsListBySubscription_567881(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the applications within a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568055 = path.getOrDefault("subscriptionId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "subscriptionId", valid_568055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568056 = query.getOrDefault("api-version")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "api-version", valid_568056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568079: Call_ApplicationsListBySubscription_567880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the applications within a subscription.
  ## 
  let valid = call_568079.validator(path, query, header, formData, body)
  let scheme = call_568079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568079.url(scheme.get, call_568079.host, call_568079.base,
                         call_568079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568079, url, valid)

proc call*(call_568150: Call_ApplicationsListBySubscription_567880;
          apiVersion: string; subscriptionId: string): Recallable =
  ## applicationsListBySubscription
  ## Gets all the applications within a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568151 = newJObject()
  var query_568153 = newJObject()
  add(query_568153, "api-version", newJString(apiVersion))
  add(path_568151, "subscriptionId", newJString(subscriptionId))
  result = call_568150.call(path_568151, query_568153, nil, nil, nil)

var applicationsListBySubscription* = Call_ApplicationsListBySubscription_567880(
    name: "applicationsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Solutions/applications",
    validator: validate_ApplicationsListBySubscription_567881, base: "",
    url: url_ApplicationsListBySubscription_567882, schemes: {Scheme.Https})
type
  Call_ApplicationDefinitionsListByResourceGroup_568192 = ref object of OpenApiRestCall_567658
proc url_ApplicationDefinitionsListByResourceGroup_568194(protocol: Scheme;
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
        value: "/providers/Microsoft.Solutions/applicationDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationDefinitionsListByResourceGroup_568193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the managed application definitions in a resource group.
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
  var valid_568195 = path.getOrDefault("resourceGroupName")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "resourceGroupName", valid_568195
  var valid_568196 = path.getOrDefault("subscriptionId")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "subscriptionId", valid_568196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568197 = query.getOrDefault("api-version")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "api-version", valid_568197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568198: Call_ApplicationDefinitionsListByResourceGroup_568192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the managed application definitions in a resource group.
  ## 
  let valid = call_568198.validator(path, query, header, formData, body)
  let scheme = call_568198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568198.url(scheme.get, call_568198.host, call_568198.base,
                         call_568198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568198, url, valid)

proc call*(call_568199: Call_ApplicationDefinitionsListByResourceGroup_568192;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## applicationDefinitionsListByResourceGroup
  ## Lists the managed application definitions in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568200 = newJObject()
  var query_568201 = newJObject()
  add(path_568200, "resourceGroupName", newJString(resourceGroupName))
  add(query_568201, "api-version", newJString(apiVersion))
  add(path_568200, "subscriptionId", newJString(subscriptionId))
  result = call_568199.call(path_568200, query_568201, nil, nil, nil)

var applicationDefinitionsListByResourceGroup* = Call_ApplicationDefinitionsListByResourceGroup_568192(
    name: "applicationDefinitionsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applicationDefinitions",
    validator: validate_ApplicationDefinitionsListByResourceGroup_568193,
    base: "", url: url_ApplicationDefinitionsListByResourceGroup_568194,
    schemes: {Scheme.Https})
type
  Call_ApplicationDefinitionsCreateOrUpdate_568213 = ref object of OpenApiRestCall_567658
proc url_ApplicationDefinitionsCreateOrUpdate_568215(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationDefinitionName" in path,
        "`applicationDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Solutions/applicationDefinitions/"),
               (kind: VariableSegment, value: "applicationDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationDefinitionsCreateOrUpdate_568214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new managed application definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   applicationDefinitionName: JString (required)
  ##                            : The name of the managed application definition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568233 = path.getOrDefault("resourceGroupName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "resourceGroupName", valid_568233
  var valid_568234 = path.getOrDefault("subscriptionId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "subscriptionId", valid_568234
  var valid_568235 = path.getOrDefault("applicationDefinitionName")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "applicationDefinitionName", valid_568235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568236 = query.getOrDefault("api-version")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "api-version", valid_568236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update an managed application definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568238: Call_ApplicationDefinitionsCreateOrUpdate_568213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new managed application definition.
  ## 
  let valid = call_568238.validator(path, query, header, formData, body)
  let scheme = call_568238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568238.url(scheme.get, call_568238.host, call_568238.base,
                         call_568238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568238, url, valid)

proc call*(call_568239: Call_ApplicationDefinitionsCreateOrUpdate_568213;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationDefinitionName: string; parameters: JsonNode): Recallable =
  ## applicationDefinitionsCreateOrUpdate
  ## Creates a new managed application definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   applicationDefinitionName: string (required)
  ##                            : The name of the managed application definition.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update an managed application definition.
  var path_568240 = newJObject()
  var query_568241 = newJObject()
  var body_568242 = newJObject()
  add(path_568240, "resourceGroupName", newJString(resourceGroupName))
  add(query_568241, "api-version", newJString(apiVersion))
  add(path_568240, "subscriptionId", newJString(subscriptionId))
  add(path_568240, "applicationDefinitionName",
      newJString(applicationDefinitionName))
  if parameters != nil:
    body_568242 = parameters
  result = call_568239.call(path_568240, query_568241, nil, nil, body_568242)

var applicationDefinitionsCreateOrUpdate* = Call_ApplicationDefinitionsCreateOrUpdate_568213(
    name: "applicationDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applicationDefinitions/{applicationDefinitionName}",
    validator: validate_ApplicationDefinitionsCreateOrUpdate_568214, base: "",
    url: url_ApplicationDefinitionsCreateOrUpdate_568215, schemes: {Scheme.Https})
type
  Call_ApplicationDefinitionsGet_568202 = ref object of OpenApiRestCall_567658
proc url_ApplicationDefinitionsGet_568204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationDefinitionName" in path,
        "`applicationDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Solutions/applicationDefinitions/"),
               (kind: VariableSegment, value: "applicationDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationDefinitionsGet_568203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the managed application definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   applicationDefinitionName: JString (required)
  ##                            : The name of the managed application definition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568205 = path.getOrDefault("resourceGroupName")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "resourceGroupName", valid_568205
  var valid_568206 = path.getOrDefault("subscriptionId")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "subscriptionId", valid_568206
  var valid_568207 = path.getOrDefault("applicationDefinitionName")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "applicationDefinitionName", valid_568207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568208 = query.getOrDefault("api-version")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "api-version", valid_568208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568209: Call_ApplicationDefinitionsGet_568202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the managed application definition.
  ## 
  let valid = call_568209.validator(path, query, header, formData, body)
  let scheme = call_568209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568209.url(scheme.get, call_568209.host, call_568209.base,
                         call_568209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568209, url, valid)

proc call*(call_568210: Call_ApplicationDefinitionsGet_568202;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationDefinitionName: string): Recallable =
  ## applicationDefinitionsGet
  ## Gets the managed application definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   applicationDefinitionName: string (required)
  ##                            : The name of the managed application definition.
  var path_568211 = newJObject()
  var query_568212 = newJObject()
  add(path_568211, "resourceGroupName", newJString(resourceGroupName))
  add(query_568212, "api-version", newJString(apiVersion))
  add(path_568211, "subscriptionId", newJString(subscriptionId))
  add(path_568211, "applicationDefinitionName",
      newJString(applicationDefinitionName))
  result = call_568210.call(path_568211, query_568212, nil, nil, nil)

var applicationDefinitionsGet* = Call_ApplicationDefinitionsGet_568202(
    name: "applicationDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applicationDefinitions/{applicationDefinitionName}",
    validator: validate_ApplicationDefinitionsGet_568203, base: "",
    url: url_ApplicationDefinitionsGet_568204, schemes: {Scheme.Https})
type
  Call_ApplicationDefinitionsDelete_568243 = ref object of OpenApiRestCall_567658
proc url_ApplicationDefinitionsDelete_568245(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationDefinitionName" in path,
        "`applicationDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Solutions/applicationDefinitions/"),
               (kind: VariableSegment, value: "applicationDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationDefinitionsDelete_568244(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the managed application definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   applicationDefinitionName: JString (required)
  ##                            : The name of the managed application definition to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568246 = path.getOrDefault("resourceGroupName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "resourceGroupName", valid_568246
  var valid_568247 = path.getOrDefault("subscriptionId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "subscriptionId", valid_568247
  var valid_568248 = path.getOrDefault("applicationDefinitionName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "applicationDefinitionName", valid_568248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568249 = query.getOrDefault("api-version")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "api-version", valid_568249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568250: Call_ApplicationDefinitionsDelete_568243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the managed application definition.
  ## 
  let valid = call_568250.validator(path, query, header, formData, body)
  let scheme = call_568250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568250.url(scheme.get, call_568250.host, call_568250.base,
                         call_568250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568250, url, valid)

proc call*(call_568251: Call_ApplicationDefinitionsDelete_568243;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          applicationDefinitionName: string): Recallable =
  ## applicationDefinitionsDelete
  ## Deletes the managed application definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   applicationDefinitionName: string (required)
  ##                            : The name of the managed application definition to delete.
  var path_568252 = newJObject()
  var query_568253 = newJObject()
  add(path_568252, "resourceGroupName", newJString(resourceGroupName))
  add(query_568253, "api-version", newJString(apiVersion))
  add(path_568252, "subscriptionId", newJString(subscriptionId))
  add(path_568252, "applicationDefinitionName",
      newJString(applicationDefinitionName))
  result = call_568251.call(path_568252, query_568253, nil, nil, nil)

var applicationDefinitionsDelete* = Call_ApplicationDefinitionsDelete_568243(
    name: "applicationDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applicationDefinitions/{applicationDefinitionName}",
    validator: validate_ApplicationDefinitionsDelete_568244, base: "",
    url: url_ApplicationDefinitionsDelete_568245, schemes: {Scheme.Https})
type
  Call_ApplicationsListByResourceGroup_568254 = ref object of OpenApiRestCall_567658
proc url_ApplicationsListByResourceGroup_568256(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Solutions/applications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsListByResourceGroup_568255(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the applications within a resource group.
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
  var valid_568257 = path.getOrDefault("resourceGroupName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "resourceGroupName", valid_568257
  var valid_568258 = path.getOrDefault("subscriptionId")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "subscriptionId", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568260: Call_ApplicationsListByResourceGroup_568254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the applications within a resource group.
  ## 
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_ApplicationsListByResourceGroup_568254;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## applicationsListByResourceGroup
  ## Gets all the applications within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568262 = newJObject()
  var query_568263 = newJObject()
  add(path_568262, "resourceGroupName", newJString(resourceGroupName))
  add(query_568263, "api-version", newJString(apiVersion))
  add(path_568262, "subscriptionId", newJString(subscriptionId))
  result = call_568261.call(path_568262, query_568263, nil, nil, nil)

var applicationsListByResourceGroup* = Call_ApplicationsListByResourceGroup_568254(
    name: "applicationsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applications",
    validator: validate_ApplicationsListByResourceGroup_568255, base: "",
    url: url_ApplicationsListByResourceGroup_568256, schemes: {Scheme.Https})
type
  Call_ApplicationsCreateOrUpdate_568275 = ref object of OpenApiRestCall_567658
proc url_ApplicationsCreateOrUpdate_568277(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Solutions/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsCreateOrUpdate_568276(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new managed application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applicationName: JString (required)
  ##                  : The name of the managed application.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568278 = path.getOrDefault("resourceGroupName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "resourceGroupName", valid_568278
  var valid_568279 = path.getOrDefault("applicationName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "applicationName", valid_568279
  var valid_568280 = path.getOrDefault("subscriptionId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "subscriptionId", valid_568280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568281 = query.getOrDefault("api-version")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "api-version", valid_568281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update a managed application.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_ApplicationsCreateOrUpdate_568275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new managed application.
  ## 
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_ApplicationsCreateOrUpdate_568275;
          resourceGroupName: string; applicationName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## applicationsCreateOrUpdate
  ## Creates a new managed application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applicationName: string (required)
  ##                  : The name of the managed application.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update a managed application.
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  var body_568287 = newJObject()
  add(path_568285, "resourceGroupName", newJString(resourceGroupName))
  add(path_568285, "applicationName", newJString(applicationName))
  add(query_568286, "api-version", newJString(apiVersion))
  add(path_568285, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568287 = parameters
  result = call_568284.call(path_568285, query_568286, nil, nil, body_568287)

var applicationsCreateOrUpdate* = Call_ApplicationsCreateOrUpdate_568275(
    name: "applicationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applications/{applicationName}",
    validator: validate_ApplicationsCreateOrUpdate_568276, base: "",
    url: url_ApplicationsCreateOrUpdate_568277, schemes: {Scheme.Https})
type
  Call_ApplicationsGet_568264 = ref object of OpenApiRestCall_567658
proc url_ApplicationsGet_568266(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Solutions/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsGet_568265(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the managed application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applicationName: JString (required)
  ##                  : The name of the managed application.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568267 = path.getOrDefault("resourceGroupName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "resourceGroupName", valid_568267
  var valid_568268 = path.getOrDefault("applicationName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "applicationName", valid_568268
  var valid_568269 = path.getOrDefault("subscriptionId")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "subscriptionId", valid_568269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568270 = query.getOrDefault("api-version")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "api-version", valid_568270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568271: Call_ApplicationsGet_568264; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the managed application.
  ## 
  let valid = call_568271.validator(path, query, header, formData, body)
  let scheme = call_568271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568271.url(scheme.get, call_568271.host, call_568271.base,
                         call_568271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568271, url, valid)

proc call*(call_568272: Call_ApplicationsGet_568264; resourceGroupName: string;
          applicationName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## applicationsGet
  ## Gets the managed application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applicationName: string (required)
  ##                  : The name of the managed application.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568273 = newJObject()
  var query_568274 = newJObject()
  add(path_568273, "resourceGroupName", newJString(resourceGroupName))
  add(path_568273, "applicationName", newJString(applicationName))
  add(query_568274, "api-version", newJString(apiVersion))
  add(path_568273, "subscriptionId", newJString(subscriptionId))
  result = call_568272.call(path_568273, query_568274, nil, nil, nil)

var applicationsGet* = Call_ApplicationsGet_568264(name: "applicationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applications/{applicationName}",
    validator: validate_ApplicationsGet_568265, base: "", url: url_ApplicationsGet_568266,
    schemes: {Scheme.Https})
type
  Call_ApplicationsUpdate_568299 = ref object of OpenApiRestCall_567658
proc url_ApplicationsUpdate_568301(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Solutions/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsUpdate_568300(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates an existing managed application. The only value that can be updated via PATCH currently is the tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applicationName: JString (required)
  ##                  : The name of the managed application.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568302 = path.getOrDefault("resourceGroupName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "resourceGroupName", valid_568302
  var valid_568303 = path.getOrDefault("applicationName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "applicationName", valid_568303
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568305 = query.getOrDefault("api-version")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "api-version", valid_568305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to update an existing managed application.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568307: Call_ApplicationsUpdate_568299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing managed application. The only value that can be updated via PATCH currently is the tags.
  ## 
  let valid = call_568307.validator(path, query, header, formData, body)
  let scheme = call_568307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568307.url(scheme.get, call_568307.host, call_568307.base,
                         call_568307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568307, url, valid)

proc call*(call_568308: Call_ApplicationsUpdate_568299; resourceGroupName: string;
          applicationName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode = nil): Recallable =
  ## applicationsUpdate
  ## Updates an existing managed application. The only value that can be updated via PATCH currently is the tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applicationName: string (required)
  ##                  : The name of the managed application.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject
  ##             : Parameters supplied to update an existing managed application.
  var path_568309 = newJObject()
  var query_568310 = newJObject()
  var body_568311 = newJObject()
  add(path_568309, "resourceGroupName", newJString(resourceGroupName))
  add(path_568309, "applicationName", newJString(applicationName))
  add(query_568310, "api-version", newJString(apiVersion))
  add(path_568309, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568311 = parameters
  result = call_568308.call(path_568309, query_568310, nil, nil, body_568311)

var applicationsUpdate* = Call_ApplicationsUpdate_568299(
    name: "applicationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applications/{applicationName}",
    validator: validate_ApplicationsUpdate_568300, base: "",
    url: url_ApplicationsUpdate_568301, schemes: {Scheme.Https})
type
  Call_ApplicationsDelete_568288 = ref object of OpenApiRestCall_567658
proc url_ApplicationsDelete_568290(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Solutions/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsDelete_568289(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the managed application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applicationName: JString (required)
  ##                  : The name of the managed application.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568291 = path.getOrDefault("resourceGroupName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "resourceGroupName", valid_568291
  var valid_568292 = path.getOrDefault("applicationName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "applicationName", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_ApplicationsDelete_568288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the managed application.
  ## 
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_ApplicationsDelete_568288; resourceGroupName: string;
          applicationName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## applicationsDelete
  ## Deletes the managed application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   applicationName: string (required)
  ##                  : The name of the managed application.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  add(path_568297, "resourceGroupName", newJString(resourceGroupName))
  add(path_568297, "applicationName", newJString(applicationName))
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "subscriptionId", newJString(subscriptionId))
  result = call_568296.call(path_568297, query_568298, nil, nil, nil)

var applicationsDelete* = Call_ApplicationsDelete_568288(
    name: "applicationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Solutions/applications/{applicationName}",
    validator: validate_ApplicationsDelete_568289, base: "",
    url: url_ApplicationsDelete_568290, schemes: {Scheme.Https})
type
  Call_ApplicationsCreateOrUpdateById_568321 = ref object of OpenApiRestCall_567658
proc url_ApplicationsCreateOrUpdateById_568323(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsCreateOrUpdateById_568322(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new managed application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The fully qualified ID of the managed application, including the managed application name and the managed application resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applications/{application-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_568324 = path.getOrDefault("applicationId")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "applicationId", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "api-version", valid_568325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update a managed application.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568327: Call_ApplicationsCreateOrUpdateById_568321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new managed application.
  ## 
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_ApplicationsCreateOrUpdateById_568321;
          apiVersion: string; applicationId: string; parameters: JsonNode): Recallable =
  ## applicationsCreateOrUpdateById
  ## Creates a new managed application.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applicationId: string (required)
  ##                : The fully qualified ID of the managed application, including the managed application name and the managed application resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applications/{application-name}
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update a managed application.
  var path_568329 = newJObject()
  var query_568330 = newJObject()
  var body_568331 = newJObject()
  add(query_568330, "api-version", newJString(apiVersion))
  add(path_568329, "applicationId", newJString(applicationId))
  if parameters != nil:
    body_568331 = parameters
  result = call_568328.call(path_568329, query_568330, nil, nil, body_568331)

var applicationsCreateOrUpdateById* = Call_ApplicationsCreateOrUpdateById_568321(
    name: "applicationsCreateOrUpdateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{applicationId}",
    validator: validate_ApplicationsCreateOrUpdateById_568322, base: "",
    url: url_ApplicationsCreateOrUpdateById_568323, schemes: {Scheme.Https})
type
  Call_ApplicationsGetById_568312 = ref object of OpenApiRestCall_567658
proc url_ApplicationsGetById_568314(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsGetById_568313(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the managed application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The fully qualified ID of the managed application, including the managed application name and the managed application resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applications/{application-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_568315 = path.getOrDefault("applicationId")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "applicationId", valid_568315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568316 = query.getOrDefault("api-version")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "api-version", valid_568316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568317: Call_ApplicationsGetById_568312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the managed application.
  ## 
  let valid = call_568317.validator(path, query, header, formData, body)
  let scheme = call_568317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568317.url(scheme.get, call_568317.host, call_568317.base,
                         call_568317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568317, url, valid)

proc call*(call_568318: Call_ApplicationsGetById_568312; apiVersion: string;
          applicationId: string): Recallable =
  ## applicationsGetById
  ## Gets the managed application.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applicationId: string (required)
  ##                : The fully qualified ID of the managed application, including the managed application name and the managed application resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applications/{application-name}
  var path_568319 = newJObject()
  var query_568320 = newJObject()
  add(query_568320, "api-version", newJString(apiVersion))
  add(path_568319, "applicationId", newJString(applicationId))
  result = call_568318.call(path_568319, query_568320, nil, nil, nil)

var applicationsGetById* = Call_ApplicationsGetById_568312(
    name: "applicationsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{applicationId}",
    validator: validate_ApplicationsGetById_568313, base: "",
    url: url_ApplicationsGetById_568314, schemes: {Scheme.Https})
type
  Call_ApplicationsUpdateById_568341 = ref object of OpenApiRestCall_567658
proc url_ApplicationsUpdateById_568343(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsUpdateById_568342(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing managed application. The only value that can be updated via PATCH currently is the tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The fully qualified ID of the managed application, including the managed application name and the managed application resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applications/{application-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_568344 = path.getOrDefault("applicationId")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "applicationId", valid_568344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568345 = query.getOrDefault("api-version")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "api-version", valid_568345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to update an existing managed application.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568347: Call_ApplicationsUpdateById_568341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing managed application. The only value that can be updated via PATCH currently is the tags.
  ## 
  let valid = call_568347.validator(path, query, header, formData, body)
  let scheme = call_568347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568347.url(scheme.get, call_568347.host, call_568347.base,
                         call_568347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568347, url, valid)

proc call*(call_568348: Call_ApplicationsUpdateById_568341; apiVersion: string;
          applicationId: string; parameters: JsonNode = nil): Recallable =
  ## applicationsUpdateById
  ## Updates an existing managed application. The only value that can be updated via PATCH currently is the tags.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applicationId: string (required)
  ##                : The fully qualified ID of the managed application, including the managed application name and the managed application resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applications/{application-name}
  ##   parameters: JObject
  ##             : Parameters supplied to update an existing managed application.
  var path_568349 = newJObject()
  var query_568350 = newJObject()
  var body_568351 = newJObject()
  add(query_568350, "api-version", newJString(apiVersion))
  add(path_568349, "applicationId", newJString(applicationId))
  if parameters != nil:
    body_568351 = parameters
  result = call_568348.call(path_568349, query_568350, nil, nil, body_568351)

var applicationsUpdateById* = Call_ApplicationsUpdateById_568341(
    name: "applicationsUpdateById", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{applicationId}",
    validator: validate_ApplicationsUpdateById_568342, base: "",
    url: url_ApplicationsUpdateById_568343, schemes: {Scheme.Https})
type
  Call_ApplicationsDeleteById_568332 = ref object of OpenApiRestCall_567658
proc url_ApplicationsDeleteById_568334(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsDeleteById_568333(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the managed application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The fully qualified ID of the managed application, including the managed application name and the managed application resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applications/{application-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_568335 = path.getOrDefault("applicationId")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "applicationId", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568337: Call_ApplicationsDeleteById_568332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the managed application.
  ## 
  let valid = call_568337.validator(path, query, header, formData, body)
  let scheme = call_568337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568337.url(scheme.get, call_568337.host, call_568337.base,
                         call_568337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568337, url, valid)

proc call*(call_568338: Call_ApplicationsDeleteById_568332; apiVersion: string;
          applicationId: string): Recallable =
  ## applicationsDeleteById
  ## Deletes the managed application.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   applicationId: string (required)
  ##                : The fully qualified ID of the managed application, including the managed application name and the managed application resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/Microsoft.Solutions/applications/{application-name}
  var path_568339 = newJObject()
  var query_568340 = newJObject()
  add(query_568340, "api-version", newJString(apiVersion))
  add(path_568339, "applicationId", newJString(applicationId))
  result = call_568338.call(path_568339, query_568340, nil, nil, nil)

var applicationsDeleteById* = Call_ApplicationsDeleteById_568332(
    name: "applicationsDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{applicationId}",
    validator: validate_ApplicationsDeleteById_568333, base: "",
    url: url_ApplicationsDeleteById_568334, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
