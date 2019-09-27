
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PolicyClient
## version: 2018-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## To manage and control access to your resources, you can define customized policies and assign them at a scope.
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "resources-policyAssignments"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyAssignmentsList_593646 = ref object of OpenApiRestCall_593424
proc url_PolicyAssignmentsList_593648(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Authorization/policyAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsList_593647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the list of all policy assignments associated with the given subscription that match the optional given $filter. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, the unfiltered list includes all policy assignments associated with the subscription, including those that apply directly or from management groups that contain the given subscription, as well as any applied to objects contained within the subscription. If $filter=atScope() is provided, the returned list includes all policy assignments that apply to the subscription, which is everything in the unfiltered list except those applied to objects contained within the subscription. If $filter=policyDefinitionId eq '{value}' is provided, the returned list includes all policy assignments of the policy definition whose id is {value}.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593822 = path.getOrDefault("subscriptionId")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "subscriptionId", valid_593822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, no filtering is performed.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593823 = query.getOrDefault("api-version")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "api-version", valid_593823
  var valid_593824 = query.getOrDefault("$filter")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "$filter", valid_593824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593847: Call_PolicyAssignmentsList_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves the list of all policy assignments associated with the given subscription that match the optional given $filter. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, the unfiltered list includes all policy assignments associated with the subscription, including those that apply directly or from management groups that contain the given subscription, as well as any applied to objects contained within the subscription. If $filter=atScope() is provided, the returned list includes all policy assignments that apply to the subscription, which is everything in the unfiltered list except those applied to objects contained within the subscription. If $filter=policyDefinitionId eq '{value}' is provided, the returned list includes all policy assignments of the policy definition whose id is {value}.
  ## 
  let valid = call_593847.validator(path, query, header, formData, body)
  let scheme = call_593847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593847.url(scheme.get, call_593847.host, call_593847.base,
                         call_593847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593847, url, valid)

proc call*(call_593918: Call_PolicyAssignmentsList_593646; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## policyAssignmentsList
  ## This operation retrieves the list of all policy assignments associated with the given subscription that match the optional given $filter. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, the unfiltered list includes all policy assignments associated with the subscription, including those that apply directly or from management groups that contain the given subscription, as well as any applied to objects contained within the subscription. If $filter=atScope() is provided, the returned list includes all policy assignments that apply to the subscription, which is everything in the unfiltered list except those applied to objects contained within the subscription. If $filter=policyDefinitionId eq '{value}' is provided, the returned list includes all policy assignments of the policy definition whose id is {value}.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, no filtering is performed.
  var path_593919 = newJObject()
  var query_593921 = newJObject()
  add(query_593921, "api-version", newJString(apiVersion))
  add(path_593919, "subscriptionId", newJString(subscriptionId))
  add(query_593921, "$filter", newJString(Filter))
  result = call_593918.call(path_593919, query_593921, nil, nil, nil)

var policyAssignmentsList* = Call_PolicyAssignmentsList_593646(
    name: "policyAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsList_593647, base: "",
    url: url_PolicyAssignmentsList_593648, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForResourceGroup_593960 = ref object of OpenApiRestCall_593424
proc url_PolicyAssignmentsListForResourceGroup_593962(protocol: Scheme;
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
        value: "/providers/Microsoft.Authorization/policyAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsListForResourceGroup_593961(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the list of all policy assignments associated with the given resource group in the given subscription that match the optional given $filter. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, the unfiltered list includes all policy assignments associated with the resource group, including those that apply directly or apply from containing scopes, as well as any applied to resources contained within the resource group. If $filter=atScope() is provided, the returned list includes all policy assignments that apply to the resource group, which is everything in the unfiltered list except those applied to resources contained within the resource group. If $filter=policyDefinitionId eq '{value}' is provided, the returned list includes all policy assignments of the policy definition whose id is {value} that apply to the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains policy assignments.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593963 = path.getOrDefault("resourceGroupName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "resourceGroupName", valid_593963
  var valid_593964 = path.getOrDefault("subscriptionId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "subscriptionId", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, no filtering is performed.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  var valid_593966 = query.getOrDefault("$filter")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "$filter", valid_593966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593967: Call_PolicyAssignmentsListForResourceGroup_593960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves the list of all policy assignments associated with the given resource group in the given subscription that match the optional given $filter. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, the unfiltered list includes all policy assignments associated with the resource group, including those that apply directly or apply from containing scopes, as well as any applied to resources contained within the resource group. If $filter=atScope() is provided, the returned list includes all policy assignments that apply to the resource group, which is everything in the unfiltered list except those applied to resources contained within the resource group. If $filter=policyDefinitionId eq '{value}' is provided, the returned list includes all policy assignments of the policy definition whose id is {value} that apply to the resource group.
  ## 
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_PolicyAssignmentsListForResourceGroup_593960;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## policyAssignmentsListForResourceGroup
  ## This operation retrieves the list of all policy assignments associated with the given resource group in the given subscription that match the optional given $filter. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, the unfiltered list includes all policy assignments associated with the resource group, including those that apply directly or apply from containing scopes, as well as any applied to resources contained within the resource group. If $filter=atScope() is provided, the returned list includes all policy assignments that apply to the resource group, which is everything in the unfiltered list except those applied to resources contained within the resource group. If $filter=policyDefinitionId eq '{value}' is provided, the returned list includes all policy assignments of the policy definition whose id is {value} that apply to the resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains policy assignments.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, no filtering is performed.
  var path_593969 = newJObject()
  var query_593970 = newJObject()
  add(path_593969, "resourceGroupName", newJString(resourceGroupName))
  add(query_593970, "api-version", newJString(apiVersion))
  add(path_593969, "subscriptionId", newJString(subscriptionId))
  add(query_593970, "$filter", newJString(Filter))
  result = call_593968.call(path_593969, query_593970, nil, nil, nil)

var policyAssignmentsListForResourceGroup* = Call_PolicyAssignmentsListForResourceGroup_593960(
    name: "policyAssignmentsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForResourceGroup_593961, base: "",
    url: url_PolicyAssignmentsListForResourceGroup_593962, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForResource_593971 = ref object of OpenApiRestCall_593424
proc url_PolicyAssignmentsListForResource_593973(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Authorization/policyAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsListForResource_593972(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves the list of all policy assignments associated with the specified resource in the given resource group and subscription that match the optional given $filter. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, the unfiltered list includes all policy assignments associated with the resource, including those that apply directly or from all containing scopes, as well as any applied to resources contained within the resource. If $filter=atScope() is provided, the returned list includes all policy assignments that apply to the resource, which is everything in the unfiltered list except those applied to resources contained within the resource. If $filter=policyDefinitionId eq '{value}' is provided, the returned list includes all policy assignments of the policy definition whose id is {value} that apply to the resource. Three parameters plus the resource name are used to identify a specific resource. If the resource is not part of a parent resource (the more common case), the parent resource path should not be provided (or provided as ''). For example a web app could be specified as ({resourceProviderNamespace} == 'Microsoft.Web', {parentResourcePath} == '', {resourceType} == 'sites', {resourceName} == 'MyWebApp'). If the resource is part of a parent resource, then all parameters should be provided. For example a virtual machine DNS name could be specified as ({resourceProviderNamespace} == 'Microsoft.Compute', {parentResourcePath} == 'virtualMachines/MyVirtualMachine', {resourceType} == 'domainNames', {resourceName} == 'MyComputerName'). A convenient alternative to providing the namespace and type name separately is to provide both in the {resourceType} parameter, format: ({resourceProviderNamespace} == '', {parentResourcePath} == '', {resourceType} == 'Microsoft.Web/sites', {resourceName} == 'MyWebApp').
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type name. For example the type name of a web app is 'sites' (from Microsoft.Web/sites).
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider. For example, the namespace of a virtual machine is Microsoft.Compute (from Microsoft.Compute/virtualMachines)
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource path. Use empty string if there is none.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_593974 = path.getOrDefault("resourceType")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "resourceType", valid_593974
  var valid_593975 = path.getOrDefault("resourceGroupName")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "resourceGroupName", valid_593975
  var valid_593976 = path.getOrDefault("subscriptionId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "subscriptionId", valid_593976
  var valid_593977 = path.getOrDefault("resourceName")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "resourceName", valid_593977
  var valid_593978 = path.getOrDefault("resourceProviderNamespace")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "resourceProviderNamespace", valid_593978
  var valid_593979 = path.getOrDefault("parentResourcePath")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "parentResourcePath", valid_593979
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, no filtering is performed.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593980 = query.getOrDefault("api-version")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "api-version", valid_593980
  var valid_593981 = query.getOrDefault("$filter")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "$filter", valid_593981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593982: Call_PolicyAssignmentsListForResource_593971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves the list of all policy assignments associated with the specified resource in the given resource group and subscription that match the optional given $filter. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, the unfiltered list includes all policy assignments associated with the resource, including those that apply directly or from all containing scopes, as well as any applied to resources contained within the resource. If $filter=atScope() is provided, the returned list includes all policy assignments that apply to the resource, which is everything in the unfiltered list except those applied to resources contained within the resource. If $filter=policyDefinitionId eq '{value}' is provided, the returned list includes all policy assignments of the policy definition whose id is {value} that apply to the resource. Three parameters plus the resource name are used to identify a specific resource. If the resource is not part of a parent resource (the more common case), the parent resource path should not be provided (or provided as ''). For example a web app could be specified as ({resourceProviderNamespace} == 'Microsoft.Web', {parentResourcePath} == '', {resourceType} == 'sites', {resourceName} == 'MyWebApp'). If the resource is part of a parent resource, then all parameters should be provided. For example a virtual machine DNS name could be specified as ({resourceProviderNamespace} == 'Microsoft.Compute', {parentResourcePath} == 'virtualMachines/MyVirtualMachine', {resourceType} == 'domainNames', {resourceName} == 'MyComputerName'). A convenient alternative to providing the namespace and type name separately is to provide both in the {resourceType} parameter, format: ({resourceProviderNamespace} == '', {parentResourcePath} == '', {resourceType} == 'Microsoft.Web/sites', {resourceName} == 'MyWebApp').
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_PolicyAssignmentsListForResource_593971;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          resourceProviderNamespace: string; parentResourcePath: string;
          Filter: string = ""): Recallable =
  ## policyAssignmentsListForResource
  ## This operation retrieves the list of all policy assignments associated with the specified resource in the given resource group and subscription that match the optional given $filter. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, the unfiltered list includes all policy assignments associated with the resource, including those that apply directly or from all containing scopes, as well as any applied to resources contained within the resource. If $filter=atScope() is provided, the returned list includes all policy assignments that apply to the resource, which is everything in the unfiltered list except those applied to resources contained within the resource. If $filter=policyDefinitionId eq '{value}' is provided, the returned list includes all policy assignments of the policy definition whose id is {value} that apply to the resource. Three parameters plus the resource name are used to identify a specific resource. If the resource is not part of a parent resource (the more common case), the parent resource path should not be provided (or provided as ''). For example a web app could be specified as ({resourceProviderNamespace} == 'Microsoft.Web', {parentResourcePath} == '', {resourceType} == 'sites', {resourceName} == 'MyWebApp'). If the resource is part of a parent resource, then all parameters should be provided. For example a virtual machine DNS name could be specified as ({resourceProviderNamespace} == 'Microsoft.Compute', {parentResourcePath} == 'virtualMachines/MyVirtualMachine', {resourceType} == 'domainNames', {resourceName} == 'MyComputerName'). A convenient alternative to providing the namespace and type name separately is to provide both in the {resourceType} parameter, format: ({resourceProviderNamespace} == '', {parentResourcePath} == '', {resourceType} == 'Microsoft.Web/sites', {resourceName} == 'MyWebApp').
  ##   resourceType: string (required)
  ##               : The resource type name. For example the type name of a web app is 'sites' (from Microsoft.Web/sites).
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider. For example, the namespace of a virtual machine is Microsoft.Compute (from Microsoft.Compute/virtualMachines)
  ##   parentResourcePath: string (required)
  ##                     : The parent resource path. Use empty string if there is none.
  ##   Filter: string
  ##         : The filter to apply on the operation. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, no filtering is performed.
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  add(path_593984, "resourceType", newJString(resourceType))
  add(path_593984, "resourceGroupName", newJString(resourceGroupName))
  add(query_593985, "api-version", newJString(apiVersion))
  add(path_593984, "subscriptionId", newJString(subscriptionId))
  add(path_593984, "resourceName", newJString(resourceName))
  add(path_593984, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_593984, "parentResourcePath", newJString(parentResourcePath))
  add(query_593985, "$filter", newJString(Filter))
  result = call_593983.call(path_593984, query_593985, nil, nil, nil)

var policyAssignmentsListForResource* = Call_PolicyAssignmentsListForResource_593971(
    name: "policyAssignmentsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForResource_593972, base: "",
    url: url_PolicyAssignmentsListForResource_593973, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsCreateById_593995 = ref object of OpenApiRestCall_593424
proc url_PolicyAssignmentsCreateById_593997(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "policyAssignmentId" in path,
        "`policyAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "policyAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsCreateById_593996(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation creates or updates the policy assignment with the given ID. Policy assignments made on a scope apply to all resources contained in that scope. For example, when you assign a policy to a resource group that policy applies to all resources in the group. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentId: JString (required)
  ##                     : The ID of the policy assignment to create. Use the format 
  ## '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyAssignmentId` field"
  var valid_594015 = path.getOrDefault("policyAssignmentId")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "policyAssignmentId", valid_594015
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594016 = query.getOrDefault("api-version")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "api-version", valid_594016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for policy assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_PolicyAssignmentsCreateById_593995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation creates or updates the policy assignment with the given ID. Policy assignments made on a scope apply to all resources contained in that scope. For example, when you assign a policy to a resource group that policy applies to all resources in the group. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_PolicyAssignmentsCreateById_593995;
          apiVersion: string; parameters: JsonNode; policyAssignmentId: string): Recallable =
  ## policyAssignmentsCreateById
  ## This operation creates or updates the policy assignment with the given ID. Policy assignments made on a scope apply to all resources contained in that scope. For example, when you assign a policy to a resource group that policy applies to all resources in the group. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   parameters: JObject (required)
  ##             : Parameters for policy assignment.
  ##   policyAssignmentId: string (required)
  ##                     : The ID of the policy assignment to create. Use the format 
  ## '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'.
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  var body_594022 = newJObject()
  add(query_594021, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594022 = parameters
  add(path_594020, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_594019.call(path_594020, query_594021, nil, nil, body_594022)

var policyAssignmentsCreateById* = Call_PolicyAssignmentsCreateById_593995(
    name: "policyAssignmentsCreateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsCreateById_593996, base: "",
    url: url_PolicyAssignmentsCreateById_593997, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsGetById_593986 = ref object of OpenApiRestCall_593424
proc url_PolicyAssignmentsGetById_593988(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "policyAssignmentId" in path,
        "`policyAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "policyAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsGetById_593987(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation retrieves the policy assignment with the given ID. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentId: JString (required)
  ##                     : The ID of the policy assignment to get. Use the format 
  ## '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyAssignmentId` field"
  var valid_593989 = path.getOrDefault("policyAssignmentId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "policyAssignmentId", valid_593989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_PolicyAssignmentsGetById_593986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation retrieves the policy assignment with the given ID. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_PolicyAssignmentsGetById_593986; apiVersion: string;
          policyAssignmentId: string): Recallable =
  ## policyAssignmentsGetById
  ## The operation retrieves the policy assignment with the given ID. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyAssignmentId: string (required)
  ##                     : The ID of the policy assignment to get. Use the format 
  ## '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'.
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  add(query_593994, "api-version", newJString(apiVersion))
  add(path_593993, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_593992.call(path_593993, query_593994, nil, nil, nil)

var policyAssignmentsGetById* = Call_PolicyAssignmentsGetById_593986(
    name: "policyAssignmentsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsGetById_593987, base: "",
    url: url_PolicyAssignmentsGetById_593988, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsDeleteById_594023 = ref object of OpenApiRestCall_593424
proc url_PolicyAssignmentsDeleteById_594025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "policyAssignmentId" in path,
        "`policyAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "policyAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsDeleteById_594024(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation deletes the policy with the given ID. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid formats for {scope} are: '/providers/Microsoft.Management/managementGroups/{managementGroup}' (management group), '/subscriptions/{subscriptionId}' (subscription), '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' (resource group), or '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}' (resource).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentId: JString (required)
  ##                     : The ID of the policy assignment to delete. Use the format 
  ## '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyAssignmentId` field"
  var valid_594026 = path.getOrDefault("policyAssignmentId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "policyAssignmentId", valid_594026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594027 = query.getOrDefault("api-version")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "api-version", valid_594027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594028: Call_PolicyAssignmentsDeleteById_594023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation deletes the policy with the given ID. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid formats for {scope} are: '/providers/Microsoft.Management/managementGroups/{managementGroup}' (management group), '/subscriptions/{subscriptionId}' (subscription), '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' (resource group), or '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}' (resource).
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_PolicyAssignmentsDeleteById_594023;
          apiVersion: string; policyAssignmentId: string): Recallable =
  ## policyAssignmentsDeleteById
  ## This operation deletes the policy with the given ID. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid formats for {scope} are: '/providers/Microsoft.Management/managementGroups/{managementGroup}' (management group), '/subscriptions/{subscriptionId}' (subscription), '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' (resource group), or '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}' (resource).
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyAssignmentId: string (required)
  ##                     : The ID of the policy assignment to delete. Use the format 
  ## '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'.
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  add(query_594031, "api-version", newJString(apiVersion))
  add(path_594030, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_594029.call(path_594030, query_594031, nil, nil, nil)

var policyAssignmentsDeleteById* = Call_PolicyAssignmentsDeleteById_594023(
    name: "policyAssignmentsDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsDeleteById_594024, base: "",
    url: url_PolicyAssignmentsDeleteById_594025, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsCreate_594042 = ref object of OpenApiRestCall_593424
proc url_PolicyAssignmentsCreate_594044(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "policyAssignmentName" in path,
        "`policyAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsCreate_594043(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ##  This operation creates or updates a policy assignment with the given scope and name. Policy assignments apply to all resources contained within their scope. For example, when you assign a policy at resource group scope, that policy applies to all resources in the group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentName: JString (required)
  ##                       : The name of the policy assignment.
  ##   scope: JString (required)
  ##        : The scope of the policy assignment. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyAssignmentName` field"
  var valid_594045 = path.getOrDefault("policyAssignmentName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "policyAssignmentName", valid_594045
  var valid_594046 = path.getOrDefault("scope")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "scope", valid_594046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for the policy assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_PolicyAssignmentsCreate_594042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ##  This operation creates or updates a policy assignment with the given scope and name. Policy assignments apply to all resources contained within their scope. For example, when you assign a policy at resource group scope, that policy applies to all resources in the group.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_PolicyAssignmentsCreate_594042; apiVersion: string;
          policyAssignmentName: string; parameters: JsonNode; scope: string): Recallable =
  ## policyAssignmentsCreate
  ##  This operation creates or updates a policy assignment with the given scope and name. Policy assignments apply to all resources contained within their scope. For example, when you assign a policy at resource group scope, that policy applies to all resources in the group.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyAssignmentName: string (required)
  ##                       : The name of the policy assignment.
  ##   parameters: JObject (required)
  ##             : Parameters for the policy assignment.
  ##   scope: string (required)
  ##        : The scope of the policy assignment. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  var body_594053 = newJObject()
  add(query_594052, "api-version", newJString(apiVersion))
  add(path_594051, "policyAssignmentName", newJString(policyAssignmentName))
  if parameters != nil:
    body_594053 = parameters
  add(path_594051, "scope", newJString(scope))
  result = call_594050.call(path_594051, query_594052, nil, nil, body_594053)

var policyAssignmentsCreate* = Call_PolicyAssignmentsCreate_594042(
    name: "policyAssignmentsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsCreate_594043, base: "",
    url: url_PolicyAssignmentsCreate_594044, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsGet_594032 = ref object of OpenApiRestCall_593424
proc url_PolicyAssignmentsGet_594034(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "policyAssignmentName" in path,
        "`policyAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsGet_594033(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation retrieves a single policy assignment, given its name and the scope it was created at.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentName: JString (required)
  ##                       : The name of the policy assignment to get.
  ##   scope: JString (required)
  ##        : The scope of the policy assignment. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyAssignmentName` field"
  var valid_594035 = path.getOrDefault("policyAssignmentName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "policyAssignmentName", valid_594035
  var valid_594036 = path.getOrDefault("scope")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "scope", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "api-version", valid_594037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594038: Call_PolicyAssignmentsGet_594032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves a single policy assignment, given its name and the scope it was created at.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_PolicyAssignmentsGet_594032; apiVersion: string;
          policyAssignmentName: string; scope: string): Recallable =
  ## policyAssignmentsGet
  ## This operation retrieves a single policy assignment, given its name and the scope it was created at.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyAssignmentName: string (required)
  ##                       : The name of the policy assignment to get.
  ##   scope: string (required)
  ##        : The scope of the policy assignment. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  add(query_594041, "api-version", newJString(apiVersion))
  add(path_594040, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_594040, "scope", newJString(scope))
  result = call_594039.call(path_594040, query_594041, nil, nil, nil)

var policyAssignmentsGet* = Call_PolicyAssignmentsGet_594032(
    name: "policyAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsGet_594033, base: "",
    url: url_PolicyAssignmentsGet_594034, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsDelete_594054 = ref object of OpenApiRestCall_593424
proc url_PolicyAssignmentsDelete_594056(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "policyAssignmentName" in path,
        "`policyAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Authorization/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyAssignmentsDelete_594055(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation deletes a policy assignment, given its name and the scope it was created in. The scope of a policy assignment is the part of its ID preceding '/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyAssignmentName: JString (required)
  ##                       : The name of the policy assignment to delete.
  ##   scope: JString (required)
  ##        : The scope of the policy assignment. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyAssignmentName` field"
  var valid_594057 = path.getOrDefault("policyAssignmentName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "policyAssignmentName", valid_594057
  var valid_594058 = path.getOrDefault("scope")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "scope", valid_594058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594059 = query.getOrDefault("api-version")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "api-version", valid_594059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_PolicyAssignmentsDelete_594054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation deletes a policy assignment, given its name and the scope it was created in. The scope of a policy assignment is the part of its ID preceding '/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_PolicyAssignmentsDelete_594054; apiVersion: string;
          policyAssignmentName: string; scope: string): Recallable =
  ## policyAssignmentsDelete
  ## This operation deletes a policy assignment, given its name and the scope it was created in. The scope of a policy assignment is the part of its ID preceding '/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyAssignmentName: string (required)
  ##                       : The name of the policy assignment to delete.
  ##   scope: string (required)
  ##        : The scope of the policy assignment. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: 
  ## '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  add(query_594063, "api-version", newJString(apiVersion))
  add(path_594062, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_594062, "scope", newJString(scope))
  result = call_594061.call(path_594062, query_594063, nil, nil, nil)

var policyAssignmentsDelete* = Call_PolicyAssignmentsDelete_594054(
    name: "policyAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsDelete_594055, base: "",
    url: url_PolicyAssignmentsDelete_594056, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
