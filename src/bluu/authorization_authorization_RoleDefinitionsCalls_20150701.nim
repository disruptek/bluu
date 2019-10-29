
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: AuthorizationManagementClient
## version: 2015-07-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Role based access control provides you a way to apply granular level policy administration down to individual resources or resource groups. These operations enable you to manage role definitions and role assignments. A role definition describes the set of actions that can be performed on resources. A role assignment grants access to Azure Active Directory users.
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "authorization-authorization-RoleDefinitionsCalls"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PermissionsListForResourceGroup_563761 = ref object of OpenApiRestCall_563539
proc url_PermissionsListForResourceGroup_563763(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PermissionsListForResourceGroup_563762(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all permissions the caller has for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get the permissions for. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563938 = path.getOrDefault("subscriptionId")
  valid_563938 = validateParameter(valid_563938, JString, required = true,
                                 default = nil)
  if valid_563938 != nil:
    section.add "subscriptionId", valid_563938
  var valid_563939 = path.getOrDefault("resourceGroupName")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "resourceGroupName", valid_563939
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_PermissionsListForResourceGroup_563761;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all permissions the caller has for a resource group.
  ## 
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_PermissionsListForResourceGroup_563761;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## permissionsListForResourceGroup
  ## Gets all permissions the caller has for a resource group.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get the permissions for. The name is case insensitive.
  var path_564035 = newJObject()
  var query_564037 = newJObject()
  add(query_564037, "api-version", newJString(apiVersion))
  add(path_564035, "subscriptionId", newJString(subscriptionId))
  add(path_564035, "resourceGroupName", newJString(resourceGroupName))
  result = call_564034.call(path_564035, query_564037, nil, nil, nil)

var permissionsListForResourceGroup* = Call_PermissionsListForResourceGroup_563761(
    name: "permissionsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Authorization/permissions",
    validator: validate_PermissionsListForResourceGroup_563762, base: "",
    url: url_PermissionsListForResourceGroup_563763, schemes: {Scheme.Https})
type
  Call_PermissionsListForResource_564076 = ref object of OpenApiRestCall_563539
proc url_PermissionsListForResource_564078(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PermissionsListForResource_564077(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all permissions the caller has for a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : The name of the resource to get the permissions for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564079 = path.getOrDefault("resourceType")
  valid_564079 = validateParameter(valid_564079, JString, required = true,
                                 default = nil)
  if valid_564079 != nil:
    section.add "resourceType", valid_564079
  var valid_564080 = path.getOrDefault("resourceProviderNamespace")
  valid_564080 = validateParameter(valid_564080, JString, required = true,
                                 default = nil)
  if valid_564080 != nil:
    section.add "resourceProviderNamespace", valid_564080
  var valid_564081 = path.getOrDefault("subscriptionId")
  valid_564081 = validateParameter(valid_564081, JString, required = true,
                                 default = nil)
  if valid_564081 != nil:
    section.add "subscriptionId", valid_564081
  var valid_564082 = path.getOrDefault("parentResourcePath")
  valid_564082 = validateParameter(valid_564082, JString, required = true,
                                 default = nil)
  if valid_564082 != nil:
    section.add "parentResourcePath", valid_564082
  var valid_564083 = path.getOrDefault("resourceGroupName")
  valid_564083 = validateParameter(valid_564083, JString, required = true,
                                 default = nil)
  if valid_564083 != nil:
    section.add "resourceGroupName", valid_564083
  var valid_564084 = path.getOrDefault("resourceName")
  valid_564084 = validateParameter(valid_564084, JString, required = true,
                                 default = nil)
  if valid_564084 != nil:
    section.add "resourceName", valid_564084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564085 = query.getOrDefault("api-version")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = nil)
  if valid_564085 != nil:
    section.add "api-version", valid_564085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564086: Call_PermissionsListForResource_564076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all permissions the caller has for a resource.
  ## 
  let valid = call_564086.validator(path, query, header, formData, body)
  let scheme = call_564086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564086.url(scheme.get, call_564086.host, call_564086.base,
                         call_564086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564086, url, valid)

proc call*(call_564087: Call_PermissionsListForResource_564076; apiVersion: string;
          resourceType: string; resourceProviderNamespace: string;
          subscriptionId: string; parentResourcePath: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## permissionsListForResource
  ## Gets all permissions the caller has for a resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   resourceType: string (required)
  ##               : The resource type of the resource.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : The name of the resource to get the permissions for.
  var path_564088 = newJObject()
  var query_564089 = newJObject()
  add(query_564089, "api-version", newJString(apiVersion))
  add(path_564088, "resourceType", newJString(resourceType))
  add(path_564088, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_564088, "subscriptionId", newJString(subscriptionId))
  add(path_564088, "parentResourcePath", newJString(parentResourcePath))
  add(path_564088, "resourceGroupName", newJString(resourceGroupName))
  add(path_564088, "resourceName", newJString(resourceName))
  result = call_564087.call(path_564088, query_564089, nil, nil, nil)

var permissionsListForResource* = Call_PermissionsListForResource_564076(
    name: "permissionsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/permissions",
    validator: validate_PermissionsListForResource_564077, base: "",
    url: url_PermissionsListForResource_564078, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsGetById_564090 = ref object of OpenApiRestCall_563539
proc url_RoleDefinitionsGetById_564092(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "roleDefinitionId" in path,
        "`roleDefinitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "roleDefinitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleDefinitionsGetById_564091(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a role definition by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleDefinitionId: JString (required)
  ##                   : The fully qualified role definition ID. Use the format, 
  ## /subscriptions/{guid}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId} for subscription level role definitions, or /providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId} for tenant level role definitions.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `roleDefinitionId` field"
  var valid_564093 = path.getOrDefault("roleDefinitionId")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "roleDefinitionId", valid_564093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564094 = query.getOrDefault("api-version")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "api-version", valid_564094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564095: Call_RoleDefinitionsGetById_564090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a role definition by ID.
  ## 
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_RoleDefinitionsGetById_564090; apiVersion: string;
          roleDefinitionId: string): Recallable =
  ## roleDefinitionsGetById
  ## Gets a role definition by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleDefinitionId: string (required)
  ##                   : The fully qualified role definition ID. Use the format, 
  ## /subscriptions/{guid}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId} for subscription level role definitions, or /providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId} for tenant level role definitions.
  var path_564097 = newJObject()
  var query_564098 = newJObject()
  add(query_564098, "api-version", newJString(apiVersion))
  add(path_564097, "roleDefinitionId", newJString(roleDefinitionId))
  result = call_564096.call(path_564097, query_564098, nil, nil, nil)

var roleDefinitionsGetById* = Call_RoleDefinitionsGetById_564090(
    name: "roleDefinitionsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{roleDefinitionId}",
    validator: validate_RoleDefinitionsGetById_564091, base: "",
    url: url_RoleDefinitionsGetById_564092, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsList_564099 = ref object of OpenApiRestCall_563539
proc url_RoleDefinitionsList_564101(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/roleDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleDefinitionsList_564100(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get all role definitions that are applicable at scope and above.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the role definition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_564103 = path.getOrDefault("scope")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "scope", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use atScopeAndBelow filter to search below the given scope as well.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  var valid_564105 = query.getOrDefault("$filter")
  valid_564105 = validateParameter(valid_564105, JString, required = false,
                                 default = nil)
  if valid_564105 != nil:
    section.add "$filter", valid_564105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564106: Call_RoleDefinitionsList_564099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all role definitions that are applicable at scope and above.
  ## 
  let valid = call_564106.validator(path, query, header, formData, body)
  let scheme = call_564106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564106.url(scheme.get, call_564106.host, call_564106.base,
                         call_564106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564106, url, valid)

proc call*(call_564107: Call_RoleDefinitionsList_564099; apiVersion: string;
          scope: string; Filter: string = ""): Recallable =
  ## roleDefinitionsList
  ## Get all role definitions that are applicable at scope and above.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use atScopeAndBelow filter to search below the given scope as well.
  ##   scope: string (required)
  ##        : The scope of the role definition.
  var path_564108 = newJObject()
  var query_564109 = newJObject()
  add(query_564109, "api-version", newJString(apiVersion))
  add(query_564109, "$filter", newJString(Filter))
  add(path_564108, "scope", newJString(scope))
  result = call_564107.call(path_564108, query_564109, nil, nil, nil)

var roleDefinitionsList* = Call_RoleDefinitionsList_564099(
    name: "roleDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions",
    validator: validate_RoleDefinitionsList_564100, base: "",
    url: url_RoleDefinitionsList_564101, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsCreateOrUpdate_564120 = ref object of OpenApiRestCall_563539
proc url_RoleDefinitionsCreateOrUpdate_564122(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "roleDefinitionId" in path,
        "`roleDefinitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/roleDefinitions/"),
               (kind: VariableSegment, value: "roleDefinitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleDefinitionsCreateOrUpdate_564121(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a role definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleDefinitionId: JString (required)
  ##                   : The ID of the role definition.
  ##   scope: JString (required)
  ##        : The scope of the role definition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `roleDefinitionId` field"
  var valid_564140 = path.getOrDefault("roleDefinitionId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "roleDefinitionId", valid_564140
  var valid_564141 = path.getOrDefault("scope")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "scope", valid_564141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564142 = query.getOrDefault("api-version")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "api-version", valid_564142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   roleDefinition: JObject (required)
  ##                 : The values for the role definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_RoleDefinitionsCreateOrUpdate_564120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a role definition.
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_RoleDefinitionsCreateOrUpdate_564120;
          apiVersion: string; roleDefinition: JsonNode; roleDefinitionId: string;
          scope: string): Recallable =
  ## roleDefinitionsCreateOrUpdate
  ## Creates or updates a role definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleDefinition: JObject (required)
  ##                 : The values for the role definition.
  ##   roleDefinitionId: string (required)
  ##                   : The ID of the role definition.
  ##   scope: string (required)
  ##        : The scope of the role definition.
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  var body_564148 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  if roleDefinition != nil:
    body_564148 = roleDefinition
  add(path_564146, "roleDefinitionId", newJString(roleDefinitionId))
  add(path_564146, "scope", newJString(scope))
  result = call_564145.call(path_564146, query_564147, nil, nil, body_564148)

var roleDefinitionsCreateOrUpdate* = Call_RoleDefinitionsCreateOrUpdate_564120(
    name: "roleDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}",
    validator: validate_RoleDefinitionsCreateOrUpdate_564121, base: "",
    url: url_RoleDefinitionsCreateOrUpdate_564122, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsGet_564110 = ref object of OpenApiRestCall_563539
proc url_RoleDefinitionsGet_564112(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "roleDefinitionId" in path,
        "`roleDefinitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/roleDefinitions/"),
               (kind: VariableSegment, value: "roleDefinitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleDefinitionsGet_564111(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get role definition by name (GUID).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleDefinitionId: JString (required)
  ##                   : The ID of the role definition.
  ##   scope: JString (required)
  ##        : The scope of the role definition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `roleDefinitionId` field"
  var valid_564113 = path.getOrDefault("roleDefinitionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "roleDefinitionId", valid_564113
  var valid_564114 = path.getOrDefault("scope")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "scope", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564116: Call_RoleDefinitionsGet_564110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get role definition by name (GUID).
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_RoleDefinitionsGet_564110; apiVersion: string;
          roleDefinitionId: string; scope: string): Recallable =
  ## roleDefinitionsGet
  ## Get role definition by name (GUID).
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleDefinitionId: string (required)
  ##                   : The ID of the role definition.
  ##   scope: string (required)
  ##        : The scope of the role definition.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "roleDefinitionId", newJString(roleDefinitionId))
  add(path_564118, "scope", newJString(scope))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var roleDefinitionsGet* = Call_RoleDefinitionsGet_564110(
    name: "roleDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}",
    validator: validate_RoleDefinitionsGet_564111, base: "",
    url: url_RoleDefinitionsGet_564112, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsDelete_564149 = ref object of OpenApiRestCall_563539
proc url_RoleDefinitionsDelete_564151(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "roleDefinitionId" in path,
        "`roleDefinitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/roleDefinitions/"),
               (kind: VariableSegment, value: "roleDefinitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleDefinitionsDelete_564150(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a role definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleDefinitionId: JString (required)
  ##                   : The ID of the role definition to delete.
  ##   scope: JString (required)
  ##        : The scope of the role definition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `roleDefinitionId` field"
  var valid_564152 = path.getOrDefault("roleDefinitionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "roleDefinitionId", valid_564152
  var valid_564153 = path.getOrDefault("scope")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "scope", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564155: Call_RoleDefinitionsDelete_564149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role definition.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_RoleDefinitionsDelete_564149; apiVersion: string;
          roleDefinitionId: string; scope: string): Recallable =
  ## roleDefinitionsDelete
  ## Deletes a role definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleDefinitionId: string (required)
  ##                   : The ID of the role definition to delete.
  ##   scope: string (required)
  ##        : The scope of the role definition.
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "roleDefinitionId", newJString(roleDefinitionId))
  add(path_564157, "scope", newJString(scope))
  result = call_564156.call(path_564157, query_564158, nil, nil, nil)

var roleDefinitionsDelete* = Call_RoleDefinitionsDelete_564149(
    name: "roleDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}",
    validator: validate_RoleDefinitionsDelete_564150, base: "",
    url: url_RoleDefinitionsDelete_564151, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
