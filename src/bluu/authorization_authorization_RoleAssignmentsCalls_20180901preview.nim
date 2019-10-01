
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AuthorizationManagementClient
## version: 2018-09-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Role based access control provides you a way to apply granular level policy administration down to individual resources or resource groups. These operations enable you to manage role assignments. A role assignment grants access to Azure Active Directory users.
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
  macServiceName = "authorization-authorization-RoleAssignmentsCalls"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RoleAssignmentsList_596663 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsList_596665(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Authorization/roleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsList_596664(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets all role assignments for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_596839 = path.getOrDefault("subscriptionId")
  valid_596839 = validateParameter(valid_596839, JString, required = true,
                                 default = nil)
  if valid_596839 != nil:
    section.add "subscriptionId", valid_596839
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596840 = query.getOrDefault("api-version")
  valid_596840 = validateParameter(valid_596840, JString, required = true,
                                 default = nil)
  if valid_596840 != nil:
    section.add "api-version", valid_596840
  var valid_596841 = query.getOrDefault("$filter")
  valid_596841 = validateParameter(valid_596841, JString, required = false,
                                 default = nil)
  if valid_596841 != nil:
    section.add "$filter", valid_596841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596864: Call_RoleAssignmentsList_596663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all role assignments for the subscription.
  ## 
  let valid = call_596864.validator(path, query, header, formData, body)
  let scheme = call_596864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596864.url(scheme.get, call_596864.host, call_596864.base,
                         call_596864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596864, url, valid)

proc call*(call_596935: Call_RoleAssignmentsList_596663; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## roleAssignmentsList
  ## Gets all role assignments for the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  var path_596936 = newJObject()
  var query_596938 = newJObject()
  add(query_596938, "api-version", newJString(apiVersion))
  add(path_596936, "subscriptionId", newJString(subscriptionId))
  add(query_596938, "$filter", newJString(Filter))
  result = call_596935.call(path_596936, query_596938, nil, nil, nil)

var roleAssignmentsList* = Call_RoleAssignmentsList_596663(
    name: "roleAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/roleAssignments",
    validator: validate_RoleAssignmentsList_596664, base: "",
    url: url_RoleAssignmentsList_596665, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsListForResourceGroup_596977 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsListForResourceGroup_596979(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Authorization/roleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsListForResourceGroup_596978(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets role assignments for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596982 = query.getOrDefault("api-version")
  valid_596982 = validateParameter(valid_596982, JString, required = true,
                                 default = nil)
  if valid_596982 != nil:
    section.add "api-version", valid_596982
  var valid_596983 = query.getOrDefault("$filter")
  valid_596983 = validateParameter(valid_596983, JString, required = false,
                                 default = nil)
  if valid_596983 != nil:
    section.add "$filter", valid_596983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596984: Call_RoleAssignmentsListForResourceGroup_596977;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets role assignments for a resource group.
  ## 
  let valid = call_596984.validator(path, query, header, formData, body)
  let scheme = call_596984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596984.url(scheme.get, call_596984.host, call_596984.base,
                         call_596984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596984, url, valid)

proc call*(call_596985: Call_RoleAssignmentsListForResourceGroup_596977;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## roleAssignmentsListForResourceGroup
  ## Gets role assignments for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  var path_596986 = newJObject()
  var query_596987 = newJObject()
  add(path_596986, "resourceGroupName", newJString(resourceGroupName))
  add(query_596987, "api-version", newJString(apiVersion))
  add(path_596986, "subscriptionId", newJString(subscriptionId))
  add(query_596987, "$filter", newJString(Filter))
  result = call_596985.call(path_596986, query_596987, nil, nil, nil)

var roleAssignmentsListForResourceGroup* = Call_RoleAssignmentsListForResourceGroup_596977(
    name: "roleAssignmentsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/roleAssignments",
    validator: validate_RoleAssignmentsListForResourceGroup_596978, base: "",
    url: url_RoleAssignmentsListForResourceGroup_596979, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsListForResource_596988 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsListForResource_596990(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Authorization/roleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsListForResource_596989(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets role assignments for a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to get role assignments for.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_596991 = path.getOrDefault("resourceType")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "resourceType", valid_596991
  var valid_596992 = path.getOrDefault("resourceGroupName")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "resourceGroupName", valid_596992
  var valid_596993 = path.getOrDefault("subscriptionId")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "subscriptionId", valid_596993
  var valid_596994 = path.getOrDefault("resourceName")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "resourceName", valid_596994
  var valid_596995 = path.getOrDefault("resourceProviderNamespace")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "resourceProviderNamespace", valid_596995
  var valid_596996 = path.getOrDefault("parentResourcePath")
  valid_596996 = validateParameter(valid_596996, JString, required = true,
                                 default = nil)
  if valid_596996 != nil:
    section.add "parentResourcePath", valid_596996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596997 = query.getOrDefault("api-version")
  valid_596997 = validateParameter(valid_596997, JString, required = true,
                                 default = nil)
  if valid_596997 != nil:
    section.add "api-version", valid_596997
  var valid_596998 = query.getOrDefault("$filter")
  valid_596998 = validateParameter(valid_596998, JString, required = false,
                                 default = nil)
  if valid_596998 != nil:
    section.add "$filter", valid_596998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596999: Call_RoleAssignmentsListForResource_596988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets role assignments for a resource.
  ## 
  let valid = call_596999.validator(path, query, header, formData, body)
  let scheme = call_596999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596999.url(scheme.get, call_596999.host, call_596999.base,
                         call_596999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596999, url, valid)

proc call*(call_597000: Call_RoleAssignmentsListForResource_596988;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          resourceProviderNamespace: string; parentResourcePath: string;
          Filter: string = ""): Recallable =
  ## roleAssignmentsListForResource
  ## Gets role assignments for a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to get role assignments for.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  var path_597001 = newJObject()
  var query_597002 = newJObject()
  add(path_597001, "resourceType", newJString(resourceType))
  add(path_597001, "resourceGroupName", newJString(resourceGroupName))
  add(query_597002, "api-version", newJString(apiVersion))
  add(path_597001, "subscriptionId", newJString(subscriptionId))
  add(path_597001, "resourceName", newJString(resourceName))
  add(path_597001, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_597001, "parentResourcePath", newJString(parentResourcePath))
  add(query_597002, "$filter", newJString(Filter))
  result = call_597000.call(path_597001, query_597002, nil, nil, nil)

var roleAssignmentsListForResource* = Call_RoleAssignmentsListForResource_596988(
    name: "roleAssignmentsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/roleAssignments",
    validator: validate_RoleAssignmentsListForResource_596989, base: "",
    url: url_RoleAssignmentsListForResource_596990, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsCreateById_597012 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsCreateById_597014(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsCreateById_597013(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a role assignment by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleId: JString (required)
  ##         : The ID of the role assignment to create.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `roleId` field"
  var valid_597032 = path.getOrDefault("roleId")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "roleId", valid_597032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597033 = query.getOrDefault("api-version")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "api-version", valid_597033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for the role assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597035: Call_RoleAssignmentsCreateById_597012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role assignment by ID.
  ## 
  let valid = call_597035.validator(path, query, header, formData, body)
  let scheme = call_597035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597035.url(scheme.get, call_597035.host, call_597035.base,
                         call_597035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597035, url, valid)

proc call*(call_597036: Call_RoleAssignmentsCreateById_597012; apiVersion: string;
          roleId: string; parameters: JsonNode): Recallable =
  ## roleAssignmentsCreateById
  ## Creates a role assignment by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleId: string (required)
  ##         : The ID of the role assignment to create.
  ##   parameters: JObject (required)
  ##             : Parameters for the role assignment.
  var path_597037 = newJObject()
  var query_597038 = newJObject()
  var body_597039 = newJObject()
  add(query_597038, "api-version", newJString(apiVersion))
  add(path_597037, "roleId", newJString(roleId))
  if parameters != nil:
    body_597039 = parameters
  result = call_597036.call(path_597037, query_597038, nil, nil, body_597039)

var roleAssignmentsCreateById* = Call_RoleAssignmentsCreateById_597012(
    name: "roleAssignmentsCreateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{roleId}",
    validator: validate_RoleAssignmentsCreateById_597013, base: "",
    url: url_RoleAssignmentsCreateById_597014, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsGetById_597003 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsGetById_597005(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsGetById_597004(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a role assignment by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleId: JString (required)
  ##         : The ID of the role assignment to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `roleId` field"
  var valid_597006 = path.getOrDefault("roleId")
  valid_597006 = validateParameter(valid_597006, JString, required = true,
                                 default = nil)
  if valid_597006 != nil:
    section.add "roleId", valid_597006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597007 = query.getOrDefault("api-version")
  valid_597007 = validateParameter(valid_597007, JString, required = true,
                                 default = nil)
  if valid_597007 != nil:
    section.add "api-version", valid_597007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597008: Call_RoleAssignmentsGetById_597003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a role assignment by ID.
  ## 
  let valid = call_597008.validator(path, query, header, formData, body)
  let scheme = call_597008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597008.url(scheme.get, call_597008.host, call_597008.base,
                         call_597008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597008, url, valid)

proc call*(call_597009: Call_RoleAssignmentsGetById_597003; apiVersion: string;
          roleId: string): Recallable =
  ## roleAssignmentsGetById
  ## Gets a role assignment by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleId: string (required)
  ##         : The ID of the role assignment to get.
  var path_597010 = newJObject()
  var query_597011 = newJObject()
  add(query_597011, "api-version", newJString(apiVersion))
  add(path_597010, "roleId", newJString(roleId))
  result = call_597009.call(path_597010, query_597011, nil, nil, nil)

var roleAssignmentsGetById* = Call_RoleAssignmentsGetById_597003(
    name: "roleAssignmentsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{roleId}",
    validator: validate_RoleAssignmentsGetById_597004, base: "",
    url: url_RoleAssignmentsGetById_597005, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsDeleteById_597040 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsDeleteById_597042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsDeleteById_597041(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a role assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleId: JString (required)
  ##         : The ID of the role assignment to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `roleId` field"
  var valid_597043 = path.getOrDefault("roleId")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "roleId", valid_597043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597044 = query.getOrDefault("api-version")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "api-version", valid_597044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597045: Call_RoleAssignmentsDeleteById_597040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role assignment.
  ## 
  let valid = call_597045.validator(path, query, header, formData, body)
  let scheme = call_597045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597045.url(scheme.get, call_597045.host, call_597045.base,
                         call_597045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597045, url, valid)

proc call*(call_597046: Call_RoleAssignmentsDeleteById_597040; apiVersion: string;
          roleId: string): Recallable =
  ## roleAssignmentsDeleteById
  ## Deletes a role assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleId: string (required)
  ##         : The ID of the role assignment to delete.
  var path_597047 = newJObject()
  var query_597048 = newJObject()
  add(query_597048, "api-version", newJString(apiVersion))
  add(path_597047, "roleId", newJString(roleId))
  result = call_597046.call(path_597047, query_597048, nil, nil, nil)

var roleAssignmentsDeleteById* = Call_RoleAssignmentsDeleteById_597040(
    name: "roleAssignmentsDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{roleId}",
    validator: validate_RoleAssignmentsDeleteById_597041, base: "",
    url: url_RoleAssignmentsDeleteById_597042, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsListForScope_597049 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsListForScope_597051(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/roleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsListForScope_597050(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets role assignments for a scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the role assignments.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_597052 = path.getOrDefault("scope")
  valid_597052 = validateParameter(valid_597052, JString, required = true,
                                 default = nil)
  if valid_597052 != nil:
    section.add "scope", valid_597052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597053 = query.getOrDefault("api-version")
  valid_597053 = validateParameter(valid_597053, JString, required = true,
                                 default = nil)
  if valid_597053 != nil:
    section.add "api-version", valid_597053
  var valid_597054 = query.getOrDefault("$filter")
  valid_597054 = validateParameter(valid_597054, JString, required = false,
                                 default = nil)
  if valid_597054 != nil:
    section.add "$filter", valid_597054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597055: Call_RoleAssignmentsListForScope_597049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets role assignments for a scope.
  ## 
  let valid = call_597055.validator(path, query, header, formData, body)
  let scheme = call_597055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597055.url(scheme.get, call_597055.host, call_597055.base,
                         call_597055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597055, url, valid)

proc call*(call_597056: Call_RoleAssignmentsListForScope_597049;
          apiVersion: string; scope: string; Filter: string = ""): Recallable =
  ## roleAssignmentsListForScope
  ## Gets role assignments for a scope.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : The scope of the role assignments.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  var path_597057 = newJObject()
  var query_597058 = newJObject()
  add(query_597058, "api-version", newJString(apiVersion))
  add(path_597057, "scope", newJString(scope))
  add(query_597058, "$filter", newJString(Filter))
  result = call_597056.call(path_597057, query_597058, nil, nil, nil)

var roleAssignmentsListForScope* = Call_RoleAssignmentsListForScope_597049(
    name: "roleAssignmentsListForScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/roleAssignments",
    validator: validate_RoleAssignmentsListForScope_597050, base: "",
    url: url_RoleAssignmentsListForScope_597051, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsCreate_597069 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsCreate_597071(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "roleAssignmentName" in path,
        "`roleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/roleAssignments/"),
               (kind: VariableSegment, value: "roleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsCreate_597070(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a role assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the role assignment to create. The scope can be any REST resource instance. For example, use '/subscriptions/{subscription-id}/' for a subscription, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for a resource group, and 
  ## '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider}/{resource-type}/{resource-name}' for a resource.
  ##   roleAssignmentName: JString (required)
  ##                     : The name of the role assignment to create. It can be any valid GUID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_597072 = path.getOrDefault("scope")
  valid_597072 = validateParameter(valid_597072, JString, required = true,
                                 default = nil)
  if valid_597072 != nil:
    section.add "scope", valid_597072
  var valid_597073 = path.getOrDefault("roleAssignmentName")
  valid_597073 = validateParameter(valid_597073, JString, required = true,
                                 default = nil)
  if valid_597073 != nil:
    section.add "roleAssignmentName", valid_597073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597074 = query.getOrDefault("api-version")
  valid_597074 = validateParameter(valid_597074, JString, required = true,
                                 default = nil)
  if valid_597074 != nil:
    section.add "api-version", valid_597074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for the role assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597076: Call_RoleAssignmentsCreate_597069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role assignment.
  ## 
  let valid = call_597076.validator(path, query, header, formData, body)
  let scheme = call_597076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597076.url(scheme.get, call_597076.host, call_597076.base,
                         call_597076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597076, url, valid)

proc call*(call_597077: Call_RoleAssignmentsCreate_597069; apiVersion: string;
          parameters: JsonNode; scope: string; roleAssignmentName: string): Recallable =
  ## roleAssignmentsCreate
  ## Creates a role assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   parameters: JObject (required)
  ##             : Parameters for the role assignment.
  ##   scope: string (required)
  ##        : The scope of the role assignment to create. The scope can be any REST resource instance. For example, use '/subscriptions/{subscription-id}/' for a subscription, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for a resource group, and 
  ## '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider}/{resource-type}/{resource-name}' for a resource.
  ##   roleAssignmentName: string (required)
  ##                     : The name of the role assignment to create. It can be any valid GUID.
  var path_597078 = newJObject()
  var query_597079 = newJObject()
  var body_597080 = newJObject()
  add(query_597079, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_597080 = parameters
  add(path_597078, "scope", newJString(scope))
  add(path_597078, "roleAssignmentName", newJString(roleAssignmentName))
  result = call_597077.call(path_597078, query_597079, nil, nil, body_597080)

var roleAssignmentsCreate* = Call_RoleAssignmentsCreate_597069(
    name: "roleAssignmentsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}",
    validator: validate_RoleAssignmentsCreate_597070, base: "",
    url: url_RoleAssignmentsCreate_597071, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsGet_597059 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsGet_597061(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "roleAssignmentName" in path,
        "`roleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/roleAssignments/"),
               (kind: VariableSegment, value: "roleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsGet_597060(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the specified role assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the role assignment.
  ##   roleAssignmentName: JString (required)
  ##                     : The name of the role assignment to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_597062 = path.getOrDefault("scope")
  valid_597062 = validateParameter(valid_597062, JString, required = true,
                                 default = nil)
  if valid_597062 != nil:
    section.add "scope", valid_597062
  var valid_597063 = path.getOrDefault("roleAssignmentName")
  valid_597063 = validateParameter(valid_597063, JString, required = true,
                                 default = nil)
  if valid_597063 != nil:
    section.add "roleAssignmentName", valid_597063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597064 = query.getOrDefault("api-version")
  valid_597064 = validateParameter(valid_597064, JString, required = true,
                                 default = nil)
  if valid_597064 != nil:
    section.add "api-version", valid_597064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597065: Call_RoleAssignmentsGet_597059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified role assignment.
  ## 
  let valid = call_597065.validator(path, query, header, formData, body)
  let scheme = call_597065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597065.url(scheme.get, call_597065.host, call_597065.base,
                         call_597065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597065, url, valid)

proc call*(call_597066: Call_RoleAssignmentsGet_597059; apiVersion: string;
          scope: string; roleAssignmentName: string): Recallable =
  ## roleAssignmentsGet
  ## Get the specified role assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : The scope of the role assignment.
  ##   roleAssignmentName: string (required)
  ##                     : The name of the role assignment to get.
  var path_597067 = newJObject()
  var query_597068 = newJObject()
  add(query_597068, "api-version", newJString(apiVersion))
  add(path_597067, "scope", newJString(scope))
  add(path_597067, "roleAssignmentName", newJString(roleAssignmentName))
  result = call_597066.call(path_597067, query_597068, nil, nil, nil)

var roleAssignmentsGet* = Call_RoleAssignmentsGet_597059(
    name: "roleAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}",
    validator: validate_RoleAssignmentsGet_597060, base: "",
    url: url_RoleAssignmentsGet_597061, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsDelete_597081 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsDelete_597083(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "roleAssignmentName" in path,
        "`roleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/roleAssignments/"),
               (kind: VariableSegment, value: "roleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsDelete_597082(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a role assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the role assignment to delete.
  ##   roleAssignmentName: JString (required)
  ##                     : The name of the role assignment to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_597084 = path.getOrDefault("scope")
  valid_597084 = validateParameter(valid_597084, JString, required = true,
                                 default = nil)
  if valid_597084 != nil:
    section.add "scope", valid_597084
  var valid_597085 = path.getOrDefault("roleAssignmentName")
  valid_597085 = validateParameter(valid_597085, JString, required = true,
                                 default = nil)
  if valid_597085 != nil:
    section.add "roleAssignmentName", valid_597085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597086 = query.getOrDefault("api-version")
  valid_597086 = validateParameter(valid_597086, JString, required = true,
                                 default = nil)
  if valid_597086 != nil:
    section.add "api-version", valid_597086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597087: Call_RoleAssignmentsDelete_597081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role assignment.
  ## 
  let valid = call_597087.validator(path, query, header, formData, body)
  let scheme = call_597087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597087.url(scheme.get, call_597087.host, call_597087.base,
                         call_597087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597087, url, valid)

proc call*(call_597088: Call_RoleAssignmentsDelete_597081; apiVersion: string;
          scope: string; roleAssignmentName: string): Recallable =
  ## roleAssignmentsDelete
  ## Deletes a role assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : The scope of the role assignment to delete.
  ##   roleAssignmentName: string (required)
  ##                     : The name of the role assignment to delete.
  var path_597089 = newJObject()
  var query_597090 = newJObject()
  add(query_597090, "api-version", newJString(apiVersion))
  add(path_597089, "scope", newJString(scope))
  add(path_597089, "roleAssignmentName", newJString(roleAssignmentName))
  result = call_597088.call(path_597089, query_597090, nil, nil, nil)

var roleAssignmentsDelete* = Call_RoleAssignmentsDelete_597081(
    name: "roleAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}",
    validator: validate_RoleAssignmentsDelete_597082, base: "",
    url: url_RoleAssignmentsDelete_597083, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
