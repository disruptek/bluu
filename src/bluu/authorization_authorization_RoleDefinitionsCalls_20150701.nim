
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_596441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596441): Option[Scheme] {.used.} =
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
  macServiceName = "authorization-authorization-RoleDefinitionsCalls"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PermissionsListForResourceGroup_596663 = ref object of OpenApiRestCall_596441
proc url_PermissionsListForResourceGroup_596665(protocol: Scheme; host: string;
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

proc validate_PermissionsListForResourceGroup_596664(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all permissions the caller has for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get the permissions for. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596838 = path.getOrDefault("resourceGroupName")
  valid_596838 = validateParameter(valid_596838, JString, required = true,
                                 default = nil)
  if valid_596838 != nil:
    section.add "resourceGroupName", valid_596838
  var valid_596839 = path.getOrDefault("subscriptionId")
  valid_596839 = validateParameter(valid_596839, JString, required = true,
                                 default = nil)
  if valid_596839 != nil:
    section.add "subscriptionId", valid_596839
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596840 = query.getOrDefault("api-version")
  valid_596840 = validateParameter(valid_596840, JString, required = true,
                                 default = nil)
  if valid_596840 != nil:
    section.add "api-version", valid_596840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596863: Call_PermissionsListForResourceGroup_596663;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all permissions the caller has for a resource group.
  ## 
  let valid = call_596863.validator(path, query, header, formData, body)
  let scheme = call_596863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596863.url(scheme.get, call_596863.host, call_596863.base,
                         call_596863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596863, url, valid)

proc call*(call_596934: Call_PermissionsListForResourceGroup_596663;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## permissionsListForResourceGroup
  ## Gets all permissions the caller has for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get the permissions for. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_596935 = newJObject()
  var query_596937 = newJObject()
  add(path_596935, "resourceGroupName", newJString(resourceGroupName))
  add(query_596937, "api-version", newJString(apiVersion))
  add(path_596935, "subscriptionId", newJString(subscriptionId))
  result = call_596934.call(path_596935, query_596937, nil, nil, nil)

var permissionsListForResourceGroup* = Call_PermissionsListForResourceGroup_596663(
    name: "permissionsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Authorization/permissions",
    validator: validate_PermissionsListForResourceGroup_596664, base: "",
    url: url_PermissionsListForResourceGroup_596665, schemes: {Scheme.Https})
type
  Call_PermissionsListForResource_596976 = ref object of OpenApiRestCall_596441
proc url_PermissionsListForResource_596978(protocol: Scheme; host: string;
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

proc validate_PermissionsListForResource_596977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all permissions the caller has for a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to get the permissions for.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_596979 = path.getOrDefault("resourceType")
  valid_596979 = validateParameter(valid_596979, JString, required = true,
                                 default = nil)
  if valid_596979 != nil:
    section.add "resourceType", valid_596979
  var valid_596980 = path.getOrDefault("resourceGroupName")
  valid_596980 = validateParameter(valid_596980, JString, required = true,
                                 default = nil)
  if valid_596980 != nil:
    section.add "resourceGroupName", valid_596980
  var valid_596981 = path.getOrDefault("subscriptionId")
  valid_596981 = validateParameter(valid_596981, JString, required = true,
                                 default = nil)
  if valid_596981 != nil:
    section.add "subscriptionId", valid_596981
  var valid_596982 = path.getOrDefault("resourceName")
  valid_596982 = validateParameter(valid_596982, JString, required = true,
                                 default = nil)
  if valid_596982 != nil:
    section.add "resourceName", valid_596982
  var valid_596983 = path.getOrDefault("resourceProviderNamespace")
  valid_596983 = validateParameter(valid_596983, JString, required = true,
                                 default = nil)
  if valid_596983 != nil:
    section.add "resourceProviderNamespace", valid_596983
  var valid_596984 = path.getOrDefault("parentResourcePath")
  valid_596984 = validateParameter(valid_596984, JString, required = true,
                                 default = nil)
  if valid_596984 != nil:
    section.add "parentResourcePath", valid_596984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596985 = query.getOrDefault("api-version")
  valid_596985 = validateParameter(valid_596985, JString, required = true,
                                 default = nil)
  if valid_596985 != nil:
    section.add "api-version", valid_596985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596986: Call_PermissionsListForResource_596976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all permissions the caller has for a resource.
  ## 
  let valid = call_596986.validator(path, query, header, formData, body)
  let scheme = call_596986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596986.url(scheme.get, call_596986.host, call_596986.base,
                         call_596986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596986, url, valid)

proc call*(call_596987: Call_PermissionsListForResource_596976;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## permissionsListForResource
  ## Gets all permissions the caller has for a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to get the permissions for.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_596988 = newJObject()
  var query_596989 = newJObject()
  add(path_596988, "resourceType", newJString(resourceType))
  add(path_596988, "resourceGroupName", newJString(resourceGroupName))
  add(query_596989, "api-version", newJString(apiVersion))
  add(path_596988, "subscriptionId", newJString(subscriptionId))
  add(path_596988, "resourceName", newJString(resourceName))
  add(path_596988, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_596988, "parentResourcePath", newJString(parentResourcePath))
  result = call_596987.call(path_596988, query_596989, nil, nil, nil)

var permissionsListForResource* = Call_PermissionsListForResource_596976(
    name: "permissionsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/permissions",
    validator: validate_PermissionsListForResource_596977, base: "",
    url: url_PermissionsListForResource_596978, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsGetById_596990 = ref object of OpenApiRestCall_596441
proc url_RoleDefinitionsGetById_596992(protocol: Scheme; host: string; base: string;
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

proc validate_RoleDefinitionsGetById_596991(path: JsonNode; query: JsonNode;
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
  var valid_596993 = path.getOrDefault("roleDefinitionId")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "roleDefinitionId", valid_596993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596994 = query.getOrDefault("api-version")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "api-version", valid_596994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596995: Call_RoleDefinitionsGetById_596990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a role definition by ID.
  ## 
  let valid = call_596995.validator(path, query, header, formData, body)
  let scheme = call_596995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596995.url(scheme.get, call_596995.host, call_596995.base,
                         call_596995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596995, url, valid)

proc call*(call_596996: Call_RoleDefinitionsGetById_596990; apiVersion: string;
          roleDefinitionId: string): Recallable =
  ## roleDefinitionsGetById
  ## Gets a role definition by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleDefinitionId: string (required)
  ##                   : The fully qualified role definition ID. Use the format, 
  ## /subscriptions/{guid}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId} for subscription level role definitions, or /providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId} for tenant level role definitions.
  var path_596997 = newJObject()
  var query_596998 = newJObject()
  add(query_596998, "api-version", newJString(apiVersion))
  add(path_596997, "roleDefinitionId", newJString(roleDefinitionId))
  result = call_596996.call(path_596997, query_596998, nil, nil, nil)

var roleDefinitionsGetById* = Call_RoleDefinitionsGetById_596990(
    name: "roleDefinitionsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{roleDefinitionId}",
    validator: validate_RoleDefinitionsGetById_596991, base: "",
    url: url_RoleDefinitionsGetById_596992, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsList_596999 = ref object of OpenApiRestCall_596441
proc url_RoleDefinitionsList_597001(protocol: Scheme; host: string; base: string;
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

proc validate_RoleDefinitionsList_597000(path: JsonNode; query: JsonNode;
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
  var valid_597003 = path.getOrDefault("scope")
  valid_597003 = validateParameter(valid_597003, JString, required = true,
                                 default = nil)
  if valid_597003 != nil:
    section.add "scope", valid_597003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use atScopeAndBelow filter to search below the given scope as well.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597004 = query.getOrDefault("api-version")
  valid_597004 = validateParameter(valid_597004, JString, required = true,
                                 default = nil)
  if valid_597004 != nil:
    section.add "api-version", valid_597004
  var valid_597005 = query.getOrDefault("$filter")
  valid_597005 = validateParameter(valid_597005, JString, required = false,
                                 default = nil)
  if valid_597005 != nil:
    section.add "$filter", valid_597005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597006: Call_RoleDefinitionsList_596999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all role definitions that are applicable at scope and above.
  ## 
  let valid = call_597006.validator(path, query, header, formData, body)
  let scheme = call_597006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597006.url(scheme.get, call_597006.host, call_597006.base,
                         call_597006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597006, url, valid)

proc call*(call_597007: Call_RoleDefinitionsList_596999; apiVersion: string;
          scope: string; Filter: string = ""): Recallable =
  ## roleDefinitionsList
  ## Get all role definitions that are applicable at scope and above.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : The scope of the role definition.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use atScopeAndBelow filter to search below the given scope as well.
  var path_597008 = newJObject()
  var query_597009 = newJObject()
  add(query_597009, "api-version", newJString(apiVersion))
  add(path_597008, "scope", newJString(scope))
  add(query_597009, "$filter", newJString(Filter))
  result = call_597007.call(path_597008, query_597009, nil, nil, nil)

var roleDefinitionsList* = Call_RoleDefinitionsList_596999(
    name: "roleDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions",
    validator: validate_RoleDefinitionsList_597000, base: "",
    url: url_RoleDefinitionsList_597001, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsCreateOrUpdate_597020 = ref object of OpenApiRestCall_596441
proc url_RoleDefinitionsCreateOrUpdate_597022(protocol: Scheme; host: string;
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

proc validate_RoleDefinitionsCreateOrUpdate_597021(path: JsonNode; query: JsonNode;
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
  var valid_597040 = path.getOrDefault("roleDefinitionId")
  valid_597040 = validateParameter(valid_597040, JString, required = true,
                                 default = nil)
  if valid_597040 != nil:
    section.add "roleDefinitionId", valid_597040
  var valid_597041 = path.getOrDefault("scope")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = nil)
  if valid_597041 != nil:
    section.add "scope", valid_597041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597042 = query.getOrDefault("api-version")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "api-version", valid_597042
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

proc call*(call_597044: Call_RoleDefinitionsCreateOrUpdate_597020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a role definition.
  ## 
  let valid = call_597044.validator(path, query, header, formData, body)
  let scheme = call_597044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597044.url(scheme.get, call_597044.host, call_597044.base,
                         call_597044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597044, url, valid)

proc call*(call_597045: Call_RoleDefinitionsCreateOrUpdate_597020;
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
  var path_597046 = newJObject()
  var query_597047 = newJObject()
  var body_597048 = newJObject()
  add(query_597047, "api-version", newJString(apiVersion))
  if roleDefinition != nil:
    body_597048 = roleDefinition
  add(path_597046, "roleDefinitionId", newJString(roleDefinitionId))
  add(path_597046, "scope", newJString(scope))
  result = call_597045.call(path_597046, query_597047, nil, nil, body_597048)

var roleDefinitionsCreateOrUpdate* = Call_RoleDefinitionsCreateOrUpdate_597020(
    name: "roleDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}",
    validator: validate_RoleDefinitionsCreateOrUpdate_597021, base: "",
    url: url_RoleDefinitionsCreateOrUpdate_597022, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsGet_597010 = ref object of OpenApiRestCall_596441
proc url_RoleDefinitionsGet_597012(protocol: Scheme; host: string; base: string;
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

proc validate_RoleDefinitionsGet_597011(path: JsonNode; query: JsonNode;
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
  var valid_597013 = path.getOrDefault("roleDefinitionId")
  valid_597013 = validateParameter(valid_597013, JString, required = true,
                                 default = nil)
  if valid_597013 != nil:
    section.add "roleDefinitionId", valid_597013
  var valid_597014 = path.getOrDefault("scope")
  valid_597014 = validateParameter(valid_597014, JString, required = true,
                                 default = nil)
  if valid_597014 != nil:
    section.add "scope", valid_597014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597015 = query.getOrDefault("api-version")
  valid_597015 = validateParameter(valid_597015, JString, required = true,
                                 default = nil)
  if valid_597015 != nil:
    section.add "api-version", valid_597015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597016: Call_RoleDefinitionsGet_597010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get role definition by name (GUID).
  ## 
  let valid = call_597016.validator(path, query, header, formData, body)
  let scheme = call_597016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597016.url(scheme.get, call_597016.host, call_597016.base,
                         call_597016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597016, url, valid)

proc call*(call_597017: Call_RoleDefinitionsGet_597010; apiVersion: string;
          roleDefinitionId: string; scope: string): Recallable =
  ## roleDefinitionsGet
  ## Get role definition by name (GUID).
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleDefinitionId: string (required)
  ##                   : The ID of the role definition.
  ##   scope: string (required)
  ##        : The scope of the role definition.
  var path_597018 = newJObject()
  var query_597019 = newJObject()
  add(query_597019, "api-version", newJString(apiVersion))
  add(path_597018, "roleDefinitionId", newJString(roleDefinitionId))
  add(path_597018, "scope", newJString(scope))
  result = call_597017.call(path_597018, query_597019, nil, nil, nil)

var roleDefinitionsGet* = Call_RoleDefinitionsGet_597010(
    name: "roleDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}",
    validator: validate_RoleDefinitionsGet_597011, base: "",
    url: url_RoleDefinitionsGet_597012, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsDelete_597049 = ref object of OpenApiRestCall_596441
proc url_RoleDefinitionsDelete_597051(protocol: Scheme; host: string; base: string;
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

proc validate_RoleDefinitionsDelete_597050(path: JsonNode; query: JsonNode;
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
  var valid_597052 = path.getOrDefault("roleDefinitionId")
  valid_597052 = validateParameter(valid_597052, JString, required = true,
                                 default = nil)
  if valid_597052 != nil:
    section.add "roleDefinitionId", valid_597052
  var valid_597053 = path.getOrDefault("scope")
  valid_597053 = validateParameter(valid_597053, JString, required = true,
                                 default = nil)
  if valid_597053 != nil:
    section.add "scope", valid_597053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597054 = query.getOrDefault("api-version")
  valid_597054 = validateParameter(valid_597054, JString, required = true,
                                 default = nil)
  if valid_597054 != nil:
    section.add "api-version", valid_597054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597055: Call_RoleDefinitionsDelete_597049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role definition.
  ## 
  let valid = call_597055.validator(path, query, header, formData, body)
  let scheme = call_597055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597055.url(scheme.get, call_597055.host, call_597055.base,
                         call_597055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597055, url, valid)

proc call*(call_597056: Call_RoleDefinitionsDelete_597049; apiVersion: string;
          roleDefinitionId: string; scope: string): Recallable =
  ## roleDefinitionsDelete
  ## Deletes a role definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleDefinitionId: string (required)
  ##                   : The ID of the role definition to delete.
  ##   scope: string (required)
  ##        : The scope of the role definition.
  var path_597057 = newJObject()
  var query_597058 = newJObject()
  add(query_597058, "api-version", newJString(apiVersion))
  add(path_597057, "roleDefinitionId", newJString(roleDefinitionId))
  add(path_597057, "scope", newJString(scope))
  result = call_597056.call(path_597057, query_597058, nil, nil, nil)

var roleDefinitionsDelete* = Call_RoleDefinitionsDelete_597049(
    name: "roleDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}",
    validator: validate_RoleDefinitionsDelete_597050, base: "",
    url: url_RoleDefinitionsDelete_597051, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
