
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AuthorizationManagementClient
## version: 2018-07-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Role based access control provides you a way to apply granular level policy administration down to individual resources or resource groups. These operations enable you to get deny assignments. A deny assignment describes the set of actions on resources that are denied for Azure Active Directory users.
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
  macServiceName = "authorization-authorization-DenyAssignmentGetCalls"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DenyAssignmentsList_596663 = ref object of OpenApiRestCall_596441
proc url_DenyAssignmentsList_596665(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Authorization/denyAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DenyAssignmentsList_596664(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets all deny assignments for the subscription.
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
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all deny assignments at or above the scope. Use $filter=denyAssignmentName eq '{name}' to search deny assignments by name at specified scope. Use $filter=principalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. Use $filter=gdprExportPrincipalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. This filter is different from the principalId filter as it returns not only those deny assignments that contain the specified principal is the Principals list but also those deny assignments that contain the specified principal is the ExcludePrincipals list. Additionally, when gdprExportPrincipalId filter is used, only the deny assignment name and description properties are returned.
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

proc call*(call_596864: Call_DenyAssignmentsList_596663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all deny assignments for the subscription.
  ## 
  let valid = call_596864.validator(path, query, header, formData, body)
  let scheme = call_596864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596864.url(scheme.get, call_596864.host, call_596864.base,
                         call_596864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596864, url, valid)

proc call*(call_596935: Call_DenyAssignmentsList_596663; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## denyAssignmentsList
  ## Gets all deny assignments for the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use $filter=atScope() to return all deny assignments at or above the scope. Use $filter=denyAssignmentName eq '{name}' to search deny assignments by name at specified scope. Use $filter=principalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. Use $filter=gdprExportPrincipalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. This filter is different from the principalId filter as it returns not only those deny assignments that contain the specified principal is the Principals list but also those deny assignments that contain the specified principal is the ExcludePrincipals list. Additionally, when gdprExportPrincipalId filter is used, only the deny assignment name and description properties are returned.
  var path_596936 = newJObject()
  var query_596938 = newJObject()
  add(query_596938, "api-version", newJString(apiVersion))
  add(path_596936, "subscriptionId", newJString(subscriptionId))
  add(query_596938, "$filter", newJString(Filter))
  result = call_596935.call(path_596936, query_596938, nil, nil, nil)

var denyAssignmentsList* = Call_DenyAssignmentsList_596663(
    name: "denyAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/denyAssignments",
    validator: validate_DenyAssignmentsList_596664, base: "",
    url: url_DenyAssignmentsList_596665, schemes: {Scheme.Https})
type
  Call_DenyAssignmentsListForResourceGroup_596977 = ref object of OpenApiRestCall_596441
proc url_DenyAssignmentsListForResourceGroup_596979(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Authorization/denyAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DenyAssignmentsListForResourceGroup_596978(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets deny assignments for a resource group.
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
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all deny assignments at or above the scope. Use $filter=denyAssignmentName eq '{name}' to search deny assignments by name at specified scope. Use $filter=principalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. Use $filter=gdprExportPrincipalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. This filter is different from the principalId filter as it returns not only those deny assignments that contain the specified principal is the Principals list but also those deny assignments that contain the specified principal is the ExcludePrincipals list. Additionally, when gdprExportPrincipalId filter is used, only the deny assignment name and description properties are returned.
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

proc call*(call_596984: Call_DenyAssignmentsListForResourceGroup_596977;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets deny assignments for a resource group.
  ## 
  let valid = call_596984.validator(path, query, header, formData, body)
  let scheme = call_596984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596984.url(scheme.get, call_596984.host, call_596984.base,
                         call_596984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596984, url, valid)

proc call*(call_596985: Call_DenyAssignmentsListForResourceGroup_596977;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## denyAssignmentsListForResourceGroup
  ## Gets deny assignments for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use $filter=atScope() to return all deny assignments at or above the scope. Use $filter=denyAssignmentName eq '{name}' to search deny assignments by name at specified scope. Use $filter=principalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. Use $filter=gdprExportPrincipalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. This filter is different from the principalId filter as it returns not only those deny assignments that contain the specified principal is the Principals list but also those deny assignments that contain the specified principal is the ExcludePrincipals list. Additionally, when gdprExportPrincipalId filter is used, only the deny assignment name and description properties are returned.
  var path_596986 = newJObject()
  var query_596987 = newJObject()
  add(path_596986, "resourceGroupName", newJString(resourceGroupName))
  add(query_596987, "api-version", newJString(apiVersion))
  add(path_596986, "subscriptionId", newJString(subscriptionId))
  add(query_596987, "$filter", newJString(Filter))
  result = call_596985.call(path_596986, query_596987, nil, nil, nil)

var denyAssignmentsListForResourceGroup* = Call_DenyAssignmentsListForResourceGroup_596977(
    name: "denyAssignmentsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/denyAssignments",
    validator: validate_DenyAssignmentsListForResourceGroup_596978, base: "",
    url: url_DenyAssignmentsListForResourceGroup_596979, schemes: {Scheme.Https})
type
  Call_DenyAssignmentsListForResource_596988 = ref object of OpenApiRestCall_596441
proc url_DenyAssignmentsListForResource_596990(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Authorization/denyAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DenyAssignmentsListForResource_596989(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets deny assignments for a resource.
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
  ##               : The name of the resource to get deny assignments for.
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
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all deny assignments at or above the scope. Use $filter=denyAssignmentName eq '{name}' to search deny assignments by name at specified scope. Use $filter=principalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. Use $filter=gdprExportPrincipalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. This filter is different from the principalId filter as it returns not only those deny assignments that contain the specified principal is the Principals list but also those deny assignments that contain the specified principal is the ExcludePrincipals list. Additionally, when gdprExportPrincipalId filter is used, only the deny assignment name and description properties are returned.
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

proc call*(call_596999: Call_DenyAssignmentsListForResource_596988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets deny assignments for a resource.
  ## 
  let valid = call_596999.validator(path, query, header, formData, body)
  let scheme = call_596999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596999.url(scheme.get, call_596999.host, call_596999.base,
                         call_596999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596999, url, valid)

proc call*(call_597000: Call_DenyAssignmentsListForResource_596988;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          resourceProviderNamespace: string; parentResourcePath: string;
          Filter: string = ""): Recallable =
  ## denyAssignmentsListForResource
  ## Gets deny assignments for a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to get deny assignments for.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use $filter=atScope() to return all deny assignments at or above the scope. Use $filter=denyAssignmentName eq '{name}' to search deny assignments by name at specified scope. Use $filter=principalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. Use $filter=gdprExportPrincipalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. This filter is different from the principalId filter as it returns not only those deny assignments that contain the specified principal is the Principals list but also those deny assignments that contain the specified principal is the ExcludePrincipals list. Additionally, when gdprExportPrincipalId filter is used, only the deny assignment name and description properties are returned.
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

var denyAssignmentsListForResource* = Call_DenyAssignmentsListForResource_596988(
    name: "denyAssignmentsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/denyAssignments",
    validator: validate_DenyAssignmentsListForResource_596989, base: "",
    url: url_DenyAssignmentsListForResource_596990, schemes: {Scheme.Https})
type
  Call_DenyAssignmentsGetById_597003 = ref object of OpenApiRestCall_596441
proc url_DenyAssignmentsGetById_597005(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "denyAssignmentId" in path,
        "`denyAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "denyAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DenyAssignmentsGetById_597004(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deny assignment by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   denyAssignmentId: JString (required)
  ##                   : The fully qualified deny assignment ID. For example, use the format, 
  ## /subscriptions/{guid}/providers/Microsoft.Authorization/denyAssignments/{denyAssignmentId} for subscription level deny assignments, or /providers/Microsoft.Authorization/denyAssignments/{denyAssignmentId} for tenant level deny assignments.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `denyAssignmentId` field"
  var valid_597006 = path.getOrDefault("denyAssignmentId")
  valid_597006 = validateParameter(valid_597006, JString, required = true,
                                 default = nil)
  if valid_597006 != nil:
    section.add "denyAssignmentId", valid_597006
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

proc call*(call_597008: Call_DenyAssignmentsGetById_597003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deny assignment by ID.
  ## 
  let valid = call_597008.validator(path, query, header, formData, body)
  let scheme = call_597008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597008.url(scheme.get, call_597008.host, call_597008.base,
                         call_597008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597008, url, valid)

proc call*(call_597009: Call_DenyAssignmentsGetById_597003; apiVersion: string;
          denyAssignmentId: string): Recallable =
  ## denyAssignmentsGetById
  ## Gets a deny assignment by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   denyAssignmentId: string (required)
  ##                   : The fully qualified deny assignment ID. For example, use the format, 
  ## /subscriptions/{guid}/providers/Microsoft.Authorization/denyAssignments/{denyAssignmentId} for subscription level deny assignments, or /providers/Microsoft.Authorization/denyAssignments/{denyAssignmentId} for tenant level deny assignments.
  var path_597010 = newJObject()
  var query_597011 = newJObject()
  add(query_597011, "api-version", newJString(apiVersion))
  add(path_597010, "denyAssignmentId", newJString(denyAssignmentId))
  result = call_597009.call(path_597010, query_597011, nil, nil, nil)

var denyAssignmentsGetById* = Call_DenyAssignmentsGetById_597003(
    name: "denyAssignmentsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{denyAssignmentId}",
    validator: validate_DenyAssignmentsGetById_597004, base: "",
    url: url_DenyAssignmentsGetById_597005, schemes: {Scheme.Https})
type
  Call_DenyAssignmentsListForScope_597012 = ref object of OpenApiRestCall_596441
proc url_DenyAssignmentsListForScope_597014(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/denyAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DenyAssignmentsListForScope_597013(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets deny assignments for a scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the deny assignments.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_597015 = path.getOrDefault("scope")
  valid_597015 = validateParameter(valid_597015, JString, required = true,
                                 default = nil)
  if valid_597015 != nil:
    section.add "scope", valid_597015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Use $filter=atScope() to return all deny assignments at or above the scope. Use $filter=denyAssignmentName eq '{name}' to search deny assignments by name at specified scope. Use $filter=principalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. Use $filter=gdprExportPrincipalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. This filter is different from the principalId filter as it returns not only those deny assignments that contain the specified principal is the Principals list but also those deny assignments that contain the specified principal is the ExcludePrincipals list. Additionally, when gdprExportPrincipalId filter is used, only the deny assignment name and description properties are returned.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597016 = query.getOrDefault("api-version")
  valid_597016 = validateParameter(valid_597016, JString, required = true,
                                 default = nil)
  if valid_597016 != nil:
    section.add "api-version", valid_597016
  var valid_597017 = query.getOrDefault("$filter")
  valid_597017 = validateParameter(valid_597017, JString, required = false,
                                 default = nil)
  if valid_597017 != nil:
    section.add "$filter", valid_597017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597018: Call_DenyAssignmentsListForScope_597012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets deny assignments for a scope.
  ## 
  let valid = call_597018.validator(path, query, header, formData, body)
  let scheme = call_597018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597018.url(scheme.get, call_597018.host, call_597018.base,
                         call_597018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597018, url, valid)

proc call*(call_597019: Call_DenyAssignmentsListForScope_597012;
          apiVersion: string; scope: string; Filter: string = ""): Recallable =
  ## denyAssignmentsListForScope
  ## Gets deny assignments for a scope.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string (required)
  ##        : The scope of the deny assignments.
  ##   Filter: string
  ##         : The filter to apply on the operation. Use $filter=atScope() to return all deny assignments at or above the scope. Use $filter=denyAssignmentName eq '{name}' to search deny assignments by name at specified scope. Use $filter=principalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. Use $filter=gdprExportPrincipalId eq '{id}' to return all deny assignments at, above and below the scope for the specified principal. This filter is different from the principalId filter as it returns not only those deny assignments that contain the specified principal is the Principals list but also those deny assignments that contain the specified principal is the ExcludePrincipals list. Additionally, when gdprExportPrincipalId filter is used, only the deny assignment name and description properties are returned.
  var path_597020 = newJObject()
  var query_597021 = newJObject()
  add(query_597021, "api-version", newJString(apiVersion))
  add(path_597020, "scope", newJString(scope))
  add(query_597021, "$filter", newJString(Filter))
  result = call_597019.call(path_597020, query_597021, nil, nil, nil)

var denyAssignmentsListForScope* = Call_DenyAssignmentsListForScope_597012(
    name: "denyAssignmentsListForScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Authorization/denyAssignments",
    validator: validate_DenyAssignmentsListForScope_597013, base: "",
    url: url_DenyAssignmentsListForScope_597014, schemes: {Scheme.Https})
type
  Call_DenyAssignmentsGet_597022 = ref object of OpenApiRestCall_596441
proc url_DenyAssignmentsGet_597024(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "denyAssignmentId" in path,
        "`denyAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/denyAssignments/"),
               (kind: VariableSegment, value: "denyAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DenyAssignmentsGet_597023(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the specified deny assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   denyAssignmentId: JString (required)
  ##                   : The ID of the deny assignment to get.
  ##   scope: JString (required)
  ##        : The scope of the deny assignment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `denyAssignmentId` field"
  var valid_597025 = path.getOrDefault("denyAssignmentId")
  valid_597025 = validateParameter(valid_597025, JString, required = true,
                                 default = nil)
  if valid_597025 != nil:
    section.add "denyAssignmentId", valid_597025
  var valid_597026 = path.getOrDefault("scope")
  valid_597026 = validateParameter(valid_597026, JString, required = true,
                                 default = nil)
  if valid_597026 != nil:
    section.add "scope", valid_597026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597027 = query.getOrDefault("api-version")
  valid_597027 = validateParameter(valid_597027, JString, required = true,
                                 default = nil)
  if valid_597027 != nil:
    section.add "api-version", valid_597027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597028: Call_DenyAssignmentsGet_597022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified deny assignment.
  ## 
  let valid = call_597028.validator(path, query, header, formData, body)
  let scheme = call_597028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597028.url(scheme.get, call_597028.host, call_597028.base,
                         call_597028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597028, url, valid)

proc call*(call_597029: Call_DenyAssignmentsGet_597022; apiVersion: string;
          denyAssignmentId: string; scope: string): Recallable =
  ## denyAssignmentsGet
  ## Get the specified deny assignment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   denyAssignmentId: string (required)
  ##                   : The ID of the deny assignment to get.
  ##   scope: string (required)
  ##        : The scope of the deny assignment.
  var path_597030 = newJObject()
  var query_597031 = newJObject()
  add(query_597031, "api-version", newJString(apiVersion))
  add(path_597030, "denyAssignmentId", newJString(denyAssignmentId))
  add(path_597030, "scope", newJString(scope))
  result = call_597029.call(path_597030, query_597031, nil, nil, nil)

var denyAssignmentsGet* = Call_DenyAssignmentsGet_597022(
    name: "denyAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/denyAssignments/{denyAssignmentId}",
    validator: validate_DenyAssignmentsGet_597023, base: "",
    url: url_DenyAssignmentsGet_597024, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
