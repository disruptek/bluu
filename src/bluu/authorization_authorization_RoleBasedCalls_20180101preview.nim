
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AuthorizationManagementClient
## version: 2018-01-01-preview
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
  macServiceName = "authorization-authorization-RoleBasedCalls"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProviderOperationsMetadataList_596663 = ref object of OpenApiRestCall_596441
proc url_ProviderOperationsMetadataList_596665(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderOperationsMetadataList_596664(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets provider operations metadata for all resource providers.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Specifies whether to expand the values.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596825 = query.getOrDefault("api-version")
  valid_596825 = validateParameter(valid_596825, JString, required = true,
                                 default = nil)
  if valid_596825 != nil:
    section.add "api-version", valid_596825
  var valid_596839 = query.getOrDefault("$expand")
  valid_596839 = validateParameter(valid_596839, JString, required = false,
                                 default = newJString("resourceTypes"))
  if valid_596839 != nil:
    section.add "$expand", valid_596839
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596862: Call_ProviderOperationsMetadataList_596663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets provider operations metadata for all resource providers.
  ## 
  let valid = call_596862.validator(path, query, header, formData, body)
  let scheme = call_596862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596862.url(scheme.get, call_596862.host, call_596862.base,
                         call_596862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596862, url, valid)

proc call*(call_596933: Call_ProviderOperationsMetadataList_596663;
          apiVersion: string; Expand: string = "resourceTypes"): Recallable =
  ## providerOperationsMetadataList
  ## Gets provider operations metadata for all resource providers.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Specifies whether to expand the values.
  var query_596934 = newJObject()
  add(query_596934, "api-version", newJString(apiVersion))
  add(query_596934, "$expand", newJString(Expand))
  result = call_596933.call(nil, query_596934, nil, nil, nil)

var providerOperationsMetadataList* = Call_ProviderOperationsMetadataList_596663(
    name: "providerOperationsMetadataList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Authorization/providerOperations",
    validator: validate_ProviderOperationsMetadataList_596664, base: "",
    url: url_ProviderOperationsMetadataList_596665, schemes: {Scheme.Https})
type
  Call_ProviderOperationsMetadataGet_596974 = ref object of OpenApiRestCall_596441
proc url_ProviderOperationsMetadataGet_596976(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Authorization/providerOperations/"),
               (kind: VariableSegment, value: "resourceProviderNamespace")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProviderOperationsMetadataGet_596975(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets provider operations metadata for the specified resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resourceProviderNamespace` field"
  var valid_596991 = path.getOrDefault("resourceProviderNamespace")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "resourceProviderNamespace", valid_596991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Specifies whether to expand the values.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596992 = query.getOrDefault("api-version")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "api-version", valid_596992
  var valid_596993 = query.getOrDefault("$expand")
  valid_596993 = validateParameter(valid_596993, JString, required = false,
                                 default = newJString("resourceTypes"))
  if valid_596993 != nil:
    section.add "$expand", valid_596993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596994: Call_ProviderOperationsMetadataGet_596974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets provider operations metadata for the specified resource provider.
  ## 
  let valid = call_596994.validator(path, query, header, formData, body)
  let scheme = call_596994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596994.url(scheme.get, call_596994.host, call_596994.base,
                         call_596994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596994, url, valid)

proc call*(call_596995: Call_ProviderOperationsMetadataGet_596974;
          apiVersion: string; resourceProviderNamespace: string;
          Expand: string = "resourceTypes"): Recallable =
  ## providerOperationsMetadataGet
  ## Gets provider operations metadata for the specified resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Specifies whether to expand the values.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  var path_596996 = newJObject()
  var query_596997 = newJObject()
  add(query_596997, "api-version", newJString(apiVersion))
  add(query_596997, "$expand", newJString(Expand))
  add(path_596996, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_596995.call(path_596996, query_596997, nil, nil, nil)

var providerOperationsMetadataGet* = Call_ProviderOperationsMetadataGet_596974(
    name: "providerOperationsMetadataGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Authorization/providerOperations/{resourceProviderNamespace}",
    validator: validate_ProviderOperationsMetadataGet_596975, base: "",
    url: url_ProviderOperationsMetadataGet_596976, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsList_596998 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsList_597000(protocol: Scheme; host: string; base: string;
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

proc validate_RoleAssignmentsList_596999(path: JsonNode; query: JsonNode;
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
  var valid_597001 = path.getOrDefault("subscriptionId")
  valid_597001 = validateParameter(valid_597001, JString, required = true,
                                 default = nil)
  if valid_597001 != nil:
    section.add "subscriptionId", valid_597001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597002 = query.getOrDefault("api-version")
  valid_597002 = validateParameter(valid_597002, JString, required = true,
                                 default = nil)
  if valid_597002 != nil:
    section.add "api-version", valid_597002
  var valid_597003 = query.getOrDefault("$filter")
  valid_597003 = validateParameter(valid_597003, JString, required = false,
                                 default = nil)
  if valid_597003 != nil:
    section.add "$filter", valid_597003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597004: Call_RoleAssignmentsList_596998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all role assignments for the subscription.
  ## 
  let valid = call_597004.validator(path, query, header, formData, body)
  let scheme = call_597004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597004.url(scheme.get, call_597004.host, call_597004.base,
                         call_597004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597004, url, valid)

proc call*(call_597005: Call_RoleAssignmentsList_596998; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## roleAssignmentsList
  ## Gets all role assignments for the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  var path_597006 = newJObject()
  var query_597007 = newJObject()
  add(query_597007, "api-version", newJString(apiVersion))
  add(path_597006, "subscriptionId", newJString(subscriptionId))
  add(query_597007, "$filter", newJString(Filter))
  result = call_597005.call(path_597006, query_597007, nil, nil, nil)

var roleAssignmentsList* = Call_RoleAssignmentsList_596998(
    name: "roleAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/roleAssignments",
    validator: validate_RoleAssignmentsList_596999, base: "",
    url: url_RoleAssignmentsList_597000, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsListForResourceGroup_597008 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsListForResourceGroup_597010(protocol: Scheme; host: string;
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

proc validate_RoleAssignmentsListForResourceGroup_597009(path: JsonNode;
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
  var valid_597011 = path.getOrDefault("resourceGroupName")
  valid_597011 = validateParameter(valid_597011, JString, required = true,
                                 default = nil)
  if valid_597011 != nil:
    section.add "resourceGroupName", valid_597011
  var valid_597012 = path.getOrDefault("subscriptionId")
  valid_597012 = validateParameter(valid_597012, JString, required = true,
                                 default = nil)
  if valid_597012 != nil:
    section.add "subscriptionId", valid_597012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597013 = query.getOrDefault("api-version")
  valid_597013 = validateParameter(valid_597013, JString, required = true,
                                 default = nil)
  if valid_597013 != nil:
    section.add "api-version", valid_597013
  var valid_597014 = query.getOrDefault("$filter")
  valid_597014 = validateParameter(valid_597014, JString, required = false,
                                 default = nil)
  if valid_597014 != nil:
    section.add "$filter", valid_597014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597015: Call_RoleAssignmentsListForResourceGroup_597008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets role assignments for a resource group.
  ## 
  let valid = call_597015.validator(path, query, header, formData, body)
  let scheme = call_597015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597015.url(scheme.get, call_597015.host, call_597015.base,
                         call_597015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597015, url, valid)

proc call*(call_597016: Call_RoleAssignmentsListForResourceGroup_597008;
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
  var path_597017 = newJObject()
  var query_597018 = newJObject()
  add(path_597017, "resourceGroupName", newJString(resourceGroupName))
  add(query_597018, "api-version", newJString(apiVersion))
  add(path_597017, "subscriptionId", newJString(subscriptionId))
  add(query_597018, "$filter", newJString(Filter))
  result = call_597016.call(path_597017, query_597018, nil, nil, nil)

var roleAssignmentsListForResourceGroup* = Call_RoleAssignmentsListForResourceGroup_597008(
    name: "roleAssignmentsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/roleAssignments",
    validator: validate_RoleAssignmentsListForResourceGroup_597009, base: "",
    url: url_RoleAssignmentsListForResourceGroup_597010, schemes: {Scheme.Https})
type
  Call_PermissionsListForResourceGroup_597019 = ref object of OpenApiRestCall_596441
proc url_PermissionsListForResourceGroup_597021(protocol: Scheme; host: string;
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

proc validate_PermissionsListForResourceGroup_597020(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all permissions the caller has for a resource group.
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
  var valid_597022 = path.getOrDefault("resourceGroupName")
  valid_597022 = validateParameter(valid_597022, JString, required = true,
                                 default = nil)
  if valid_597022 != nil:
    section.add "resourceGroupName", valid_597022
  var valid_597023 = path.getOrDefault("subscriptionId")
  valid_597023 = validateParameter(valid_597023, JString, required = true,
                                 default = nil)
  if valid_597023 != nil:
    section.add "subscriptionId", valid_597023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597024 = query.getOrDefault("api-version")
  valid_597024 = validateParameter(valid_597024, JString, required = true,
                                 default = nil)
  if valid_597024 != nil:
    section.add "api-version", valid_597024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597025: Call_PermissionsListForResourceGroup_597019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all permissions the caller has for a resource group.
  ## 
  let valid = call_597025.validator(path, query, header, formData, body)
  let scheme = call_597025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597025.url(scheme.get, call_597025.host, call_597025.base,
                         call_597025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597025, url, valid)

proc call*(call_597026: Call_PermissionsListForResourceGroup_597019;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## permissionsListForResourceGroup
  ## Gets all permissions the caller has for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_597027 = newJObject()
  var query_597028 = newJObject()
  add(path_597027, "resourceGroupName", newJString(resourceGroupName))
  add(query_597028, "api-version", newJString(apiVersion))
  add(path_597027, "subscriptionId", newJString(subscriptionId))
  result = call_597026.call(path_597027, query_597028, nil, nil, nil)

var permissionsListForResourceGroup* = Call_PermissionsListForResourceGroup_597019(
    name: "permissionsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Authorization/permissions",
    validator: validate_PermissionsListForResourceGroup_597020, base: "",
    url: url_PermissionsListForResourceGroup_597021, schemes: {Scheme.Https})
type
  Call_PermissionsListForResource_597029 = ref object of OpenApiRestCall_596441
proc url_PermissionsListForResource_597031(protocol: Scheme; host: string;
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

proc validate_PermissionsListForResource_597030(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all permissions the caller has for a resource.
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
  ##               : The name of the resource to get the permissions for.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_597032 = path.getOrDefault("resourceType")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "resourceType", valid_597032
  var valid_597033 = path.getOrDefault("resourceGroupName")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "resourceGroupName", valid_597033
  var valid_597034 = path.getOrDefault("subscriptionId")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "subscriptionId", valid_597034
  var valid_597035 = path.getOrDefault("resourceName")
  valid_597035 = validateParameter(valid_597035, JString, required = true,
                                 default = nil)
  if valid_597035 != nil:
    section.add "resourceName", valid_597035
  var valid_597036 = path.getOrDefault("resourceProviderNamespace")
  valid_597036 = validateParameter(valid_597036, JString, required = true,
                                 default = nil)
  if valid_597036 != nil:
    section.add "resourceProviderNamespace", valid_597036
  var valid_597037 = path.getOrDefault("parentResourcePath")
  valid_597037 = validateParameter(valid_597037, JString, required = true,
                                 default = nil)
  if valid_597037 != nil:
    section.add "parentResourcePath", valid_597037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597038 = query.getOrDefault("api-version")
  valid_597038 = validateParameter(valid_597038, JString, required = true,
                                 default = nil)
  if valid_597038 != nil:
    section.add "api-version", valid_597038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597039: Call_PermissionsListForResource_597029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all permissions the caller has for a resource.
  ## 
  let valid = call_597039.validator(path, query, header, formData, body)
  let scheme = call_597039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597039.url(scheme.get, call_597039.host, call_597039.base,
                         call_597039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597039, url, valid)

proc call*(call_597040: Call_PermissionsListForResource_597029;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## permissionsListForResource
  ## Gets all permissions the caller has for a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
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
  var path_597041 = newJObject()
  var query_597042 = newJObject()
  add(path_597041, "resourceType", newJString(resourceType))
  add(path_597041, "resourceGroupName", newJString(resourceGroupName))
  add(query_597042, "api-version", newJString(apiVersion))
  add(path_597041, "subscriptionId", newJString(subscriptionId))
  add(path_597041, "resourceName", newJString(resourceName))
  add(path_597041, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_597041, "parentResourcePath", newJString(parentResourcePath))
  result = call_597040.call(path_597041, query_597042, nil, nil, nil)

var permissionsListForResource* = Call_PermissionsListForResource_597029(
    name: "permissionsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/permissions",
    validator: validate_PermissionsListForResource_597030, base: "",
    url: url_PermissionsListForResource_597031, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsListForResource_597043 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsListForResource_597045(protocol: Scheme; host: string;
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

proc validate_RoleAssignmentsListForResource_597044(path: JsonNode;
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
  var valid_597046 = path.getOrDefault("resourceType")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "resourceType", valid_597046
  var valid_597047 = path.getOrDefault("resourceGroupName")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "resourceGroupName", valid_597047
  var valid_597048 = path.getOrDefault("subscriptionId")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "subscriptionId", valid_597048
  var valid_597049 = path.getOrDefault("resourceName")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "resourceName", valid_597049
  var valid_597050 = path.getOrDefault("resourceProviderNamespace")
  valid_597050 = validateParameter(valid_597050, JString, required = true,
                                 default = nil)
  if valid_597050 != nil:
    section.add "resourceProviderNamespace", valid_597050
  var valid_597051 = path.getOrDefault("parentResourcePath")
  valid_597051 = validateParameter(valid_597051, JString, required = true,
                                 default = nil)
  if valid_597051 != nil:
    section.add "parentResourcePath", valid_597051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597052 = query.getOrDefault("api-version")
  valid_597052 = validateParameter(valid_597052, JString, required = true,
                                 default = nil)
  if valid_597052 != nil:
    section.add "api-version", valid_597052
  var valid_597053 = query.getOrDefault("$filter")
  valid_597053 = validateParameter(valid_597053, JString, required = false,
                                 default = nil)
  if valid_597053 != nil:
    section.add "$filter", valid_597053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597054: Call_RoleAssignmentsListForResource_597043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets role assignments for a resource.
  ## 
  let valid = call_597054.validator(path, query, header, formData, body)
  let scheme = call_597054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597054.url(scheme.get, call_597054.host, call_597054.base,
                         call_597054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597054, url, valid)

proc call*(call_597055: Call_RoleAssignmentsListForResource_597043;
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
  var path_597056 = newJObject()
  var query_597057 = newJObject()
  add(path_597056, "resourceType", newJString(resourceType))
  add(path_597056, "resourceGroupName", newJString(resourceGroupName))
  add(query_597057, "api-version", newJString(apiVersion))
  add(path_597056, "subscriptionId", newJString(subscriptionId))
  add(path_597056, "resourceName", newJString(resourceName))
  add(path_597056, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_597056, "parentResourcePath", newJString(parentResourcePath))
  add(query_597057, "$filter", newJString(Filter))
  result = call_597055.call(path_597056, query_597057, nil, nil, nil)

var roleAssignmentsListForResource* = Call_RoleAssignmentsListForResource_597043(
    name: "roleAssignmentsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/roleAssignments",
    validator: validate_RoleAssignmentsListForResource_597044, base: "",
    url: url_RoleAssignmentsListForResource_597045, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsCreateById_597067 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsCreateById_597069(protocol: Scheme; host: string;
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

proc validate_RoleAssignmentsCreateById_597068(path: JsonNode; query: JsonNode;
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
  var valid_597087 = path.getOrDefault("roleId")
  valid_597087 = validateParameter(valid_597087, JString, required = true,
                                 default = nil)
  if valid_597087 != nil:
    section.add "roleId", valid_597087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597088 = query.getOrDefault("api-version")
  valid_597088 = validateParameter(valid_597088, JString, required = true,
                                 default = nil)
  if valid_597088 != nil:
    section.add "api-version", valid_597088
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

proc call*(call_597090: Call_RoleAssignmentsCreateById_597067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role assignment by ID.
  ## 
  let valid = call_597090.validator(path, query, header, formData, body)
  let scheme = call_597090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597090.url(scheme.get, call_597090.host, call_597090.base,
                         call_597090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597090, url, valid)

proc call*(call_597091: Call_RoleAssignmentsCreateById_597067; apiVersion: string;
          roleId: string; parameters: JsonNode): Recallable =
  ## roleAssignmentsCreateById
  ## Creates a role assignment by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleId: string (required)
  ##         : The ID of the role assignment to create.
  ##   parameters: JObject (required)
  ##             : Parameters for the role assignment.
  var path_597092 = newJObject()
  var query_597093 = newJObject()
  var body_597094 = newJObject()
  add(query_597093, "api-version", newJString(apiVersion))
  add(path_597092, "roleId", newJString(roleId))
  if parameters != nil:
    body_597094 = parameters
  result = call_597091.call(path_597092, query_597093, nil, nil, body_597094)

var roleAssignmentsCreateById* = Call_RoleAssignmentsCreateById_597067(
    name: "roleAssignmentsCreateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{roleId}",
    validator: validate_RoleAssignmentsCreateById_597068, base: "",
    url: url_RoleAssignmentsCreateById_597069, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsGetById_597058 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsGetById_597060(protocol: Scheme; host: string; base: string;
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

proc validate_RoleAssignmentsGetById_597059(path: JsonNode; query: JsonNode;
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
  var valid_597061 = path.getOrDefault("roleId")
  valid_597061 = validateParameter(valid_597061, JString, required = true,
                                 default = nil)
  if valid_597061 != nil:
    section.add "roleId", valid_597061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597062 = query.getOrDefault("api-version")
  valid_597062 = validateParameter(valid_597062, JString, required = true,
                                 default = nil)
  if valid_597062 != nil:
    section.add "api-version", valid_597062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597063: Call_RoleAssignmentsGetById_597058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a role assignment by ID.
  ## 
  let valid = call_597063.validator(path, query, header, formData, body)
  let scheme = call_597063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597063.url(scheme.get, call_597063.host, call_597063.base,
                         call_597063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597063, url, valid)

proc call*(call_597064: Call_RoleAssignmentsGetById_597058; apiVersion: string;
          roleId: string): Recallable =
  ## roleAssignmentsGetById
  ## Gets a role assignment by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleId: string (required)
  ##         : The ID of the role assignment to get.
  var path_597065 = newJObject()
  var query_597066 = newJObject()
  add(query_597066, "api-version", newJString(apiVersion))
  add(path_597065, "roleId", newJString(roleId))
  result = call_597064.call(path_597065, query_597066, nil, nil, nil)

var roleAssignmentsGetById* = Call_RoleAssignmentsGetById_597058(
    name: "roleAssignmentsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{roleId}",
    validator: validate_RoleAssignmentsGetById_597059, base: "",
    url: url_RoleAssignmentsGetById_597060, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsDeleteById_597095 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsDeleteById_597097(protocol: Scheme; host: string;
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

proc validate_RoleAssignmentsDeleteById_597096(path: JsonNode; query: JsonNode;
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
  var valid_597098 = path.getOrDefault("roleId")
  valid_597098 = validateParameter(valid_597098, JString, required = true,
                                 default = nil)
  if valid_597098 != nil:
    section.add "roleId", valid_597098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597099 = query.getOrDefault("api-version")
  valid_597099 = validateParameter(valid_597099, JString, required = true,
                                 default = nil)
  if valid_597099 != nil:
    section.add "api-version", valid_597099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597100: Call_RoleAssignmentsDeleteById_597095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role assignment.
  ## 
  let valid = call_597100.validator(path, query, header, formData, body)
  let scheme = call_597100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597100.url(scheme.get, call_597100.host, call_597100.base,
                         call_597100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597100, url, valid)

proc call*(call_597101: Call_RoleAssignmentsDeleteById_597095; apiVersion: string;
          roleId: string): Recallable =
  ## roleAssignmentsDeleteById
  ## Deletes a role assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleId: string (required)
  ##         : The ID of the role assignment to delete.
  var path_597102 = newJObject()
  var query_597103 = newJObject()
  add(query_597103, "api-version", newJString(apiVersion))
  add(path_597102, "roleId", newJString(roleId))
  result = call_597101.call(path_597102, query_597103, nil, nil, nil)

var roleAssignmentsDeleteById* = Call_RoleAssignmentsDeleteById_597095(
    name: "roleAssignmentsDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{roleId}",
    validator: validate_RoleAssignmentsDeleteById_597096, base: "",
    url: url_RoleAssignmentsDeleteById_597097, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsListForScope_597104 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsListForScope_597106(protocol: Scheme; host: string;
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

proc validate_RoleAssignmentsListForScope_597105(path: JsonNode; query: JsonNode;
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
  var valid_597107 = path.getOrDefault("scope")
  valid_597107 = validateParameter(valid_597107, JString, required = true,
                                 default = nil)
  if valid_597107 != nil:
    section.add "scope", valid_597107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597108 = query.getOrDefault("api-version")
  valid_597108 = validateParameter(valid_597108, JString, required = true,
                                 default = nil)
  if valid_597108 != nil:
    section.add "api-version", valid_597108
  var valid_597109 = query.getOrDefault("$filter")
  valid_597109 = validateParameter(valid_597109, JString, required = false,
                                 default = nil)
  if valid_597109 != nil:
    section.add "$filter", valid_597109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597110: Call_RoleAssignmentsListForScope_597104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets role assignments for a scope.
  ## 
  let valid = call_597110.validator(path, query, header, formData, body)
  let scheme = call_597110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597110.url(scheme.get, call_597110.host, call_597110.base,
                         call_597110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597110, url, valid)

proc call*(call_597111: Call_RoleAssignmentsListForScope_597104;
          apiVersion: string; scope: string; Filter: string = ""): Recallable =
  ## roleAssignmentsListForScope
  ## Gets role assignments for a scope.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : The scope of the role assignments.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  var path_597112 = newJObject()
  var query_597113 = newJObject()
  add(query_597113, "api-version", newJString(apiVersion))
  add(path_597112, "scope", newJString(scope))
  add(query_597113, "$filter", newJString(Filter))
  result = call_597111.call(path_597112, query_597113, nil, nil, nil)

var roleAssignmentsListForScope* = Call_RoleAssignmentsListForScope_597104(
    name: "roleAssignmentsListForScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/roleAssignments",
    validator: validate_RoleAssignmentsListForScope_597105, base: "",
    url: url_RoleAssignmentsListForScope_597106, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsCreate_597124 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsCreate_597126(protocol: Scheme; host: string; base: string;
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

proc validate_RoleAssignmentsCreate_597125(path: JsonNode; query: JsonNode;
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
  var valid_597127 = path.getOrDefault("scope")
  valid_597127 = validateParameter(valid_597127, JString, required = true,
                                 default = nil)
  if valid_597127 != nil:
    section.add "scope", valid_597127
  var valid_597128 = path.getOrDefault("roleAssignmentName")
  valid_597128 = validateParameter(valid_597128, JString, required = true,
                                 default = nil)
  if valid_597128 != nil:
    section.add "roleAssignmentName", valid_597128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597129 = query.getOrDefault("api-version")
  valid_597129 = validateParameter(valid_597129, JString, required = true,
                                 default = nil)
  if valid_597129 != nil:
    section.add "api-version", valid_597129
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

proc call*(call_597131: Call_RoleAssignmentsCreate_597124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role assignment.
  ## 
  let valid = call_597131.validator(path, query, header, formData, body)
  let scheme = call_597131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597131.url(scheme.get, call_597131.host, call_597131.base,
                         call_597131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597131, url, valid)

proc call*(call_597132: Call_RoleAssignmentsCreate_597124; apiVersion: string;
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
  var path_597133 = newJObject()
  var query_597134 = newJObject()
  var body_597135 = newJObject()
  add(query_597134, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_597135 = parameters
  add(path_597133, "scope", newJString(scope))
  add(path_597133, "roleAssignmentName", newJString(roleAssignmentName))
  result = call_597132.call(path_597133, query_597134, nil, nil, body_597135)

var roleAssignmentsCreate* = Call_RoleAssignmentsCreate_597124(
    name: "roleAssignmentsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}",
    validator: validate_RoleAssignmentsCreate_597125, base: "",
    url: url_RoleAssignmentsCreate_597126, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsGet_597114 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsGet_597116(protocol: Scheme; host: string; base: string;
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

proc validate_RoleAssignmentsGet_597115(path: JsonNode; query: JsonNode;
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
  var valid_597117 = path.getOrDefault("scope")
  valid_597117 = validateParameter(valid_597117, JString, required = true,
                                 default = nil)
  if valid_597117 != nil:
    section.add "scope", valid_597117
  var valid_597118 = path.getOrDefault("roleAssignmentName")
  valid_597118 = validateParameter(valid_597118, JString, required = true,
                                 default = nil)
  if valid_597118 != nil:
    section.add "roleAssignmentName", valid_597118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597119 = query.getOrDefault("api-version")
  valid_597119 = validateParameter(valid_597119, JString, required = true,
                                 default = nil)
  if valid_597119 != nil:
    section.add "api-version", valid_597119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597120: Call_RoleAssignmentsGet_597114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified role assignment.
  ## 
  let valid = call_597120.validator(path, query, header, formData, body)
  let scheme = call_597120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597120.url(scheme.get, call_597120.host, call_597120.base,
                         call_597120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597120, url, valid)

proc call*(call_597121: Call_RoleAssignmentsGet_597114; apiVersion: string;
          scope: string; roleAssignmentName: string): Recallable =
  ## roleAssignmentsGet
  ## Get the specified role assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : The scope of the role assignment.
  ##   roleAssignmentName: string (required)
  ##                     : The name of the role assignment to get.
  var path_597122 = newJObject()
  var query_597123 = newJObject()
  add(query_597123, "api-version", newJString(apiVersion))
  add(path_597122, "scope", newJString(scope))
  add(path_597122, "roleAssignmentName", newJString(roleAssignmentName))
  result = call_597121.call(path_597122, query_597123, nil, nil, nil)

var roleAssignmentsGet* = Call_RoleAssignmentsGet_597114(
    name: "roleAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}",
    validator: validate_RoleAssignmentsGet_597115, base: "",
    url: url_RoleAssignmentsGet_597116, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsDelete_597136 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsDelete_597138(protocol: Scheme; host: string; base: string;
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

proc validate_RoleAssignmentsDelete_597137(path: JsonNode; query: JsonNode;
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
  var valid_597139 = path.getOrDefault("scope")
  valid_597139 = validateParameter(valid_597139, JString, required = true,
                                 default = nil)
  if valid_597139 != nil:
    section.add "scope", valid_597139
  var valid_597140 = path.getOrDefault("roleAssignmentName")
  valid_597140 = validateParameter(valid_597140, JString, required = true,
                                 default = nil)
  if valid_597140 != nil:
    section.add "roleAssignmentName", valid_597140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597141 = query.getOrDefault("api-version")
  valid_597141 = validateParameter(valid_597141, JString, required = true,
                                 default = nil)
  if valid_597141 != nil:
    section.add "api-version", valid_597141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597142: Call_RoleAssignmentsDelete_597136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role assignment.
  ## 
  let valid = call_597142.validator(path, query, header, formData, body)
  let scheme = call_597142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597142.url(scheme.get, call_597142.host, call_597142.base,
                         call_597142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597142, url, valid)

proc call*(call_597143: Call_RoleAssignmentsDelete_597136; apiVersion: string;
          scope: string; roleAssignmentName: string): Recallable =
  ## roleAssignmentsDelete
  ## Deletes a role assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : The scope of the role assignment to delete.
  ##   roleAssignmentName: string (required)
  ##                     : The name of the role assignment to delete.
  var path_597144 = newJObject()
  var query_597145 = newJObject()
  add(query_597145, "api-version", newJString(apiVersion))
  add(path_597144, "scope", newJString(scope))
  add(path_597144, "roleAssignmentName", newJString(roleAssignmentName))
  result = call_597143.call(path_597144, query_597145, nil, nil, nil)

var roleAssignmentsDelete* = Call_RoleAssignmentsDelete_597136(
    name: "roleAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}",
    validator: validate_RoleAssignmentsDelete_597137, base: "",
    url: url_RoleAssignmentsDelete_597138, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsList_597146 = ref object of OpenApiRestCall_596441
proc url_RoleDefinitionsList_597148(protocol: Scheme; host: string; base: string;
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

proc validate_RoleDefinitionsList_597147(path: JsonNode; query: JsonNode;
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
  var valid_597149 = path.getOrDefault("scope")
  valid_597149 = validateParameter(valid_597149, JString, required = true,
                                 default = nil)
  if valid_597149 != nil:
    section.add "scope", valid_597149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use atScopeAndBelow filter to search below the given scope as well.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597150 = query.getOrDefault("api-version")
  valid_597150 = validateParameter(valid_597150, JString, required = true,
                                 default = nil)
  if valid_597150 != nil:
    section.add "api-version", valid_597150
  var valid_597151 = query.getOrDefault("$filter")
  valid_597151 = validateParameter(valid_597151, JString, required = false,
                                 default = nil)
  if valid_597151 != nil:
    section.add "$filter", valid_597151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597152: Call_RoleDefinitionsList_597146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all role definitions that are applicable at scope and above.
  ## 
  let valid = call_597152.validator(path, query, header, formData, body)
  let scheme = call_597152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597152.url(scheme.get, call_597152.host, call_597152.base,
                         call_597152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597152, url, valid)

proc call*(call_597153: Call_RoleDefinitionsList_597146; apiVersion: string;
          scope: string; Filter: string = ""): Recallable =
  ## roleDefinitionsList
  ## Get all role definitions that are applicable at scope and above.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : The scope of the role definition.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use atScopeAndBelow filter to search below the given scope as well.
  var path_597154 = newJObject()
  var query_597155 = newJObject()
  add(query_597155, "api-version", newJString(apiVersion))
  add(path_597154, "scope", newJString(scope))
  add(query_597155, "$filter", newJString(Filter))
  result = call_597153.call(path_597154, query_597155, nil, nil, nil)

var roleDefinitionsList* = Call_RoleDefinitionsList_597146(
    name: "roleDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions",
    validator: validate_RoleDefinitionsList_597147, base: "",
    url: url_RoleDefinitionsList_597148, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsCreateOrUpdate_597166 = ref object of OpenApiRestCall_596441
proc url_RoleDefinitionsCreateOrUpdate_597168(protocol: Scheme; host: string;
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

proc validate_RoleDefinitionsCreateOrUpdate_597167(path: JsonNode; query: JsonNode;
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
  var valid_597169 = path.getOrDefault("roleDefinitionId")
  valid_597169 = validateParameter(valid_597169, JString, required = true,
                                 default = nil)
  if valid_597169 != nil:
    section.add "roleDefinitionId", valid_597169
  var valid_597170 = path.getOrDefault("scope")
  valid_597170 = validateParameter(valid_597170, JString, required = true,
                                 default = nil)
  if valid_597170 != nil:
    section.add "scope", valid_597170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597171 = query.getOrDefault("api-version")
  valid_597171 = validateParameter(valid_597171, JString, required = true,
                                 default = nil)
  if valid_597171 != nil:
    section.add "api-version", valid_597171
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

proc call*(call_597173: Call_RoleDefinitionsCreateOrUpdate_597166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a role definition.
  ## 
  let valid = call_597173.validator(path, query, header, formData, body)
  let scheme = call_597173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597173.url(scheme.get, call_597173.host, call_597173.base,
                         call_597173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597173, url, valid)

proc call*(call_597174: Call_RoleDefinitionsCreateOrUpdate_597166;
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
  var path_597175 = newJObject()
  var query_597176 = newJObject()
  var body_597177 = newJObject()
  add(query_597176, "api-version", newJString(apiVersion))
  if roleDefinition != nil:
    body_597177 = roleDefinition
  add(path_597175, "roleDefinitionId", newJString(roleDefinitionId))
  add(path_597175, "scope", newJString(scope))
  result = call_597174.call(path_597175, query_597176, nil, nil, body_597177)

var roleDefinitionsCreateOrUpdate* = Call_RoleDefinitionsCreateOrUpdate_597166(
    name: "roleDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}",
    validator: validate_RoleDefinitionsCreateOrUpdate_597167, base: "",
    url: url_RoleDefinitionsCreateOrUpdate_597168, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsGet_597156 = ref object of OpenApiRestCall_596441
proc url_RoleDefinitionsGet_597158(protocol: Scheme; host: string; base: string;
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

proc validate_RoleDefinitionsGet_597157(path: JsonNode; query: JsonNode;
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
  var valid_597159 = path.getOrDefault("roleDefinitionId")
  valid_597159 = validateParameter(valid_597159, JString, required = true,
                                 default = nil)
  if valid_597159 != nil:
    section.add "roleDefinitionId", valid_597159
  var valid_597160 = path.getOrDefault("scope")
  valid_597160 = validateParameter(valid_597160, JString, required = true,
                                 default = nil)
  if valid_597160 != nil:
    section.add "scope", valid_597160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597161 = query.getOrDefault("api-version")
  valid_597161 = validateParameter(valid_597161, JString, required = true,
                                 default = nil)
  if valid_597161 != nil:
    section.add "api-version", valid_597161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597162: Call_RoleDefinitionsGet_597156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get role definition by name (GUID).
  ## 
  let valid = call_597162.validator(path, query, header, formData, body)
  let scheme = call_597162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597162.url(scheme.get, call_597162.host, call_597162.base,
                         call_597162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597162, url, valid)

proc call*(call_597163: Call_RoleDefinitionsGet_597156; apiVersion: string;
          roleDefinitionId: string; scope: string): Recallable =
  ## roleDefinitionsGet
  ## Get role definition by name (GUID).
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleDefinitionId: string (required)
  ##                   : The ID of the role definition.
  ##   scope: string (required)
  ##        : The scope of the role definition.
  var path_597164 = newJObject()
  var query_597165 = newJObject()
  add(query_597165, "api-version", newJString(apiVersion))
  add(path_597164, "roleDefinitionId", newJString(roleDefinitionId))
  add(path_597164, "scope", newJString(scope))
  result = call_597163.call(path_597164, query_597165, nil, nil, nil)

var roleDefinitionsGet* = Call_RoleDefinitionsGet_597156(
    name: "roleDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}",
    validator: validate_RoleDefinitionsGet_597157, base: "",
    url: url_RoleDefinitionsGet_597158, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsDelete_597178 = ref object of OpenApiRestCall_596441
proc url_RoleDefinitionsDelete_597180(protocol: Scheme; host: string; base: string;
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

proc validate_RoleDefinitionsDelete_597179(path: JsonNode; query: JsonNode;
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
  var valid_597181 = path.getOrDefault("roleDefinitionId")
  valid_597181 = validateParameter(valid_597181, JString, required = true,
                                 default = nil)
  if valid_597181 != nil:
    section.add "roleDefinitionId", valid_597181
  var valid_597182 = path.getOrDefault("scope")
  valid_597182 = validateParameter(valid_597182, JString, required = true,
                                 default = nil)
  if valid_597182 != nil:
    section.add "scope", valid_597182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597183 = query.getOrDefault("api-version")
  valid_597183 = validateParameter(valid_597183, JString, required = true,
                                 default = nil)
  if valid_597183 != nil:
    section.add "api-version", valid_597183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597184: Call_RoleDefinitionsDelete_597178; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role definition.
  ## 
  let valid = call_597184.validator(path, query, header, formData, body)
  let scheme = call_597184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597184.url(scheme.get, call_597184.host, call_597184.base,
                         call_597184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597184, url, valid)

proc call*(call_597185: Call_RoleDefinitionsDelete_597178; apiVersion: string;
          roleDefinitionId: string; scope: string): Recallable =
  ## roleDefinitionsDelete
  ## Deletes a role definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleDefinitionId: string (required)
  ##                   : The ID of the role definition to delete.
  ##   scope: string (required)
  ##        : The scope of the role definition.
  var path_597186 = newJObject()
  var query_597187 = newJObject()
  add(query_597187, "api-version", newJString(apiVersion))
  add(path_597186, "roleDefinitionId", newJString(roleDefinitionId))
  add(path_597186, "scope", newJString(scope))
  result = call_597185.call(path_597186, query_597187, nil, nil, nil)

var roleDefinitionsDelete* = Call_RoleDefinitionsDelete_597178(
    name: "roleDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}",
    validator: validate_RoleDefinitionsDelete_597179, base: "",
    url: url_RoleDefinitionsDelete_597180, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
