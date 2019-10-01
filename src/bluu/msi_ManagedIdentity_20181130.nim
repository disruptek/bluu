
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ManagedServiceIdentityClient
## version: 2018-11-30
## termsOfService: (not provided)
## license: (not provided)
## 
## The Managed Service Identity Client.
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "msi-ManagedIdentity"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567863 = ref object of OpenApiRestCall_567641
proc url_OperationsList_567865(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567864(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists available operations for the Microsoft.ManagedIdentity provider
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of API to invoke.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568024 = query.getOrDefault("api-version")
  valid_568024 = validateParameter(valid_568024, JString, required = true,
                                 default = nil)
  if valid_568024 != nil:
    section.add "api-version", valid_568024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568047: Call_OperationsList_567863; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the Microsoft.ManagedIdentity provider
  ## 
  let valid = call_568047.validator(path, query, header, formData, body)
  let scheme = call_568047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568047.url(scheme.get, call_568047.host, call_568047.base,
                         call_568047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568047, url, valid)

proc call*(call_568118: Call_OperationsList_567863; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the Microsoft.ManagedIdentity provider
  ##   apiVersion: string (required)
  ##             : Version of API to invoke.
  var query_568119 = newJObject()
  add(query_568119, "api-version", newJString(apiVersion))
  result = call_568118.call(nil, query_568119, nil, nil, nil)

var operationsList* = Call_OperationsList_567863(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ManagedIdentity/operations",
    validator: validate_OperationsList_567864, base: "", url: url_OperationsList_567865,
    schemes: {Scheme.Https})
type
  Call_UserAssignedIdentitiesListBySubscription_568159 = ref object of OpenApiRestCall_567641
proc url_UserAssignedIdentitiesListBySubscription_568161(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedIdentity/userAssignedIdentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserAssignedIdentitiesListBySubscription_568160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the userAssignedIdentities available under the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Id of the Subscription to which the identity belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568176 = path.getOrDefault("subscriptionId")
  valid_568176 = validateParameter(valid_568176, JString, required = true,
                                 default = nil)
  if valid_568176 != nil:
    section.add "subscriptionId", valid_568176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of API to invoke.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568177 = query.getOrDefault("api-version")
  valid_568177 = validateParameter(valid_568177, JString, required = true,
                                 default = nil)
  if valid_568177 != nil:
    section.add "api-version", valid_568177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568178: Call_UserAssignedIdentitiesListBySubscription_568159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the userAssignedIdentities available under the specified subscription.
  ## 
  let valid = call_568178.validator(path, query, header, formData, body)
  let scheme = call_568178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568178.url(scheme.get, call_568178.host, call_568178.base,
                         call_568178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568178, url, valid)

proc call*(call_568179: Call_UserAssignedIdentitiesListBySubscription_568159;
          apiVersion: string; subscriptionId: string): Recallable =
  ## userAssignedIdentitiesListBySubscription
  ## Lists all the userAssignedIdentities available under the specified subscription.
  ##   apiVersion: string (required)
  ##             : Version of API to invoke.
  ##   subscriptionId: string (required)
  ##                 : The Id of the Subscription to which the identity belongs.
  var path_568180 = newJObject()
  var query_568181 = newJObject()
  add(query_568181, "api-version", newJString(apiVersion))
  add(path_568180, "subscriptionId", newJString(subscriptionId))
  result = call_568179.call(path_568180, query_568181, nil, nil, nil)

var userAssignedIdentitiesListBySubscription* = Call_UserAssignedIdentitiesListBySubscription_568159(
    name: "userAssignedIdentitiesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ManagedIdentity/userAssignedIdentities",
    validator: validate_UserAssignedIdentitiesListBySubscription_568160, base: "",
    url: url_UserAssignedIdentitiesListBySubscription_568161,
    schemes: {Scheme.Https})
type
  Call_UserAssignedIdentitiesListByResourceGroup_568182 = ref object of OpenApiRestCall_567641
proc url_UserAssignedIdentitiesListByResourceGroup_568184(protocol: Scheme;
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
        value: "/providers/Microsoft.ManagedIdentity/userAssignedIdentities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserAssignedIdentitiesListByResourceGroup_568183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the userAssignedIdentities available under the specified ResourceGroup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the identity belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Id of the Subscription to which the identity belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568185 = path.getOrDefault("resourceGroupName")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "resourceGroupName", valid_568185
  var valid_568186 = path.getOrDefault("subscriptionId")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "subscriptionId", valid_568186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of API to invoke.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568187 = query.getOrDefault("api-version")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "api-version", valid_568187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568188: Call_UserAssignedIdentitiesListByResourceGroup_568182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the userAssignedIdentities available under the specified ResourceGroup.
  ## 
  let valid = call_568188.validator(path, query, header, formData, body)
  let scheme = call_568188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568188.url(scheme.get, call_568188.host, call_568188.base,
                         call_568188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568188, url, valid)

proc call*(call_568189: Call_UserAssignedIdentitiesListByResourceGroup_568182;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## userAssignedIdentitiesListByResourceGroup
  ## Lists all the userAssignedIdentities available under the specified ResourceGroup.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the identity belongs.
  ##   apiVersion: string (required)
  ##             : Version of API to invoke.
  ##   subscriptionId: string (required)
  ##                 : The Id of the Subscription to which the identity belongs.
  var path_568190 = newJObject()
  var query_568191 = newJObject()
  add(path_568190, "resourceGroupName", newJString(resourceGroupName))
  add(query_568191, "api-version", newJString(apiVersion))
  add(path_568190, "subscriptionId", newJString(subscriptionId))
  result = call_568189.call(path_568190, query_568191, nil, nil, nil)

var userAssignedIdentitiesListByResourceGroup* = Call_UserAssignedIdentitiesListByResourceGroup_568182(
    name: "userAssignedIdentitiesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities",
    validator: validate_UserAssignedIdentitiesListByResourceGroup_568183,
    base: "", url: url_UserAssignedIdentitiesListByResourceGroup_568184,
    schemes: {Scheme.Https})
type
  Call_UserAssignedIdentitiesCreateOrUpdate_568203 = ref object of OpenApiRestCall_567641
proc url_UserAssignedIdentitiesCreateOrUpdate_568205(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedIdentity/userAssignedIdentities/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserAssignedIdentitiesCreateOrUpdate_568204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an identity in the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the identity belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Id of the Subscription to which the identity belongs.
  ##   resourceName: JString (required)
  ##               : The name of the identity resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568223 = path.getOrDefault("resourceGroupName")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "resourceGroupName", valid_568223
  var valid_568224 = path.getOrDefault("subscriptionId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "subscriptionId", valid_568224
  var valid_568225 = path.getOrDefault("resourceName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "resourceName", valid_568225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of API to invoke.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "api-version", valid_568226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to create or update the identity
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_UserAssignedIdentitiesCreateOrUpdate_568203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update an identity in the specified subscription and resource group.
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_UserAssignedIdentitiesCreateOrUpdate_568203;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode): Recallable =
  ## userAssignedIdentitiesCreateOrUpdate
  ## Create or update an identity in the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the identity belongs.
  ##   apiVersion: string (required)
  ##             : Version of API to invoke.
  ##   subscriptionId: string (required)
  ##                 : The Id of the Subscription to which the identity belongs.
  ##   resourceName: string (required)
  ##               : The name of the identity resource.
  ##   parameters: JObject (required)
  ##             : Parameters to create or update the identity
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  var body_568232 = newJObject()
  add(path_568230, "resourceGroupName", newJString(resourceGroupName))
  add(query_568231, "api-version", newJString(apiVersion))
  add(path_568230, "subscriptionId", newJString(subscriptionId))
  add(path_568230, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568232 = parameters
  result = call_568229.call(path_568230, query_568231, nil, nil, body_568232)

var userAssignedIdentitiesCreateOrUpdate* = Call_UserAssignedIdentitiesCreateOrUpdate_568203(
    name: "userAssignedIdentitiesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{resourceName}",
    validator: validate_UserAssignedIdentitiesCreateOrUpdate_568204, base: "",
    url: url_UserAssignedIdentitiesCreateOrUpdate_568205, schemes: {Scheme.Https})
type
  Call_UserAssignedIdentitiesGet_568192 = ref object of OpenApiRestCall_567641
proc url_UserAssignedIdentitiesGet_568194(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedIdentity/userAssignedIdentities/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserAssignedIdentitiesGet_568193(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the identity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the identity belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Id of the Subscription to which the identity belongs.
  ##   resourceName: JString (required)
  ##               : The name of the identity resource.
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
  var valid_568197 = path.getOrDefault("resourceName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "resourceName", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of API to invoke.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_UserAssignedIdentitiesGet_568192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the identity.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_UserAssignedIdentitiesGet_568192;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## userAssignedIdentitiesGet
  ## Gets the identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the identity belongs.
  ##   apiVersion: string (required)
  ##             : Version of API to invoke.
  ##   subscriptionId: string (required)
  ##                 : The Id of the Subscription to which the identity belongs.
  ##   resourceName: string (required)
  ##               : The name of the identity resource.
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(path_568201, "resourceGroupName", newJString(resourceGroupName))
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  add(path_568201, "resourceName", newJString(resourceName))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var userAssignedIdentitiesGet* = Call_UserAssignedIdentitiesGet_568192(
    name: "userAssignedIdentitiesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{resourceName}",
    validator: validate_UserAssignedIdentitiesGet_568193, base: "",
    url: url_UserAssignedIdentitiesGet_568194, schemes: {Scheme.Https})
type
  Call_UserAssignedIdentitiesUpdate_568244 = ref object of OpenApiRestCall_567641
proc url_UserAssignedIdentitiesUpdate_568246(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedIdentity/userAssignedIdentities/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserAssignedIdentitiesUpdate_568245(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an identity in the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the identity belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Id of the Subscription to which the identity belongs.
  ##   resourceName: JString (required)
  ##               : The name of the identity resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568247 = path.getOrDefault("resourceGroupName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "resourceGroupName", valid_568247
  var valid_568248 = path.getOrDefault("subscriptionId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "subscriptionId", valid_568248
  var valid_568249 = path.getOrDefault("resourceName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "resourceName", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of API to invoke.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "api-version", valid_568250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to update the identity
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568252: Call_UserAssignedIdentitiesUpdate_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an identity in the specified subscription and resource group.
  ## 
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_UserAssignedIdentitiesUpdate_568244;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode): Recallable =
  ## userAssignedIdentitiesUpdate
  ## Update an identity in the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the identity belongs.
  ##   apiVersion: string (required)
  ##             : Version of API to invoke.
  ##   subscriptionId: string (required)
  ##                 : The Id of the Subscription to which the identity belongs.
  ##   resourceName: string (required)
  ##               : The name of the identity resource.
  ##   parameters: JObject (required)
  ##             : Parameters to update the identity
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  var body_568256 = newJObject()
  add(path_568254, "resourceGroupName", newJString(resourceGroupName))
  add(query_568255, "api-version", newJString(apiVersion))
  add(path_568254, "subscriptionId", newJString(subscriptionId))
  add(path_568254, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568256 = parameters
  result = call_568253.call(path_568254, query_568255, nil, nil, body_568256)

var userAssignedIdentitiesUpdate* = Call_UserAssignedIdentitiesUpdate_568244(
    name: "userAssignedIdentitiesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{resourceName}",
    validator: validate_UserAssignedIdentitiesUpdate_568245, base: "",
    url: url_UserAssignedIdentitiesUpdate_568246, schemes: {Scheme.Https})
type
  Call_UserAssignedIdentitiesDelete_568233 = ref object of OpenApiRestCall_567641
proc url_UserAssignedIdentitiesDelete_568235(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedIdentity/userAssignedIdentities/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserAssignedIdentitiesDelete_568234(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the identity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the Resource Group to which the identity belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Id of the Subscription to which the identity belongs.
  ##   resourceName: JString (required)
  ##               : The name of the identity resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568236 = path.getOrDefault("resourceGroupName")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = nil)
  if valid_568236 != nil:
    section.add "resourceGroupName", valid_568236
  var valid_568237 = path.getOrDefault("subscriptionId")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "subscriptionId", valid_568237
  var valid_568238 = path.getOrDefault("resourceName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "resourceName", valid_568238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of API to invoke.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568239 = query.getOrDefault("api-version")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "api-version", valid_568239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_UserAssignedIdentitiesDelete_568233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the identity.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_UserAssignedIdentitiesDelete_568233;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## userAssignedIdentitiesDelete
  ## Deletes the identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the Resource Group to which the identity belongs.
  ##   apiVersion: string (required)
  ##             : Version of API to invoke.
  ##   subscriptionId: string (required)
  ##                 : The Id of the Subscription to which the identity belongs.
  ##   resourceName: string (required)
  ##               : The name of the identity resource.
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  add(path_568242, "resourceGroupName", newJString(resourceGroupName))
  add(query_568243, "api-version", newJString(apiVersion))
  add(path_568242, "subscriptionId", newJString(subscriptionId))
  add(path_568242, "resourceName", newJString(resourceName))
  result = call_568241.call(path_568242, query_568243, nil, nil, nil)

var userAssignedIdentitiesDelete* = Call_UserAssignedIdentitiesDelete_568233(
    name: "userAssignedIdentitiesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{resourceName}",
    validator: validate_UserAssignedIdentitiesDelete_568234, base: "",
    url: url_UserAssignedIdentitiesDelete_568235, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
