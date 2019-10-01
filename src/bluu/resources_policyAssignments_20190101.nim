
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PolicyClient
## version: 2019-01-01
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "resources-policyAssignments"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyAssignmentsList_567879 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsList_567881(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyAssignmentsList_567880(path: JsonNode; query: JsonNode;
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
  var valid_568055 = path.getOrDefault("subscriptionId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "subscriptionId", valid_568055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, no filtering is performed.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568056 = query.getOrDefault("api-version")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "api-version", valid_568056
  var valid_568057 = query.getOrDefault("$filter")
  valid_568057 = validateParameter(valid_568057, JString, required = false,
                                 default = nil)
  if valid_568057 != nil:
    section.add "$filter", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_PolicyAssignmentsList_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves the list of all policy assignments associated with the given subscription that match the optional given $filter. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, the unfiltered list includes all policy assignments associated with the subscription, including those that apply directly or from management groups that contain the given subscription, as well as any applied to objects contained within the subscription. If $filter=atScope() is provided, the returned list includes all policy assignments that apply to the subscription, which is everything in the unfiltered list except those applied to objects contained within the subscription. If $filter=policyDefinitionId eq '{value}' is provided, the returned list includes all policy assignments of the policy definition whose id is {value}.
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_PolicyAssignmentsList_567879; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## policyAssignmentsList
  ## This operation retrieves the list of all policy assignments associated with the given subscription that match the optional given $filter. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, the unfiltered list includes all policy assignments associated with the subscription, including those that apply directly or from management groups that contain the given subscription, as well as any applied to objects contained within the subscription. If $filter=atScope() is provided, the returned list includes all policy assignments that apply to the subscription, which is everything in the unfiltered list except those applied to objects contained within the subscription. If $filter=policyDefinitionId eq '{value}' is provided, the returned list includes all policy assignments of the policy definition whose id is {value}.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the operation. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, no filtering is performed.
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  add(query_568154, "$filter", newJString(Filter))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var policyAssignmentsList* = Call_PolicyAssignmentsList_567879(
    name: "policyAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsList_567880, base: "",
    url: url_PolicyAssignmentsList_567881, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForResourceGroup_568193 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsListForResourceGroup_568195(protocol: Scheme;
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

proc validate_PolicyAssignmentsListForResourceGroup_568194(path: JsonNode;
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
  var valid_568196 = path.getOrDefault("resourceGroupName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "resourceGroupName", valid_568196
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, no filtering is performed.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  var valid_568199 = query.getOrDefault("$filter")
  valid_568199 = validateParameter(valid_568199, JString, required = false,
                                 default = nil)
  if valid_568199 != nil:
    section.add "$filter", valid_568199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568200: Call_PolicyAssignmentsListForResourceGroup_568193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves the list of all policy assignments associated with the given resource group in the given subscription that match the optional given $filter. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, the unfiltered list includes all policy assignments associated with the resource group, including those that apply directly or apply from containing scopes, as well as any applied to resources contained within the resource group. If $filter=atScope() is provided, the returned list includes all policy assignments that apply to the resource group, which is everything in the unfiltered list except those applied to resources contained within the resource group. If $filter=policyDefinitionId eq '{value}' is provided, the returned list includes all policy assignments of the policy definition whose id is {value} that apply to the resource group.
  ## 
  let valid = call_568200.validator(path, query, header, formData, body)
  let scheme = call_568200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568200.url(scheme.get, call_568200.host, call_568200.base,
                         call_568200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568200, url, valid)

proc call*(call_568201: Call_PolicyAssignmentsListForResourceGroup_568193;
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
  var path_568202 = newJObject()
  var query_568203 = newJObject()
  add(path_568202, "resourceGroupName", newJString(resourceGroupName))
  add(query_568203, "api-version", newJString(apiVersion))
  add(path_568202, "subscriptionId", newJString(subscriptionId))
  add(query_568203, "$filter", newJString(Filter))
  result = call_568201.call(path_568202, query_568203, nil, nil, nil)

var policyAssignmentsListForResourceGroup* = Call_PolicyAssignmentsListForResourceGroup_568193(
    name: "policyAssignmentsListForResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForResourceGroup_568194, base: "",
    url: url_PolicyAssignmentsListForResourceGroup_568195, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsListForResource_568204 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsListForResource_568206(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsListForResource_568205(path: JsonNode;
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
  var valid_568207 = path.getOrDefault("resourceType")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "resourceType", valid_568207
  var valid_568208 = path.getOrDefault("resourceGroupName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "resourceGroupName", valid_568208
  var valid_568209 = path.getOrDefault("subscriptionId")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "subscriptionId", valid_568209
  var valid_568210 = path.getOrDefault("resourceName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "resourceName", valid_568210
  var valid_568211 = path.getOrDefault("resourceProviderNamespace")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "resourceProviderNamespace", valid_568211
  var valid_568212 = path.getOrDefault("parentResourcePath")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "parentResourcePath", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the operation. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, no filtering is performed.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  var valid_568214 = query.getOrDefault("$filter")
  valid_568214 = validateParameter(valid_568214, JString, required = false,
                                 default = nil)
  if valid_568214 != nil:
    section.add "$filter", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_PolicyAssignmentsListForResource_568204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation retrieves the list of all policy assignments associated with the specified resource in the given resource group and subscription that match the optional given $filter. Valid values for $filter are: 'atScope()' or 'policyDefinitionId eq '{value}''. If $filter is not provided, the unfiltered list includes all policy assignments associated with the resource, including those that apply directly or from all containing scopes, as well as any applied to resources contained within the resource. If $filter=atScope() is provided, the returned list includes all policy assignments that apply to the resource, which is everything in the unfiltered list except those applied to resources contained within the resource. If $filter=policyDefinitionId eq '{value}' is provided, the returned list includes all policy assignments of the policy definition whose id is {value} that apply to the resource. Three parameters plus the resource name are used to identify a specific resource. If the resource is not part of a parent resource (the more common case), the parent resource path should not be provided (or provided as ''). For example a web app could be specified as ({resourceProviderNamespace} == 'Microsoft.Web', {parentResourcePath} == '', {resourceType} == 'sites', {resourceName} == 'MyWebApp'). If the resource is part of a parent resource, then all parameters should be provided. For example a virtual machine DNS name could be specified as ({resourceProviderNamespace} == 'Microsoft.Compute', {parentResourcePath} == 'virtualMachines/MyVirtualMachine', {resourceType} == 'domainNames', {resourceName} == 'MyComputerName'). A convenient alternative to providing the namespace and type name separately is to provide both in the {resourceType} parameter, format: ({resourceProviderNamespace} == '', {parentResourcePath} == '', {resourceType} == 'Microsoft.Web/sites', {resourceName} == 'MyWebApp').
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_PolicyAssignmentsListForResource_568204;
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
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(path_568217, "resourceType", newJString(resourceType))
  add(path_568217, "resourceGroupName", newJString(resourceGroupName))
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  add(path_568217, "resourceName", newJString(resourceName))
  add(path_568217, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568217, "parentResourcePath", newJString(parentResourcePath))
  add(query_568218, "$filter", newJString(Filter))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var policyAssignmentsListForResource* = Call_PolicyAssignmentsListForResource_568204(
    name: "policyAssignmentsListForResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}/providers/Microsoft.Authorization/policyAssignments",
    validator: validate_PolicyAssignmentsListForResource_568205, base: "",
    url: url_PolicyAssignmentsListForResource_568206, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsCreateById_568228 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsCreateById_568230(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsCreateById_568229(path: JsonNode; query: JsonNode;
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
  var valid_568248 = path.getOrDefault("policyAssignmentId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "policyAssignmentId", valid_568248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for policy assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568251: Call_PolicyAssignmentsCreateById_568228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation creates or updates the policy assignment with the given ID. Policy assignments made on a scope apply to all resources contained in that scope. For example, when you assign a policy to a resource group that policy applies to all resources in the group. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'.
  ## 
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_PolicyAssignmentsCreateById_568228;
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
  var path_568253 = newJObject()
  var query_568254 = newJObject()
  var body_568255 = newJObject()
  add(query_568254, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568255 = parameters
  add(path_568253, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_568252.call(path_568253, query_568254, nil, nil, body_568255)

var policyAssignmentsCreateById* = Call_PolicyAssignmentsCreateById_568228(
    name: "policyAssignmentsCreateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsCreateById_568229, base: "",
    url: url_PolicyAssignmentsCreateById_568230, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsGetById_568219 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsGetById_568221(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsGetById_568220(path: JsonNode; query: JsonNode;
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
  var valid_568222 = path.getOrDefault("policyAssignmentId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "policyAssignmentId", valid_568222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_PolicyAssignmentsGetById_568219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation retrieves the policy assignment with the given ID. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_PolicyAssignmentsGetById_568219; apiVersion: string;
          policyAssignmentId: string): Recallable =
  ## policyAssignmentsGetById
  ## The operation retrieves the policy assignment with the given ID. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'), resource group (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}', or resource (format: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}'.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyAssignmentId: string (required)
  ##                     : The ID of the policy assignment to get. Use the format 
  ## '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'.
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_568225.call(path_568226, query_568227, nil, nil, nil)

var policyAssignmentsGetById* = Call_PolicyAssignmentsGetById_568219(
    name: "policyAssignmentsGetById", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsGetById_568220, base: "",
    url: url_PolicyAssignmentsGetById_568221, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsDeleteById_568256 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsDeleteById_568258(protocol: Scheme; host: string;
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

proc validate_PolicyAssignmentsDeleteById_568257(path: JsonNode; query: JsonNode;
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
  var valid_568259 = path.getOrDefault("policyAssignmentId")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "policyAssignmentId", valid_568259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568260 = query.getOrDefault("api-version")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "api-version", valid_568260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568261: Call_PolicyAssignmentsDeleteById_568256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation deletes the policy with the given ID. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid formats for {scope} are: '/providers/Microsoft.Management/managementGroups/{managementGroup}' (management group), '/subscriptions/{subscriptionId}' (subscription), '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' (resource group), or '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}' (resource).
  ## 
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_PolicyAssignmentsDeleteById_568256;
          apiVersion: string; policyAssignmentId: string): Recallable =
  ## policyAssignmentsDeleteById
  ## This operation deletes the policy with the given ID. Policy assignment IDs have this format: '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'. Valid formats for {scope} are: '/providers/Microsoft.Management/managementGroups/{managementGroup}' (management group), '/subscriptions/{subscriptionId}' (subscription), '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}' (resource group), or '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]{resourceType}/{resourceName}' (resource).
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   policyAssignmentId: string (required)
  ##                     : The ID of the policy assignment to delete. Use the format 
  ## '{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'.
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "policyAssignmentId", newJString(policyAssignmentId))
  result = call_568262.call(path_568263, query_568264, nil, nil, nil)

var policyAssignmentsDeleteById* = Call_PolicyAssignmentsDeleteById_568256(
    name: "policyAssignmentsDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{policyAssignmentId}",
    validator: validate_PolicyAssignmentsDeleteById_568257, base: "",
    url: url_PolicyAssignmentsDeleteById_568258, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsCreate_568275 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsCreate_568277(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyAssignmentsCreate_568276(path: JsonNode; query: JsonNode;
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
  var valid_568278 = path.getOrDefault("policyAssignmentName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "policyAssignmentName", valid_568278
  var valid_568279 = path.getOrDefault("scope")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "scope", valid_568279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "api-version", valid_568280
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

proc call*(call_568282: Call_PolicyAssignmentsCreate_568275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ##  This operation creates or updates a policy assignment with the given scope and name. Policy assignments apply to all resources contained within their scope. For example, when you assign a policy at resource group scope, that policy applies to all resources in the group.
  ## 
  let valid = call_568282.validator(path, query, header, formData, body)
  let scheme = call_568282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568282.url(scheme.get, call_568282.host, call_568282.base,
                         call_568282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568282, url, valid)

proc call*(call_568283: Call_PolicyAssignmentsCreate_568275; apiVersion: string;
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
  var path_568284 = newJObject()
  var query_568285 = newJObject()
  var body_568286 = newJObject()
  add(query_568285, "api-version", newJString(apiVersion))
  add(path_568284, "policyAssignmentName", newJString(policyAssignmentName))
  if parameters != nil:
    body_568286 = parameters
  add(path_568284, "scope", newJString(scope))
  result = call_568283.call(path_568284, query_568285, nil, nil, body_568286)

var policyAssignmentsCreate* = Call_PolicyAssignmentsCreate_568275(
    name: "policyAssignmentsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsCreate_568276, base: "",
    url: url_PolicyAssignmentsCreate_568277, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsGet_568265 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsGet_568267(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyAssignmentsGet_568266(path: JsonNode; query: JsonNode;
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
  var valid_568268 = path.getOrDefault("policyAssignmentName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "policyAssignmentName", valid_568268
  var valid_568269 = path.getOrDefault("scope")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "scope", valid_568269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
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

proc call*(call_568271: Call_PolicyAssignmentsGet_568265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation retrieves a single policy assignment, given its name and the scope it was created at.
  ## 
  let valid = call_568271.validator(path, query, header, formData, body)
  let scheme = call_568271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568271.url(scheme.get, call_568271.host, call_568271.base,
                         call_568271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568271, url, valid)

proc call*(call_568272: Call_PolicyAssignmentsGet_568265; apiVersion: string;
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
  var path_568273 = newJObject()
  var query_568274 = newJObject()
  add(query_568274, "api-version", newJString(apiVersion))
  add(path_568273, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_568273, "scope", newJString(scope))
  result = call_568272.call(path_568273, query_568274, nil, nil, nil)

var policyAssignmentsGet* = Call_PolicyAssignmentsGet_568265(
    name: "policyAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsGet_568266, base: "",
    url: url_PolicyAssignmentsGet_568267, schemes: {Scheme.Https})
type
  Call_PolicyAssignmentsDelete_568287 = ref object of OpenApiRestCall_567657
proc url_PolicyAssignmentsDelete_568289(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyAssignmentsDelete_568288(path: JsonNode; query: JsonNode;
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
  var valid_568290 = path.getOrDefault("policyAssignmentName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "policyAssignmentName", valid_568290
  var valid_568291 = path.getOrDefault("scope")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "scope", valid_568291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568292 = query.getOrDefault("api-version")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "api-version", valid_568292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568293: Call_PolicyAssignmentsDelete_568287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation deletes a policy assignment, given its name and the scope it was created in. The scope of a policy assignment is the part of its ID preceding '/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}'.
  ## 
  let valid = call_568293.validator(path, query, header, formData, body)
  let scheme = call_568293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568293.url(scheme.get, call_568293.host, call_568293.base,
                         call_568293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568293, url, valid)

proc call*(call_568294: Call_PolicyAssignmentsDelete_568287; apiVersion: string;
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
  var path_568295 = newJObject()
  var query_568296 = newJObject()
  add(query_568296, "api-version", newJString(apiVersion))
  add(path_568295, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_568295, "scope", newJString(scope))
  result = call_568294.call(path_568295, query_568296, nil, nil, nil)

var policyAssignmentsDelete* = Call_PolicyAssignmentsDelete_568287(
    name: "policyAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Authorization/policyAssignments/{policyAssignmentName}",
    validator: validate_PolicyAssignmentsDelete_568288, base: "",
    url: url_PolicyAssignmentsDelete_568289, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
