
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2015-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Application Insights client for work item configurations for a component.
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

  OpenApiRestCall_596458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596458): Option[Scheme] {.used.} =
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
  macServiceName = "applicationinsights-componentWorkItemConfigs_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_WorkItemConfigurationsGetDefault_596680 = ref object of OpenApiRestCall_596458
proc url_WorkItemConfigurationsGetDefault_596682(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/DefaultWorkItemConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkItemConfigurationsGetDefault_596681(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets default work item configurations that exist for the application
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596855 = path.getOrDefault("resourceGroupName")
  valid_596855 = validateParameter(valid_596855, JString, required = true,
                                 default = nil)
  if valid_596855 != nil:
    section.add "resourceGroupName", valid_596855
  var valid_596856 = path.getOrDefault("subscriptionId")
  valid_596856 = validateParameter(valid_596856, JString, required = true,
                                 default = nil)
  if valid_596856 != nil:
    section.add "subscriptionId", valid_596856
  var valid_596857 = path.getOrDefault("resourceName")
  valid_596857 = validateParameter(valid_596857, JString, required = true,
                                 default = nil)
  if valid_596857 != nil:
    section.add "resourceName", valid_596857
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596858 = query.getOrDefault("api-version")
  valid_596858 = validateParameter(valid_596858, JString, required = true,
                                 default = nil)
  if valid_596858 != nil:
    section.add "api-version", valid_596858
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596881: Call_WorkItemConfigurationsGetDefault_596680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets default work item configurations that exist for the application
  ## 
  let valid = call_596881.validator(path, query, header, formData, body)
  let scheme = call_596881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596881.url(scheme.get, call_596881.host, call_596881.base,
                         call_596881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596881, url, valid)

proc call*(call_596952: Call_WorkItemConfigurationsGetDefault_596680;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## workItemConfigurationsGetDefault
  ## Gets default work item configurations that exist for the application
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_596953 = newJObject()
  var query_596955 = newJObject()
  add(path_596953, "resourceGroupName", newJString(resourceGroupName))
  add(query_596955, "api-version", newJString(apiVersion))
  add(path_596953, "subscriptionId", newJString(subscriptionId))
  add(path_596953, "resourceName", newJString(resourceName))
  result = call_596952.call(path_596953, query_596955, nil, nil, nil)

var workItemConfigurationsGetDefault* = Call_WorkItemConfigurationsGetDefault_596680(
    name: "workItemConfigurationsGetDefault", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/DefaultWorkItemConfig",
    validator: validate_WorkItemConfigurationsGetDefault_596681, base: "",
    url: url_WorkItemConfigurationsGetDefault_596682, schemes: {Scheme.Https})
type
  Call_WorkItemConfigurationsCreate_597005 = ref object of OpenApiRestCall_596458
proc url_WorkItemConfigurationsCreate_597007(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/WorkItemConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkItemConfigurationsCreate_597006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a work item configuration for an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597008 = path.getOrDefault("resourceGroupName")
  valid_597008 = validateParameter(valid_597008, JString, required = true,
                                 default = nil)
  if valid_597008 != nil:
    section.add "resourceGroupName", valid_597008
  var valid_597009 = path.getOrDefault("subscriptionId")
  valid_597009 = validateParameter(valid_597009, JString, required = true,
                                 default = nil)
  if valid_597009 != nil:
    section.add "subscriptionId", valid_597009
  var valid_597010 = path.getOrDefault("resourceName")
  valid_597010 = validateParameter(valid_597010, JString, required = true,
                                 default = nil)
  if valid_597010 != nil:
    section.add "resourceName", valid_597010
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597011 = query.getOrDefault("api-version")
  valid_597011 = validateParameter(valid_597011, JString, required = true,
                                 default = nil)
  if valid_597011 != nil:
    section.add "api-version", valid_597011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   WorkItemConfigurationProperties: JObject (required)
  ##                                  : Properties that need to be specified to create a work item configuration of a Application Insights component.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597013: Call_WorkItemConfigurationsCreate_597005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a work item configuration for an Application Insights component.
  ## 
  let valid = call_597013.validator(path, query, header, formData, body)
  let scheme = call_597013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597013.url(scheme.get, call_597013.host, call_597013.base,
                         call_597013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597013, url, valid)

proc call*(call_597014: Call_WorkItemConfigurationsCreate_597005;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; WorkItemConfigurationProperties: JsonNode): Recallable =
  ## workItemConfigurationsCreate
  ## Create a work item configuration for an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   WorkItemConfigurationProperties: JObject (required)
  ##                                  : Properties that need to be specified to create a work item configuration of a Application Insights component.
  var path_597015 = newJObject()
  var query_597016 = newJObject()
  var body_597017 = newJObject()
  add(path_597015, "resourceGroupName", newJString(resourceGroupName))
  add(query_597016, "api-version", newJString(apiVersion))
  add(path_597015, "subscriptionId", newJString(subscriptionId))
  add(path_597015, "resourceName", newJString(resourceName))
  if WorkItemConfigurationProperties != nil:
    body_597017 = WorkItemConfigurationProperties
  result = call_597014.call(path_597015, query_597016, nil, nil, body_597017)

var workItemConfigurationsCreate* = Call_WorkItemConfigurationsCreate_597005(
    name: "workItemConfigurationsCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/WorkItemConfigs",
    validator: validate_WorkItemConfigurationsCreate_597006, base: "",
    url: url_WorkItemConfigurationsCreate_597007, schemes: {Scheme.Https})
type
  Call_WorkItemConfigurationsList_596994 = ref object of OpenApiRestCall_596458
proc url_WorkItemConfigurationsList_596996(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/WorkItemConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkItemConfigurationsList_596995(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list work item configurations that exist for the application
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596997 = path.getOrDefault("resourceGroupName")
  valid_596997 = validateParameter(valid_596997, JString, required = true,
                                 default = nil)
  if valid_596997 != nil:
    section.add "resourceGroupName", valid_596997
  var valid_596998 = path.getOrDefault("subscriptionId")
  valid_596998 = validateParameter(valid_596998, JString, required = true,
                                 default = nil)
  if valid_596998 != nil:
    section.add "subscriptionId", valid_596998
  var valid_596999 = path.getOrDefault("resourceName")
  valid_596999 = validateParameter(valid_596999, JString, required = true,
                                 default = nil)
  if valid_596999 != nil:
    section.add "resourceName", valid_596999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597000 = query.getOrDefault("api-version")
  valid_597000 = validateParameter(valid_597000, JString, required = true,
                                 default = nil)
  if valid_597000 != nil:
    section.add "api-version", valid_597000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597001: Call_WorkItemConfigurationsList_596994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list work item configurations that exist for the application
  ## 
  let valid = call_597001.validator(path, query, header, formData, body)
  let scheme = call_597001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597001.url(scheme.get, call_597001.host, call_597001.base,
                         call_597001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597001, url, valid)

proc call*(call_597002: Call_WorkItemConfigurationsList_596994;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## workItemConfigurationsList
  ## Gets the list work item configurations that exist for the application
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597003 = newJObject()
  var query_597004 = newJObject()
  add(path_597003, "resourceGroupName", newJString(resourceGroupName))
  add(query_597004, "api-version", newJString(apiVersion))
  add(path_597003, "subscriptionId", newJString(subscriptionId))
  add(path_597003, "resourceName", newJString(resourceName))
  result = call_597002.call(path_597003, query_597004, nil, nil, nil)

var workItemConfigurationsList* = Call_WorkItemConfigurationsList_596994(
    name: "workItemConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/WorkItemConfigs",
    validator: validate_WorkItemConfigurationsList_596995, base: "",
    url: url_WorkItemConfigurationsList_596996, schemes: {Scheme.Https})
type
  Call_WorkItemConfigurationsGetItem_597018 = ref object of OpenApiRestCall_596458
proc url_WorkItemConfigurationsGetItem_597020(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "workItemConfigId" in path,
        "`workItemConfigId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/WorkItemConfigs/"),
               (kind: VariableSegment, value: "workItemConfigId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkItemConfigurationsGetItem_597019(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets specified work item configuration for an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  ##   workItemConfigId: JString (required)
  ##                   : The unique work item configuration Id. This can be either friendly name of connector as defined in connector configuration
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597021 = path.getOrDefault("resourceGroupName")
  valid_597021 = validateParameter(valid_597021, JString, required = true,
                                 default = nil)
  if valid_597021 != nil:
    section.add "resourceGroupName", valid_597021
  var valid_597022 = path.getOrDefault("subscriptionId")
  valid_597022 = validateParameter(valid_597022, JString, required = true,
                                 default = nil)
  if valid_597022 != nil:
    section.add "subscriptionId", valid_597022
  var valid_597023 = path.getOrDefault("resourceName")
  valid_597023 = validateParameter(valid_597023, JString, required = true,
                                 default = nil)
  if valid_597023 != nil:
    section.add "resourceName", valid_597023
  var valid_597024 = path.getOrDefault("workItemConfigId")
  valid_597024 = validateParameter(valid_597024, JString, required = true,
                                 default = nil)
  if valid_597024 != nil:
    section.add "workItemConfigId", valid_597024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597025 = query.getOrDefault("api-version")
  valid_597025 = validateParameter(valid_597025, JString, required = true,
                                 default = nil)
  if valid_597025 != nil:
    section.add "api-version", valid_597025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597026: Call_WorkItemConfigurationsGetItem_597018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets specified work item configuration for an Application Insights component.
  ## 
  let valid = call_597026.validator(path, query, header, formData, body)
  let scheme = call_597026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597026.url(scheme.get, call_597026.host, call_597026.base,
                         call_597026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597026, url, valid)

proc call*(call_597027: Call_WorkItemConfigurationsGetItem_597018;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; workItemConfigId: string): Recallable =
  ## workItemConfigurationsGetItem
  ## Gets specified work item configuration for an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   workItemConfigId: string (required)
  ##                   : The unique work item configuration Id. This can be either friendly name of connector as defined in connector configuration
  var path_597028 = newJObject()
  var query_597029 = newJObject()
  add(path_597028, "resourceGroupName", newJString(resourceGroupName))
  add(query_597029, "api-version", newJString(apiVersion))
  add(path_597028, "subscriptionId", newJString(subscriptionId))
  add(path_597028, "resourceName", newJString(resourceName))
  add(path_597028, "workItemConfigId", newJString(workItemConfigId))
  result = call_597027.call(path_597028, query_597029, nil, nil, nil)

var workItemConfigurationsGetItem* = Call_WorkItemConfigurationsGetItem_597018(
    name: "workItemConfigurationsGetItem", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/WorkItemConfigs/{workItemConfigId}",
    validator: validate_WorkItemConfigurationsGetItem_597019, base: "",
    url: url_WorkItemConfigurationsGetItem_597020, schemes: {Scheme.Https})
type
  Call_WorkItemConfigurationsUpdateItem_597042 = ref object of OpenApiRestCall_596458
proc url_WorkItemConfigurationsUpdateItem_597044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "workItemConfigId" in path,
        "`workItemConfigId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/WorkItemConfigs/"),
               (kind: VariableSegment, value: "workItemConfigId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkItemConfigurationsUpdateItem_597043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a work item configuration for an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  ##   workItemConfigId: JString (required)
  ##                   : The unique work item configuration Id. This can be either friendly name of connector as defined in connector configuration
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597045 = path.getOrDefault("resourceGroupName")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "resourceGroupName", valid_597045
  var valid_597046 = path.getOrDefault("subscriptionId")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "subscriptionId", valid_597046
  var valid_597047 = path.getOrDefault("resourceName")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "resourceName", valid_597047
  var valid_597048 = path.getOrDefault("workItemConfigId")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "workItemConfigId", valid_597048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597049 = query.getOrDefault("api-version")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "api-version", valid_597049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   WorkItemConfigurationProperties: JObject (required)
  ##                                  : Properties that need to be specified to update a work item configuration for this Application Insights component.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597051: Call_WorkItemConfigurationsUpdateItem_597042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a work item configuration for an Application Insights component.
  ## 
  let valid = call_597051.validator(path, query, header, formData, body)
  let scheme = call_597051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597051.url(scheme.get, call_597051.host, call_597051.base,
                         call_597051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597051, url, valid)

proc call*(call_597052: Call_WorkItemConfigurationsUpdateItem_597042;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; WorkItemConfigurationProperties: JsonNode;
          workItemConfigId: string): Recallable =
  ## workItemConfigurationsUpdateItem
  ## Update a work item configuration for an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   WorkItemConfigurationProperties: JObject (required)
  ##                                  : Properties that need to be specified to update a work item configuration for this Application Insights component.
  ##   workItemConfigId: string (required)
  ##                   : The unique work item configuration Id. This can be either friendly name of connector as defined in connector configuration
  var path_597053 = newJObject()
  var query_597054 = newJObject()
  var body_597055 = newJObject()
  add(path_597053, "resourceGroupName", newJString(resourceGroupName))
  add(query_597054, "api-version", newJString(apiVersion))
  add(path_597053, "subscriptionId", newJString(subscriptionId))
  add(path_597053, "resourceName", newJString(resourceName))
  if WorkItemConfigurationProperties != nil:
    body_597055 = WorkItemConfigurationProperties
  add(path_597053, "workItemConfigId", newJString(workItemConfigId))
  result = call_597052.call(path_597053, query_597054, nil, nil, body_597055)

var workItemConfigurationsUpdateItem* = Call_WorkItemConfigurationsUpdateItem_597042(
    name: "workItemConfigurationsUpdateItem", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/WorkItemConfigs/{workItemConfigId}",
    validator: validate_WorkItemConfigurationsUpdateItem_597043, base: "",
    url: url_WorkItemConfigurationsUpdateItem_597044, schemes: {Scheme.Https})
type
  Call_WorkItemConfigurationsDelete_597030 = ref object of OpenApiRestCall_596458
proc url_WorkItemConfigurationsDelete_597032(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "workItemConfigId" in path,
        "`workItemConfigId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/WorkItemConfigs/"),
               (kind: VariableSegment, value: "workItemConfigId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkItemConfigurationsDelete_597031(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a work item configuration of an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  ##   workItemConfigId: JString (required)
  ##                   : The unique work item configuration Id. This can be either friendly name of connector as defined in connector configuration
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_597036 = path.getOrDefault("workItemConfigId")
  valid_597036 = validateParameter(valid_597036, JString, required = true,
                                 default = nil)
  if valid_597036 != nil:
    section.add "workItemConfigId", valid_597036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597037 = query.getOrDefault("api-version")
  valid_597037 = validateParameter(valid_597037, JString, required = true,
                                 default = nil)
  if valid_597037 != nil:
    section.add "api-version", valid_597037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597038: Call_WorkItemConfigurationsDelete_597030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a work item configuration of an Application Insights component.
  ## 
  let valid = call_597038.validator(path, query, header, formData, body)
  let scheme = call_597038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597038.url(scheme.get, call_597038.host, call_597038.base,
                         call_597038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597038, url, valid)

proc call*(call_597039: Call_WorkItemConfigurationsDelete_597030;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; workItemConfigId: string): Recallable =
  ## workItemConfigurationsDelete
  ## Delete a work item configuration of an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   workItemConfigId: string (required)
  ##                   : The unique work item configuration Id. This can be either friendly name of connector as defined in connector configuration
  var path_597040 = newJObject()
  var query_597041 = newJObject()
  add(path_597040, "resourceGroupName", newJString(resourceGroupName))
  add(query_597041, "api-version", newJString(apiVersion))
  add(path_597040, "subscriptionId", newJString(subscriptionId))
  add(path_597040, "resourceName", newJString(resourceName))
  add(path_597040, "workItemConfigId", newJString(workItemConfigId))
  result = call_597039.call(path_597040, query_597041, nil, nil, nil)

var workItemConfigurationsDelete* = Call_WorkItemConfigurationsDelete_597030(
    name: "workItemConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/WorkItemConfigs/{workItemConfigId}",
    validator: validate_WorkItemConfigurationsDelete_597031, base: "",
    url: url_WorkItemConfigurationsDelete_597032, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
