
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2017-10-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Application Insights client for selecting pricing plans and options.
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

  OpenApiRestCall_596457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596457): Option[Scheme] {.used.} =
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
  macServiceName = "applicationinsights-componentFeaturesAndPricing_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ComponentCurrentPricingPlanCreateAndUpdate_596993 = ref object of OpenApiRestCall_596457
proc url_ComponentCurrentPricingPlanCreateAndUpdate_596995(protocol: Scheme;
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
        kind: ConstantSegment, value: "/providers/microsoft.insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/pricingPlans/current")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentCurrentPricingPlanCreateAndUpdate_596994(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Replace current pricing plan for an Application Insights component.
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
  var valid_596996 = path.getOrDefault("resourceGroupName")
  valid_596996 = validateParameter(valid_596996, JString, required = true,
                                 default = nil)
  if valid_596996 != nil:
    section.add "resourceGroupName", valid_596996
  var valid_596997 = path.getOrDefault("subscriptionId")
  valid_596997 = validateParameter(valid_596997, JString, required = true,
                                 default = nil)
  if valid_596997 != nil:
    section.add "subscriptionId", valid_596997
  var valid_596998 = path.getOrDefault("resourceName")
  valid_596998 = validateParameter(valid_596998, JString, required = true,
                                 default = nil)
  if valid_596998 != nil:
    section.add "resourceName", valid_596998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596999 = query.getOrDefault("api-version")
  valid_596999 = validateParameter(valid_596999, JString, required = true,
                                 default = nil)
  if valid_596999 != nil:
    section.add "api-version", valid_596999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   PricingPlanProperties: JObject (required)
  ##                        : Properties that need to be specified to update current pricing plan for an Application Insights component.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597001: Call_ComponentCurrentPricingPlanCreateAndUpdate_596993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace current pricing plan for an Application Insights component.
  ## 
  let valid = call_597001.validator(path, query, header, formData, body)
  let scheme = call_597001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597001.url(scheme.get, call_597001.host, call_597001.base,
                         call_597001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597001, url, valid)

proc call*(call_597002: Call_ComponentCurrentPricingPlanCreateAndUpdate_596993;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; PricingPlanProperties: JsonNode): Recallable =
  ## componentCurrentPricingPlanCreateAndUpdate
  ## Replace current pricing plan for an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   PricingPlanProperties: JObject (required)
  ##                        : Properties that need to be specified to update current pricing plan for an Application Insights component.
  var path_597003 = newJObject()
  var query_597004 = newJObject()
  var body_597005 = newJObject()
  add(path_597003, "resourceGroupName", newJString(resourceGroupName))
  add(query_597004, "api-version", newJString(apiVersion))
  add(path_597003, "subscriptionId", newJString(subscriptionId))
  add(path_597003, "resourceName", newJString(resourceName))
  if PricingPlanProperties != nil:
    body_597005 = PricingPlanProperties
  result = call_597002.call(path_597003, query_597004, nil, nil, body_597005)

var componentCurrentPricingPlanCreateAndUpdate* = Call_ComponentCurrentPricingPlanCreateAndUpdate_596993(
    name: "componentCurrentPricingPlanCreateAndUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/pricingPlans/current",
    validator: validate_ComponentCurrentPricingPlanCreateAndUpdate_596994,
    base: "", url: url_ComponentCurrentPricingPlanCreateAndUpdate_596995,
    schemes: {Scheme.Https})
type
  Call_ComponentCurrentPricingPlanGet_596679 = ref object of OpenApiRestCall_596457
proc url_ComponentCurrentPricingPlanGet_596681(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/microsoft.insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/pricingPlans/current")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentCurrentPricingPlanGet_596680(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the current pricing plan setting for an Application Insights component.
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
  var valid_596854 = path.getOrDefault("resourceGroupName")
  valid_596854 = validateParameter(valid_596854, JString, required = true,
                                 default = nil)
  if valid_596854 != nil:
    section.add "resourceGroupName", valid_596854
  var valid_596855 = path.getOrDefault("subscriptionId")
  valid_596855 = validateParameter(valid_596855, JString, required = true,
                                 default = nil)
  if valid_596855 != nil:
    section.add "subscriptionId", valid_596855
  var valid_596856 = path.getOrDefault("resourceName")
  valid_596856 = validateParameter(valid_596856, JString, required = true,
                                 default = nil)
  if valid_596856 != nil:
    section.add "resourceName", valid_596856
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596857 = query.getOrDefault("api-version")
  valid_596857 = validateParameter(valid_596857, JString, required = true,
                                 default = nil)
  if valid_596857 != nil:
    section.add "api-version", valid_596857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596880: Call_ComponentCurrentPricingPlanGet_596679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current pricing plan setting for an Application Insights component.
  ## 
  let valid = call_596880.validator(path, query, header, formData, body)
  let scheme = call_596880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596880.url(scheme.get, call_596880.host, call_596880.base,
                         call_596880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596880, url, valid)

proc call*(call_596951: Call_ComponentCurrentPricingPlanGet_596679;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## componentCurrentPricingPlanGet
  ## Returns the current pricing plan setting for an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_596952 = newJObject()
  var query_596954 = newJObject()
  add(path_596952, "resourceGroupName", newJString(resourceGroupName))
  add(query_596954, "api-version", newJString(apiVersion))
  add(path_596952, "subscriptionId", newJString(subscriptionId))
  add(path_596952, "resourceName", newJString(resourceName))
  result = call_596951.call(path_596952, query_596954, nil, nil, nil)

var componentCurrentPricingPlanGet* = Call_ComponentCurrentPricingPlanGet_596679(
    name: "componentCurrentPricingPlanGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/pricingPlans/current",
    validator: validate_ComponentCurrentPricingPlanGet_596680, base: "",
    url: url_ComponentCurrentPricingPlanGet_596681, schemes: {Scheme.Https})
type
  Call_ComponentCurrentPricingPlanUpdate_597006 = ref object of OpenApiRestCall_596457
proc url_ComponentCurrentPricingPlanUpdate_597008(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/microsoft.insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/pricingPlans/current")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentCurrentPricingPlanUpdate_597007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update current pricing plan for an Application Insights component.
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
  var valid_597009 = path.getOrDefault("resourceGroupName")
  valid_597009 = validateParameter(valid_597009, JString, required = true,
                                 default = nil)
  if valid_597009 != nil:
    section.add "resourceGroupName", valid_597009
  var valid_597010 = path.getOrDefault("subscriptionId")
  valid_597010 = validateParameter(valid_597010, JString, required = true,
                                 default = nil)
  if valid_597010 != nil:
    section.add "subscriptionId", valid_597010
  var valid_597011 = path.getOrDefault("resourceName")
  valid_597011 = validateParameter(valid_597011, JString, required = true,
                                 default = nil)
  if valid_597011 != nil:
    section.add "resourceName", valid_597011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597012 = query.getOrDefault("api-version")
  valid_597012 = validateParameter(valid_597012, JString, required = true,
                                 default = nil)
  if valid_597012 != nil:
    section.add "api-version", valid_597012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   PricingPlanProperties: JObject (required)
  ##                        : Properties that need to be specified to update current pricing plan for an Application Insights component.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597014: Call_ComponentCurrentPricingPlanUpdate_597006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update current pricing plan for an Application Insights component.
  ## 
  let valid = call_597014.validator(path, query, header, formData, body)
  let scheme = call_597014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597014.url(scheme.get, call_597014.host, call_597014.base,
                         call_597014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597014, url, valid)

proc call*(call_597015: Call_ComponentCurrentPricingPlanUpdate_597006;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; PricingPlanProperties: JsonNode): Recallable =
  ## componentCurrentPricingPlanUpdate
  ## Update current pricing plan for an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   PricingPlanProperties: JObject (required)
  ##                        : Properties that need to be specified to update current pricing plan for an Application Insights component.
  var path_597016 = newJObject()
  var query_597017 = newJObject()
  var body_597018 = newJObject()
  add(path_597016, "resourceGroupName", newJString(resourceGroupName))
  add(query_597017, "api-version", newJString(apiVersion))
  add(path_597016, "subscriptionId", newJString(subscriptionId))
  add(path_597016, "resourceName", newJString(resourceName))
  if PricingPlanProperties != nil:
    body_597018 = PricingPlanProperties
  result = call_597015.call(path_597016, query_597017, nil, nil, body_597018)

var componentCurrentPricingPlanUpdate* = Call_ComponentCurrentPricingPlanUpdate_597006(
    name: "componentCurrentPricingPlanUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/pricingPlans/current",
    validator: validate_ComponentCurrentPricingPlanUpdate_597007, base: "",
    url: url_ComponentCurrentPricingPlanUpdate_597008, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
