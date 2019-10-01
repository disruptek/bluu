
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
  macServiceName = "authorization"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ElevateAccessPost_596663 = ref object of OpenApiRestCall_596441
proc url_ElevateAccessPost_596665(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ElevateAccessPost_596664(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Elevates access for a Global Administrator.
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
  var valid_596824 = query.getOrDefault("api-version")
  valid_596824 = validateParameter(valid_596824, JString, required = true,
                                 default = nil)
  if valid_596824 != nil:
    section.add "api-version", valid_596824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596847: Call_ElevateAccessPost_596663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Elevates access for a Global Administrator.
  ## 
  let valid = call_596847.validator(path, query, header, formData, body)
  let scheme = call_596847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596847.url(scheme.get, call_596847.host, call_596847.base,
                         call_596847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596847, url, valid)

proc call*(call_596918: Call_ElevateAccessPost_596663; apiVersion: string): Recallable =
  ## elevateAccessPost
  ## Elevates access for a Global Administrator.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_596919 = newJObject()
  add(query_596919, "api-version", newJString(apiVersion))
  result = call_596918.call(nil, query_596919, nil, nil, nil)

var elevateAccessPost* = Call_ElevateAccessPost_596663(name: "elevateAccessPost",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.Authorization/elevateAccess",
    validator: validate_ElevateAccessPost_596664, base: "",
    url: url_ElevateAccessPost_596665, schemes: {Scheme.Https})
type
  Call_ProviderOperationsMetadataList_596959 = ref object of OpenApiRestCall_596441
proc url_ProviderOperationsMetadataList_596961(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderOperationsMetadataList_596960(path: JsonNode;
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
  var valid_596963 = query.getOrDefault("api-version")
  valid_596963 = validateParameter(valid_596963, JString, required = true,
                                 default = nil)
  if valid_596963 != nil:
    section.add "api-version", valid_596963
  var valid_596977 = query.getOrDefault("$expand")
  valid_596977 = validateParameter(valid_596977, JString, required = false,
                                 default = newJString("resourceTypes"))
  if valid_596977 != nil:
    section.add "$expand", valid_596977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596978: Call_ProviderOperationsMetadataList_596959; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets provider operations metadata for all resource providers.
  ## 
  let valid = call_596978.validator(path, query, header, formData, body)
  let scheme = call_596978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596978.url(scheme.get, call_596978.host, call_596978.base,
                         call_596978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596978, url, valid)

proc call*(call_596979: Call_ProviderOperationsMetadataList_596959;
          apiVersion: string; Expand: string = "resourceTypes"): Recallable =
  ## providerOperationsMetadataList
  ## Gets provider operations metadata for all resource providers.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Specifies whether to expand the values.
  var query_596980 = newJObject()
  add(query_596980, "api-version", newJString(apiVersion))
  add(query_596980, "$expand", newJString(Expand))
  result = call_596979.call(nil, query_596980, nil, nil, nil)

var providerOperationsMetadataList* = Call_ProviderOperationsMetadataList_596959(
    name: "providerOperationsMetadataList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Authorization/providerOperations",
    validator: validate_ProviderOperationsMetadataList_596960, base: "",
    url: url_ProviderOperationsMetadataList_596961, schemes: {Scheme.Https})
type
  Call_ProviderOperationsMetadataGet_596981 = ref object of OpenApiRestCall_596441
proc url_ProviderOperationsMetadataGet_596983(protocol: Scheme; host: string;
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

proc validate_ProviderOperationsMetadataGet_596982(path: JsonNode; query: JsonNode;
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
  var valid_596998 = path.getOrDefault("resourceProviderNamespace")
  valid_596998 = validateParameter(valid_596998, JString, required = true,
                                 default = nil)
  if valid_596998 != nil:
    section.add "resourceProviderNamespace", valid_596998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $expand: JString
  ##          : Specifies whether to expand the values.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596999 = query.getOrDefault("api-version")
  valid_596999 = validateParameter(valid_596999, JString, required = true,
                                 default = nil)
  if valid_596999 != nil:
    section.add "api-version", valid_596999
  var valid_597000 = query.getOrDefault("$expand")
  valid_597000 = validateParameter(valid_597000, JString, required = false,
                                 default = newJString("resourceTypes"))
  if valid_597000 != nil:
    section.add "$expand", valid_597000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597001: Call_ProviderOperationsMetadataGet_596981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets provider operations metadata for the specified resource provider.
  ## 
  let valid = call_597001.validator(path, query, header, formData, body)
  let scheme = call_597001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597001.url(scheme.get, call_597001.host, call_597001.base,
                         call_597001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597001, url, valid)

proc call*(call_597002: Call_ProviderOperationsMetadataGet_596981;
          apiVersion: string; resourceProviderNamespace: string;
          Expand: string = "resourceTypes"): Recallable =
  ## providerOperationsMetadataGet
  ## Gets provider operations metadata for the specified resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   Expand: string
  ##         : Specifies whether to expand the values.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  var path_597003 = newJObject()
  var query_597004 = newJObject()
  add(query_597004, "api-version", newJString(apiVersion))
  add(query_597004, "$expand", newJString(Expand))
  add(path_597003, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_597002.call(path_597003, query_597004, nil, nil, nil)

var providerOperationsMetadataGet* = Call_ProviderOperationsMetadataGet_596981(
    name: "providerOperationsMetadataGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Authorization/providerOperations/{resourceProviderNamespace}",
    validator: validate_ProviderOperationsMetadataGet_596982, base: "",
    url: url_ProviderOperationsMetadataGet_596983, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsList_597005 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsList_597007(protocol: Scheme; host: string; base: string;
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

proc validate_RoleAssignmentsList_597006(path: JsonNode; query: JsonNode;
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
  var valid_597008 = path.getOrDefault("subscriptionId")
  valid_597008 = validateParameter(valid_597008, JString, required = true,
                                 default = nil)
  if valid_597008 != nil:
    section.add "subscriptionId", valid_597008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597009 = query.getOrDefault("api-version")
  valid_597009 = validateParameter(valid_597009, JString, required = true,
                                 default = nil)
  if valid_597009 != nil:
    section.add "api-version", valid_597009
  var valid_597010 = query.getOrDefault("$filter")
  valid_597010 = validateParameter(valid_597010, JString, required = false,
                                 default = nil)
  if valid_597010 != nil:
    section.add "$filter", valid_597010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597011: Call_RoleAssignmentsList_597005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all role assignments for the subscription.
  ## 
  let valid = call_597011.validator(path, query, header, formData, body)
  let scheme = call_597011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597011.url(scheme.get, call_597011.host, call_597011.base,
                         call_597011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597011, url, valid)

proc call*(call_597012: Call_RoleAssignmentsList_597005; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## roleAssignmentsList
  ## Gets all role assignments for the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  var path_597013 = newJObject()
  var query_597014 = newJObject()
  add(query_597014, "api-version", newJString(apiVersion))
  add(path_597013, "subscriptionId", newJString(subscriptionId))
  add(query_597014, "$filter", newJString(Filter))
  result = call_597012.call(path_597013, query_597014, nil, nil, nil)

var roleAssignmentsList* = Call_RoleAssignmentsList_597005(
    name: "roleAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/roleAssignments",
    validator: validate_RoleAssignmentsList_597006, base: "",
    url: url_RoleAssignmentsList_597007, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsListForResourceGroup_597015 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsListForResourceGroup_597017(protocol: Scheme; host: string;
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

proc validate_RoleAssignmentsListForResourceGroup_597016(path: JsonNode;
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
  var valid_597018 = path.getOrDefault("resourceGroupName")
  valid_597018 = validateParameter(valid_597018, JString, required = true,
                                 default = nil)
  if valid_597018 != nil:
    section.add "resourceGroupName", valid_597018
  var valid_597019 = path.getOrDefault("subscriptionId")
  valid_597019 = validateParameter(valid_597019, JString, required = true,
                                 default = nil)
  if valid_597019 != nil:
    section.add "subscriptionId", valid_597019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597020 = query.getOrDefault("api-version")
  valid_597020 = validateParameter(valid_597020, JString, required = true,
                                 default = nil)
  if valid_597020 != nil:
    section.add "api-version", valid_597020
  var valid_597021 = query.getOrDefault("$filter")
  valid_597021 = validateParameter(valid_597021, JString, required = false,
                                 default = nil)
  if valid_597021 != nil:
    section.add "$filter", valid_597021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597022: Call_RoleAssignmentsListForResourceGroup_597015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets role assignments for a resource group.
  ## 
  let valid = call_597022.validator(path, query, header, formData, body)
  let scheme = call_597022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597022.url(scheme.get, call_597022.host, call_597022.base,
                         call_597022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597022, url, valid)

proc call*(call_597023: Call_RoleAssignmentsListForResourceGroup_597015;
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
  var path_597024 = newJObject()
  var query_597025 = newJObject()
  add(path_597024, "resourceGroupName", newJString(resourceGroupName))
  add(query_597025, "api-version", newJString(apiVersion))
  add(path_597024, "subscriptionId", newJString(subscriptionId))
  add(query_597025, "$filter", newJString(Filter))
  result = call_597023.call(path_597024, query_597025, nil, nil, nil)

var roleAssignmentsListForResourceGroup* = Call_RoleAssignmentsListForResourceGroup_597015(
    name: "roleAssignmentsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/roleAssignments",
    validator: validate_RoleAssignmentsListForResourceGroup_597016, base: "",
    url: url_RoleAssignmentsListForResourceGroup_597017, schemes: {Scheme.Https})
type
  Call_PermissionsListForResourceGroup_597026 = ref object of OpenApiRestCall_596441
proc url_PermissionsListForResourceGroup_597028(protocol: Scheme; host: string;
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

proc validate_PermissionsListForResourceGroup_597027(path: JsonNode;
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
  var valid_597029 = path.getOrDefault("resourceGroupName")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "resourceGroupName", valid_597029
  var valid_597030 = path.getOrDefault("subscriptionId")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "subscriptionId", valid_597030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597031 = query.getOrDefault("api-version")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "api-version", valid_597031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597032: Call_PermissionsListForResourceGroup_597026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all permissions the caller has for a resource group.
  ## 
  let valid = call_597032.validator(path, query, header, formData, body)
  let scheme = call_597032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597032.url(scheme.get, call_597032.host, call_597032.base,
                         call_597032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597032, url, valid)

proc call*(call_597033: Call_PermissionsListForResourceGroup_597026;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## permissionsListForResourceGroup
  ## Gets all permissions the caller has for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get the permissions for. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_597034 = newJObject()
  var query_597035 = newJObject()
  add(path_597034, "resourceGroupName", newJString(resourceGroupName))
  add(query_597035, "api-version", newJString(apiVersion))
  add(path_597034, "subscriptionId", newJString(subscriptionId))
  result = call_597033.call(path_597034, query_597035, nil, nil, nil)

var permissionsListForResourceGroup* = Call_PermissionsListForResourceGroup_597026(
    name: "permissionsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Authorization/permissions",
    validator: validate_PermissionsListForResourceGroup_597027, base: "",
    url: url_PermissionsListForResourceGroup_597028, schemes: {Scheme.Https})
type
  Call_PermissionsListForResource_597036 = ref object of OpenApiRestCall_596441
proc url_PermissionsListForResource_597038(protocol: Scheme; host: string;
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

proc validate_PermissionsListForResource_597037(path: JsonNode; query: JsonNode;
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
  var valid_597039 = path.getOrDefault("resourceType")
  valid_597039 = validateParameter(valid_597039, JString, required = true,
                                 default = nil)
  if valid_597039 != nil:
    section.add "resourceType", valid_597039
  var valid_597040 = path.getOrDefault("resourceGroupName")
  valid_597040 = validateParameter(valid_597040, JString, required = true,
                                 default = nil)
  if valid_597040 != nil:
    section.add "resourceGroupName", valid_597040
  var valid_597041 = path.getOrDefault("subscriptionId")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = nil)
  if valid_597041 != nil:
    section.add "subscriptionId", valid_597041
  var valid_597042 = path.getOrDefault("resourceName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "resourceName", valid_597042
  var valid_597043 = path.getOrDefault("resourceProviderNamespace")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "resourceProviderNamespace", valid_597043
  var valid_597044 = path.getOrDefault("parentResourcePath")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "parentResourcePath", valid_597044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597045 = query.getOrDefault("api-version")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "api-version", valid_597045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597046: Call_PermissionsListForResource_597036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all permissions the caller has for a resource.
  ## 
  let valid = call_597046.validator(path, query, header, formData, body)
  let scheme = call_597046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597046.url(scheme.get, call_597046.host, call_597046.base,
                         call_597046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597046, url, valid)

proc call*(call_597047: Call_PermissionsListForResource_597036;
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
  var path_597048 = newJObject()
  var query_597049 = newJObject()
  add(path_597048, "resourceType", newJString(resourceType))
  add(path_597048, "resourceGroupName", newJString(resourceGroupName))
  add(query_597049, "api-version", newJString(apiVersion))
  add(path_597048, "subscriptionId", newJString(subscriptionId))
  add(path_597048, "resourceName", newJString(resourceName))
  add(path_597048, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_597048, "parentResourcePath", newJString(parentResourcePath))
  result = call_597047.call(path_597048, query_597049, nil, nil, nil)

var permissionsListForResource* = Call_PermissionsListForResource_597036(
    name: "permissionsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/permissions",
    validator: validate_PermissionsListForResource_597037, base: "",
    url: url_PermissionsListForResource_597038, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsListForResource_597050 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsListForResource_597052(protocol: Scheme; host: string;
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

proc validate_RoleAssignmentsListForResource_597051(path: JsonNode;
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
  var valid_597053 = path.getOrDefault("resourceType")
  valid_597053 = validateParameter(valid_597053, JString, required = true,
                                 default = nil)
  if valid_597053 != nil:
    section.add "resourceType", valid_597053
  var valid_597054 = path.getOrDefault("resourceGroupName")
  valid_597054 = validateParameter(valid_597054, JString, required = true,
                                 default = nil)
  if valid_597054 != nil:
    section.add "resourceGroupName", valid_597054
  var valid_597055 = path.getOrDefault("subscriptionId")
  valid_597055 = validateParameter(valid_597055, JString, required = true,
                                 default = nil)
  if valid_597055 != nil:
    section.add "subscriptionId", valid_597055
  var valid_597056 = path.getOrDefault("resourceName")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "resourceName", valid_597056
  var valid_597057 = path.getOrDefault("resourceProviderNamespace")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "resourceProviderNamespace", valid_597057
  var valid_597058 = path.getOrDefault("parentResourcePath")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "parentResourcePath", valid_597058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597059 = query.getOrDefault("api-version")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "api-version", valid_597059
  var valid_597060 = query.getOrDefault("$filter")
  valid_597060 = validateParameter(valid_597060, JString, required = false,
                                 default = nil)
  if valid_597060 != nil:
    section.add "$filter", valid_597060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597061: Call_RoleAssignmentsListForResource_597050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets role assignments for a resource.
  ## 
  let valid = call_597061.validator(path, query, header, formData, body)
  let scheme = call_597061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597061.url(scheme.get, call_597061.host, call_597061.base,
                         call_597061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597061, url, valid)

proc call*(call_597062: Call_RoleAssignmentsListForResource_597050;
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
  var path_597063 = newJObject()
  var query_597064 = newJObject()
  add(path_597063, "resourceType", newJString(resourceType))
  add(path_597063, "resourceGroupName", newJString(resourceGroupName))
  add(query_597064, "api-version", newJString(apiVersion))
  add(path_597063, "subscriptionId", newJString(subscriptionId))
  add(path_597063, "resourceName", newJString(resourceName))
  add(path_597063, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_597063, "parentResourcePath", newJString(parentResourcePath))
  add(query_597064, "$filter", newJString(Filter))
  result = call_597062.call(path_597063, query_597064, nil, nil, nil)

var roleAssignmentsListForResource* = Call_RoleAssignmentsListForResource_597050(
    name: "roleAssignmentsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/roleAssignments",
    validator: validate_RoleAssignmentsListForResource_597051, base: "",
    url: url_RoleAssignmentsListForResource_597052, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsCreateById_597074 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsCreateById_597076(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "roleAssignmentId" in path,
        "`roleAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "roleAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsCreateById_597075(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a role assignment by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleAssignmentId: JString (required)
  ##                   : The fully qualified ID of the role assignment, including the scope, resource name and resource type. Use the format, 
  ## /{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}. Example: 
  ## /subscriptions/{subId}/resourcegroups/{rgname}//providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `roleAssignmentId` field"
  var valid_597094 = path.getOrDefault("roleAssignmentId")
  valid_597094 = validateParameter(valid_597094, JString, required = true,
                                 default = nil)
  if valid_597094 != nil:
    section.add "roleAssignmentId", valid_597094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597095 = query.getOrDefault("api-version")
  valid_597095 = validateParameter(valid_597095, JString, required = true,
                                 default = nil)
  if valid_597095 != nil:
    section.add "api-version", valid_597095
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

proc call*(call_597097: Call_RoleAssignmentsCreateById_597074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role assignment by ID.
  ## 
  let valid = call_597097.validator(path, query, header, formData, body)
  let scheme = call_597097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597097.url(scheme.get, call_597097.host, call_597097.base,
                         call_597097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597097, url, valid)

proc call*(call_597098: Call_RoleAssignmentsCreateById_597074; apiVersion: string;
          parameters: JsonNode; roleAssignmentId: string): Recallable =
  ## roleAssignmentsCreateById
  ## Creates a role assignment by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   parameters: JObject (required)
  ##             : Parameters for the role assignment.
  ##   roleAssignmentId: string (required)
  ##                   : The fully qualified ID of the role assignment, including the scope, resource name and resource type. Use the format, 
  ## /{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}. Example: 
  ## /subscriptions/{subId}/resourcegroups/{rgname}//providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}.
  var path_597099 = newJObject()
  var query_597100 = newJObject()
  var body_597101 = newJObject()
  add(query_597100, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_597101 = parameters
  add(path_597099, "roleAssignmentId", newJString(roleAssignmentId))
  result = call_597098.call(path_597099, query_597100, nil, nil, body_597101)

var roleAssignmentsCreateById* = Call_RoleAssignmentsCreateById_597074(
    name: "roleAssignmentsCreateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{roleAssignmentId}",
    validator: validate_RoleAssignmentsCreateById_597075, base: "",
    url: url_RoleAssignmentsCreateById_597076, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsGetById_597065 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsGetById_597067(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "roleAssignmentId" in path,
        "`roleAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "roleAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsGetById_597066(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a role assignment by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleAssignmentId: JString (required)
  ##                   : The fully qualified ID of the role assignment, including the scope, resource name and resource type. Use the format, 
  ## /{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}. Example: 
  ## /subscriptions/{subId}/resourcegroups/{rgname}//providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `roleAssignmentId` field"
  var valid_597068 = path.getOrDefault("roleAssignmentId")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = nil)
  if valid_597068 != nil:
    section.add "roleAssignmentId", valid_597068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597069 = query.getOrDefault("api-version")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "api-version", valid_597069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597070: Call_RoleAssignmentsGetById_597065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a role assignment by ID.
  ## 
  let valid = call_597070.validator(path, query, header, formData, body)
  let scheme = call_597070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597070.url(scheme.get, call_597070.host, call_597070.base,
                         call_597070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597070, url, valid)

proc call*(call_597071: Call_RoleAssignmentsGetById_597065; apiVersion: string;
          roleAssignmentId: string): Recallable =
  ## roleAssignmentsGetById
  ## Gets a role assignment by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleAssignmentId: string (required)
  ##                   : The fully qualified ID of the role assignment, including the scope, resource name and resource type. Use the format, 
  ## /{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}. Example: 
  ## /subscriptions/{subId}/resourcegroups/{rgname}//providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}.
  var path_597072 = newJObject()
  var query_597073 = newJObject()
  add(query_597073, "api-version", newJString(apiVersion))
  add(path_597072, "roleAssignmentId", newJString(roleAssignmentId))
  result = call_597071.call(path_597072, query_597073, nil, nil, nil)

var roleAssignmentsGetById* = Call_RoleAssignmentsGetById_597065(
    name: "roleAssignmentsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{roleAssignmentId}",
    validator: validate_RoleAssignmentsGetById_597066, base: "",
    url: url_RoleAssignmentsGetById_597067, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsDeleteById_597102 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsDeleteById_597104(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "roleAssignmentId" in path,
        "`roleAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "roleAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RoleAssignmentsDeleteById_597103(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a role assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleAssignmentId: JString (required)
  ##                   : The fully qualified ID of the role assignment, including the scope, resource name and resource type. Use the format, 
  ## /{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}. Example: 
  ## /subscriptions/{subId}/resourcegroups/{rgname}//providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `roleAssignmentId` field"
  var valid_597105 = path.getOrDefault("roleAssignmentId")
  valid_597105 = validateParameter(valid_597105, JString, required = true,
                                 default = nil)
  if valid_597105 != nil:
    section.add "roleAssignmentId", valid_597105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597106 = query.getOrDefault("api-version")
  valid_597106 = validateParameter(valid_597106, JString, required = true,
                                 default = nil)
  if valid_597106 != nil:
    section.add "api-version", valid_597106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597107: Call_RoleAssignmentsDeleteById_597102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role assignment.
  ## 
  let valid = call_597107.validator(path, query, header, formData, body)
  let scheme = call_597107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597107.url(scheme.get, call_597107.host, call_597107.base,
                         call_597107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597107, url, valid)

proc call*(call_597108: Call_RoleAssignmentsDeleteById_597102; apiVersion: string;
          roleAssignmentId: string): Recallable =
  ## roleAssignmentsDeleteById
  ## Deletes a role assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleAssignmentId: string (required)
  ##                   : The fully qualified ID of the role assignment, including the scope, resource name and resource type. Use the format, 
  ## /{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}. Example: 
  ## /subscriptions/{subId}/resourcegroups/{rgname}//providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}.
  var path_597109 = newJObject()
  var query_597110 = newJObject()
  add(query_597110, "api-version", newJString(apiVersion))
  add(path_597109, "roleAssignmentId", newJString(roleAssignmentId))
  result = call_597108.call(path_597109, query_597110, nil, nil, nil)

var roleAssignmentsDeleteById* = Call_RoleAssignmentsDeleteById_597102(
    name: "roleAssignmentsDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{roleAssignmentId}",
    validator: validate_RoleAssignmentsDeleteById_597103, base: "",
    url: url_RoleAssignmentsDeleteById_597104, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsListForScope_597111 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsListForScope_597113(protocol: Scheme; host: string;
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

proc validate_RoleAssignmentsListForScope_597112(path: JsonNode; query: JsonNode;
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
  var valid_597114 = path.getOrDefault("scope")
  valid_597114 = validateParameter(valid_597114, JString, required = true,
                                 default = nil)
  if valid_597114 != nil:
    section.add "scope", valid_597114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597115 = query.getOrDefault("api-version")
  valid_597115 = validateParameter(valid_597115, JString, required = true,
                                 default = nil)
  if valid_597115 != nil:
    section.add "api-version", valid_597115
  var valid_597116 = query.getOrDefault("$filter")
  valid_597116 = validateParameter(valid_597116, JString, required = false,
                                 default = nil)
  if valid_597116 != nil:
    section.add "$filter", valid_597116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597117: Call_RoleAssignmentsListForScope_597111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets role assignments for a scope.
  ## 
  let valid = call_597117.validator(path, query, header, formData, body)
  let scheme = call_597117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597117.url(scheme.get, call_597117.host, call_597117.base,
                         call_597117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597117, url, valid)

proc call*(call_597118: Call_RoleAssignmentsListForScope_597111;
          apiVersion: string; scope: string; Filter: string = ""): Recallable =
  ## roleAssignmentsListForScope
  ## Gets role assignments for a scope.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : The scope of the role assignments.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use $filter=atScope() to return all role assignments at or above the scope. Use $filter=principalId eq {id} to return all role assignments at, above or below the scope for the specified principal.
  var path_597119 = newJObject()
  var query_597120 = newJObject()
  add(query_597120, "api-version", newJString(apiVersion))
  add(path_597119, "scope", newJString(scope))
  add(query_597120, "$filter", newJString(Filter))
  result = call_597118.call(path_597119, query_597120, nil, nil, nil)

var roleAssignmentsListForScope* = Call_RoleAssignmentsListForScope_597111(
    name: "roleAssignmentsListForScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/roleAssignments",
    validator: validate_RoleAssignmentsListForScope_597112, base: "",
    url: url_RoleAssignmentsListForScope_597113, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsCreate_597131 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsCreate_597133(protocol: Scheme; host: string; base: string;
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

proc validate_RoleAssignmentsCreate_597132(path: JsonNode; query: JsonNode;
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
  var valid_597134 = path.getOrDefault("scope")
  valid_597134 = validateParameter(valid_597134, JString, required = true,
                                 default = nil)
  if valid_597134 != nil:
    section.add "scope", valid_597134
  var valid_597135 = path.getOrDefault("roleAssignmentName")
  valid_597135 = validateParameter(valid_597135, JString, required = true,
                                 default = nil)
  if valid_597135 != nil:
    section.add "roleAssignmentName", valid_597135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597136 = query.getOrDefault("api-version")
  valid_597136 = validateParameter(valid_597136, JString, required = true,
                                 default = nil)
  if valid_597136 != nil:
    section.add "api-version", valid_597136
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

proc call*(call_597138: Call_RoleAssignmentsCreate_597131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role assignment.
  ## 
  let valid = call_597138.validator(path, query, header, formData, body)
  let scheme = call_597138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597138.url(scheme.get, call_597138.host, call_597138.base,
                         call_597138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597138, url, valid)

proc call*(call_597139: Call_RoleAssignmentsCreate_597131; apiVersion: string;
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
  var path_597140 = newJObject()
  var query_597141 = newJObject()
  var body_597142 = newJObject()
  add(query_597141, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_597142 = parameters
  add(path_597140, "scope", newJString(scope))
  add(path_597140, "roleAssignmentName", newJString(roleAssignmentName))
  result = call_597139.call(path_597140, query_597141, nil, nil, body_597142)

var roleAssignmentsCreate* = Call_RoleAssignmentsCreate_597131(
    name: "roleAssignmentsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}",
    validator: validate_RoleAssignmentsCreate_597132, base: "",
    url: url_RoleAssignmentsCreate_597133, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsGet_597121 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsGet_597123(protocol: Scheme; host: string; base: string;
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

proc validate_RoleAssignmentsGet_597122(path: JsonNode; query: JsonNode;
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
  var valid_597124 = path.getOrDefault("scope")
  valid_597124 = validateParameter(valid_597124, JString, required = true,
                                 default = nil)
  if valid_597124 != nil:
    section.add "scope", valid_597124
  var valid_597125 = path.getOrDefault("roleAssignmentName")
  valid_597125 = validateParameter(valid_597125, JString, required = true,
                                 default = nil)
  if valid_597125 != nil:
    section.add "roleAssignmentName", valid_597125
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597126 = query.getOrDefault("api-version")
  valid_597126 = validateParameter(valid_597126, JString, required = true,
                                 default = nil)
  if valid_597126 != nil:
    section.add "api-version", valid_597126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597127: Call_RoleAssignmentsGet_597121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified role assignment.
  ## 
  let valid = call_597127.validator(path, query, header, formData, body)
  let scheme = call_597127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597127.url(scheme.get, call_597127.host, call_597127.base,
                         call_597127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597127, url, valid)

proc call*(call_597128: Call_RoleAssignmentsGet_597121; apiVersion: string;
          scope: string; roleAssignmentName: string): Recallable =
  ## roleAssignmentsGet
  ## Get the specified role assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : The scope of the role assignment.
  ##   roleAssignmentName: string (required)
  ##                     : The name of the role assignment to get.
  var path_597129 = newJObject()
  var query_597130 = newJObject()
  add(query_597130, "api-version", newJString(apiVersion))
  add(path_597129, "scope", newJString(scope))
  add(path_597129, "roleAssignmentName", newJString(roleAssignmentName))
  result = call_597128.call(path_597129, query_597130, nil, nil, nil)

var roleAssignmentsGet* = Call_RoleAssignmentsGet_597121(
    name: "roleAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}",
    validator: validate_RoleAssignmentsGet_597122, base: "",
    url: url_RoleAssignmentsGet_597123, schemes: {Scheme.Https})
type
  Call_RoleAssignmentsDelete_597143 = ref object of OpenApiRestCall_596441
proc url_RoleAssignmentsDelete_597145(protocol: Scheme; host: string; base: string;
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

proc validate_RoleAssignmentsDelete_597144(path: JsonNode; query: JsonNode;
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
  var valid_597146 = path.getOrDefault("scope")
  valid_597146 = validateParameter(valid_597146, JString, required = true,
                                 default = nil)
  if valid_597146 != nil:
    section.add "scope", valid_597146
  var valid_597147 = path.getOrDefault("roleAssignmentName")
  valid_597147 = validateParameter(valid_597147, JString, required = true,
                                 default = nil)
  if valid_597147 != nil:
    section.add "roleAssignmentName", valid_597147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597148 = query.getOrDefault("api-version")
  valid_597148 = validateParameter(valid_597148, JString, required = true,
                                 default = nil)
  if valid_597148 != nil:
    section.add "api-version", valid_597148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597149: Call_RoleAssignmentsDelete_597143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role assignment.
  ## 
  let valid = call_597149.validator(path, query, header, formData, body)
  let scheme = call_597149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597149.url(scheme.get, call_597149.host, call_597149.base,
                         call_597149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597149, url, valid)

proc call*(call_597150: Call_RoleAssignmentsDelete_597143; apiVersion: string;
          scope: string; roleAssignmentName: string): Recallable =
  ## roleAssignmentsDelete
  ## Deletes a role assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : The scope of the role assignment to delete.
  ##   roleAssignmentName: string (required)
  ##                     : The name of the role assignment to delete.
  var path_597151 = newJObject()
  var query_597152 = newJObject()
  add(query_597152, "api-version", newJString(apiVersion))
  add(path_597151, "scope", newJString(scope))
  add(path_597151, "roleAssignmentName", newJString(roleAssignmentName))
  result = call_597150.call(path_597151, query_597152, nil, nil, nil)

var roleAssignmentsDelete* = Call_RoleAssignmentsDelete_597143(
    name: "roleAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleAssignments/{roleAssignmentName}",
    validator: validate_RoleAssignmentsDelete_597144, base: "",
    url: url_RoleAssignmentsDelete_597145, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsList_597153 = ref object of OpenApiRestCall_596441
proc url_RoleDefinitionsList_597155(protocol: Scheme; host: string; base: string;
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

proc validate_RoleDefinitionsList_597154(path: JsonNode; query: JsonNode;
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
  var valid_597156 = path.getOrDefault("scope")
  valid_597156 = validateParameter(valid_597156, JString, required = true,
                                 default = nil)
  if valid_597156 != nil:
    section.add "scope", valid_597156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use atScopeAndBelow filter to search below the given scope as well.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597157 = query.getOrDefault("api-version")
  valid_597157 = validateParameter(valid_597157, JString, required = true,
                                 default = nil)
  if valid_597157 != nil:
    section.add "api-version", valid_597157
  var valid_597158 = query.getOrDefault("$filter")
  valid_597158 = validateParameter(valid_597158, JString, required = false,
                                 default = nil)
  if valid_597158 != nil:
    section.add "$filter", valid_597158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597159: Call_RoleDefinitionsList_597153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all role definitions that are applicable at scope and above.
  ## 
  let valid = call_597159.validator(path, query, header, formData, body)
  let scheme = call_597159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597159.url(scheme.get, call_597159.host, call_597159.base,
                         call_597159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597159, url, valid)

proc call*(call_597160: Call_RoleDefinitionsList_597153; apiVersion: string;
          scope: string; Filter: string = ""): Recallable =
  ## roleDefinitionsList
  ## Get all role definitions that are applicable at scope and above.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : The scope of the role definition.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use atScopeAndBelow filter to search below the given scope as well.
  var path_597161 = newJObject()
  var query_597162 = newJObject()
  add(query_597162, "api-version", newJString(apiVersion))
  add(path_597161, "scope", newJString(scope))
  add(query_597162, "$filter", newJString(Filter))
  result = call_597160.call(path_597161, query_597162, nil, nil, nil)

var roleDefinitionsList* = Call_RoleDefinitionsList_597153(
    name: "roleDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions",
    validator: validate_RoleDefinitionsList_597154, base: "",
    url: url_RoleDefinitionsList_597155, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsCreateOrUpdate_597173 = ref object of OpenApiRestCall_596441
proc url_RoleDefinitionsCreateOrUpdate_597175(protocol: Scheme; host: string;
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

proc validate_RoleDefinitionsCreateOrUpdate_597174(path: JsonNode; query: JsonNode;
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
  var valid_597176 = path.getOrDefault("roleDefinitionId")
  valid_597176 = validateParameter(valid_597176, JString, required = true,
                                 default = nil)
  if valid_597176 != nil:
    section.add "roleDefinitionId", valid_597176
  var valid_597177 = path.getOrDefault("scope")
  valid_597177 = validateParameter(valid_597177, JString, required = true,
                                 default = nil)
  if valid_597177 != nil:
    section.add "scope", valid_597177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597178 = query.getOrDefault("api-version")
  valid_597178 = validateParameter(valid_597178, JString, required = true,
                                 default = nil)
  if valid_597178 != nil:
    section.add "api-version", valid_597178
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

proc call*(call_597180: Call_RoleDefinitionsCreateOrUpdate_597173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a role definition.
  ## 
  let valid = call_597180.validator(path, query, header, formData, body)
  let scheme = call_597180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597180.url(scheme.get, call_597180.host, call_597180.base,
                         call_597180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597180, url, valid)

proc call*(call_597181: Call_RoleDefinitionsCreateOrUpdate_597173;
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
  var path_597182 = newJObject()
  var query_597183 = newJObject()
  var body_597184 = newJObject()
  add(query_597183, "api-version", newJString(apiVersion))
  if roleDefinition != nil:
    body_597184 = roleDefinition
  add(path_597182, "roleDefinitionId", newJString(roleDefinitionId))
  add(path_597182, "scope", newJString(scope))
  result = call_597181.call(path_597182, query_597183, nil, nil, body_597184)

var roleDefinitionsCreateOrUpdate* = Call_RoleDefinitionsCreateOrUpdate_597173(
    name: "roleDefinitionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}",
    validator: validate_RoleDefinitionsCreateOrUpdate_597174, base: "",
    url: url_RoleDefinitionsCreateOrUpdate_597175, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsGet_597163 = ref object of OpenApiRestCall_596441
proc url_RoleDefinitionsGet_597165(protocol: Scheme; host: string; base: string;
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

proc validate_RoleDefinitionsGet_597164(path: JsonNode; query: JsonNode;
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
  var valid_597166 = path.getOrDefault("roleDefinitionId")
  valid_597166 = validateParameter(valid_597166, JString, required = true,
                                 default = nil)
  if valid_597166 != nil:
    section.add "roleDefinitionId", valid_597166
  var valid_597167 = path.getOrDefault("scope")
  valid_597167 = validateParameter(valid_597167, JString, required = true,
                                 default = nil)
  if valid_597167 != nil:
    section.add "scope", valid_597167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597168 = query.getOrDefault("api-version")
  valid_597168 = validateParameter(valid_597168, JString, required = true,
                                 default = nil)
  if valid_597168 != nil:
    section.add "api-version", valid_597168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597169: Call_RoleDefinitionsGet_597163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get role definition by name (GUID).
  ## 
  let valid = call_597169.validator(path, query, header, formData, body)
  let scheme = call_597169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597169.url(scheme.get, call_597169.host, call_597169.base,
                         call_597169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597169, url, valid)

proc call*(call_597170: Call_RoleDefinitionsGet_597163; apiVersion: string;
          roleDefinitionId: string; scope: string): Recallable =
  ## roleDefinitionsGet
  ## Get role definition by name (GUID).
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleDefinitionId: string (required)
  ##                   : The ID of the role definition.
  ##   scope: string (required)
  ##        : The scope of the role definition.
  var path_597171 = newJObject()
  var query_597172 = newJObject()
  add(query_597172, "api-version", newJString(apiVersion))
  add(path_597171, "roleDefinitionId", newJString(roleDefinitionId))
  add(path_597171, "scope", newJString(scope))
  result = call_597170.call(path_597171, query_597172, nil, nil, nil)

var roleDefinitionsGet* = Call_RoleDefinitionsGet_597163(
    name: "roleDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}",
    validator: validate_RoleDefinitionsGet_597164, base: "",
    url: url_RoleDefinitionsGet_597165, schemes: {Scheme.Https})
type
  Call_RoleDefinitionsDelete_597185 = ref object of OpenApiRestCall_596441
proc url_RoleDefinitionsDelete_597187(protocol: Scheme; host: string; base: string;
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

proc validate_RoleDefinitionsDelete_597186(path: JsonNode; query: JsonNode;
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
  var valid_597188 = path.getOrDefault("roleDefinitionId")
  valid_597188 = validateParameter(valid_597188, JString, required = true,
                                 default = nil)
  if valid_597188 != nil:
    section.add "roleDefinitionId", valid_597188
  var valid_597189 = path.getOrDefault("scope")
  valid_597189 = validateParameter(valid_597189, JString, required = true,
                                 default = nil)
  if valid_597189 != nil:
    section.add "scope", valid_597189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597190 = query.getOrDefault("api-version")
  valid_597190 = validateParameter(valid_597190, JString, required = true,
                                 default = nil)
  if valid_597190 != nil:
    section.add "api-version", valid_597190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597191: Call_RoleDefinitionsDelete_597185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role definition.
  ## 
  let valid = call_597191.validator(path, query, header, formData, body)
  let scheme = call_597191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597191.url(scheme.get, call_597191.host, call_597191.base,
                         call_597191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597191, url, valid)

proc call*(call_597192: Call_RoleDefinitionsDelete_597185; apiVersion: string;
          roleDefinitionId: string; scope: string): Recallable =
  ## roleDefinitionsDelete
  ## Deletes a role definition.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   roleDefinitionId: string (required)
  ##                   : The ID of the role definition to delete.
  ##   scope: string (required)
  ##        : The scope of the role definition.
  var path_597193 = newJObject()
  var query_597194 = newJObject()
  add(query_597194, "api-version", newJString(apiVersion))
  add(path_597193, "roleDefinitionId", newJString(roleDefinitionId))
  add(path_597193, "scope", newJString(scope))
  result = call_597192.call(path_597193, query_597194, nil, nil, nil)

var roleDefinitionsDelete* = Call_RoleDefinitionsDelete_597185(
    name: "roleDefinitionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/roleDefinitions/{roleDefinitionId}",
    validator: validate_RoleDefinitionsDelete_597186, base: "",
    url: url_RoleDefinitionsDelete_597187, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
