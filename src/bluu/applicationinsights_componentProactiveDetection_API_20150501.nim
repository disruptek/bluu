
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2015-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Application Insights client for ProactiveDetection configurations of a component.
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
  macServiceName = "applicationinsights-componentProactiveDetection_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProactiveDetectionConfigurationsList_596680 = ref object of OpenApiRestCall_596458
proc url_ProactiveDetectionConfigurationsList_596682(protocol: Scheme;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/ProactiveDetectionConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProactiveDetectionConfigurationsList_596681(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of ProactiveDetection configurations of an Application Insights component.
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

proc call*(call_596881: Call_ProactiveDetectionConfigurationsList_596680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of ProactiveDetection configurations of an Application Insights component.
  ## 
  let valid = call_596881.validator(path, query, header, formData, body)
  let scheme = call_596881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596881.url(scheme.get, call_596881.host, call_596881.base,
                         call_596881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596881, url, valid)

proc call*(call_596952: Call_ProactiveDetectionConfigurationsList_596680;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## proactiveDetectionConfigurationsList
  ## Gets a list of ProactiveDetection configurations of an Application Insights component.
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

var proactiveDetectionConfigurationsList* = Call_ProactiveDetectionConfigurationsList_596680(
    name: "proactiveDetectionConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/ProactiveDetectionConfigs",
    validator: validate_ProactiveDetectionConfigurationsList_596681, base: "",
    url: url_ProactiveDetectionConfigurationsList_596682, schemes: {Scheme.Https})
type
  Call_ProactiveDetectionConfigurationsUpdate_597006 = ref object of OpenApiRestCall_596458
proc url_ProactiveDetectionConfigurationsUpdate_597008(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "ConfigurationId" in path, "`ConfigurationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/ProactiveDetectionConfigs/"),
               (kind: VariableSegment, value: "ConfigurationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProactiveDetectionConfigurationsUpdate_597007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the ProactiveDetection configuration for this configuration id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ConfigurationId: JString (required)
  ##                  : The ProactiveDetection configuration ID. This is unique within a Application Insights component.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ConfigurationId` field"
  var valid_597009 = path.getOrDefault("ConfigurationId")
  valid_597009 = validateParameter(valid_597009, JString, required = true,
                                 default = nil)
  if valid_597009 != nil:
    section.add "ConfigurationId", valid_597009
  var valid_597010 = path.getOrDefault("resourceGroupName")
  valid_597010 = validateParameter(valid_597010, JString, required = true,
                                 default = nil)
  if valid_597010 != nil:
    section.add "resourceGroupName", valid_597010
  var valid_597011 = path.getOrDefault("subscriptionId")
  valid_597011 = validateParameter(valid_597011, JString, required = true,
                                 default = nil)
  if valid_597011 != nil:
    section.add "subscriptionId", valid_597011
  var valid_597012 = path.getOrDefault("resourceName")
  valid_597012 = validateParameter(valid_597012, JString, required = true,
                                 default = nil)
  if valid_597012 != nil:
    section.add "resourceName", valid_597012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597013 = query.getOrDefault("api-version")
  valid_597013 = validateParameter(valid_597013, JString, required = true,
                                 default = nil)
  if valid_597013 != nil:
    section.add "api-version", valid_597013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ProactiveDetectionProperties: JObject (required)
  ##                               : Properties that need to be specified to update the ProactiveDetection configuration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597015: Call_ProactiveDetectionConfigurationsUpdate_597006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the ProactiveDetection configuration for this configuration id.
  ## 
  let valid = call_597015.validator(path, query, header, formData, body)
  let scheme = call_597015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597015.url(scheme.get, call_597015.host, call_597015.base,
                         call_597015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597015, url, valid)

proc call*(call_597016: Call_ProactiveDetectionConfigurationsUpdate_597006;
          ConfigurationId: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string;
          ProactiveDetectionProperties: JsonNode): Recallable =
  ## proactiveDetectionConfigurationsUpdate
  ## Update the ProactiveDetection configuration for this configuration id.
  ##   ConfigurationId: string (required)
  ##                  : The ProactiveDetection configuration ID. This is unique within a Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   ProactiveDetectionProperties: JObject (required)
  ##                               : Properties that need to be specified to update the ProactiveDetection configuration.
  var path_597017 = newJObject()
  var query_597018 = newJObject()
  var body_597019 = newJObject()
  add(path_597017, "ConfigurationId", newJString(ConfigurationId))
  add(path_597017, "resourceGroupName", newJString(resourceGroupName))
  add(query_597018, "api-version", newJString(apiVersion))
  add(path_597017, "subscriptionId", newJString(subscriptionId))
  add(path_597017, "resourceName", newJString(resourceName))
  if ProactiveDetectionProperties != nil:
    body_597019 = ProactiveDetectionProperties
  result = call_597016.call(path_597017, query_597018, nil, nil, body_597019)

var proactiveDetectionConfigurationsUpdate* = Call_ProactiveDetectionConfigurationsUpdate_597006(
    name: "proactiveDetectionConfigurationsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/ProactiveDetectionConfigs/{ConfigurationId}",
    validator: validate_ProactiveDetectionConfigurationsUpdate_597007, base: "",
    url: url_ProactiveDetectionConfigurationsUpdate_597008,
    schemes: {Scheme.Https})
type
  Call_ProactiveDetectionConfigurationsGet_596994 = ref object of OpenApiRestCall_596458
proc url_ProactiveDetectionConfigurationsGet_596996(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "ConfigurationId" in path, "`ConfigurationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/ProactiveDetectionConfigs/"),
               (kind: VariableSegment, value: "ConfigurationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProactiveDetectionConfigurationsGet_596995(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the ProactiveDetection configuration for this configuration id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ConfigurationId: JString (required)
  ##                  : The ProactiveDetection configuration ID. This is unique within a Application Insights component.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `ConfigurationId` field"
  var valid_596997 = path.getOrDefault("ConfigurationId")
  valid_596997 = validateParameter(valid_596997, JString, required = true,
                                 default = nil)
  if valid_596997 != nil:
    section.add "ConfigurationId", valid_596997
  var valid_596998 = path.getOrDefault("resourceGroupName")
  valid_596998 = validateParameter(valid_596998, JString, required = true,
                                 default = nil)
  if valid_596998 != nil:
    section.add "resourceGroupName", valid_596998
  var valid_596999 = path.getOrDefault("subscriptionId")
  valid_596999 = validateParameter(valid_596999, JString, required = true,
                                 default = nil)
  if valid_596999 != nil:
    section.add "subscriptionId", valid_596999
  var valid_597000 = path.getOrDefault("resourceName")
  valid_597000 = validateParameter(valid_597000, JString, required = true,
                                 default = nil)
  if valid_597000 != nil:
    section.add "resourceName", valid_597000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597001 = query.getOrDefault("api-version")
  valid_597001 = validateParameter(valid_597001, JString, required = true,
                                 default = nil)
  if valid_597001 != nil:
    section.add "api-version", valid_597001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597002: Call_ProactiveDetectionConfigurationsGet_596994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the ProactiveDetection configuration for this configuration id.
  ## 
  let valid = call_597002.validator(path, query, header, formData, body)
  let scheme = call_597002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597002.url(scheme.get, call_597002.host, call_597002.base,
                         call_597002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597002, url, valid)

proc call*(call_597003: Call_ProactiveDetectionConfigurationsGet_596994;
          ConfigurationId: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string): Recallable =
  ## proactiveDetectionConfigurationsGet
  ## Get the ProactiveDetection configuration for this configuration id.
  ##   ConfigurationId: string (required)
  ##                  : The ProactiveDetection configuration ID. This is unique within a Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597004 = newJObject()
  var query_597005 = newJObject()
  add(path_597004, "ConfigurationId", newJString(ConfigurationId))
  add(path_597004, "resourceGroupName", newJString(resourceGroupName))
  add(query_597005, "api-version", newJString(apiVersion))
  add(path_597004, "subscriptionId", newJString(subscriptionId))
  add(path_597004, "resourceName", newJString(resourceName))
  result = call_597003.call(path_597004, query_597005, nil, nil, nil)

var proactiveDetectionConfigurationsGet* = Call_ProactiveDetectionConfigurationsGet_596994(
    name: "proactiveDetectionConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/ProactiveDetectionConfigs/{ConfigurationId}",
    validator: validate_ProactiveDetectionConfigurationsGet_596995, base: "",
    url: url_ProactiveDetectionConfigurationsGet_596996, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
