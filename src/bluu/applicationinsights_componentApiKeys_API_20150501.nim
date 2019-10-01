
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2015-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Application Insights client for API keys of a component.
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
  macServiceName = "applicationinsights-componentApiKeys_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApikeysGet_596680 = ref object of OpenApiRestCall_596458
proc url_ApikeysGet_596682(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "keyId" in path, "`keyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/APIKeys/"),
               (kind: VariableSegment, value: "keyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApikeysGet_596681(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the API Key for this key id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   keyId: JString (required)
  ##        : The API Key ID. This is unique within a Application Insights component.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `keyId` field"
  var valid_596855 = path.getOrDefault("keyId")
  valid_596855 = validateParameter(valid_596855, JString, required = true,
                                 default = nil)
  if valid_596855 != nil:
    section.add "keyId", valid_596855
  var valid_596856 = path.getOrDefault("resourceGroupName")
  valid_596856 = validateParameter(valid_596856, JString, required = true,
                                 default = nil)
  if valid_596856 != nil:
    section.add "resourceGroupName", valid_596856
  var valid_596857 = path.getOrDefault("subscriptionId")
  valid_596857 = validateParameter(valid_596857, JString, required = true,
                                 default = nil)
  if valid_596857 != nil:
    section.add "subscriptionId", valid_596857
  var valid_596858 = path.getOrDefault("resourceName")
  valid_596858 = validateParameter(valid_596858, JString, required = true,
                                 default = nil)
  if valid_596858 != nil:
    section.add "resourceName", valid_596858
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596859 = query.getOrDefault("api-version")
  valid_596859 = validateParameter(valid_596859, JString, required = true,
                                 default = nil)
  if valid_596859 != nil:
    section.add "api-version", valid_596859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596882: Call_ApikeysGet_596680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the API Key for this key id.
  ## 
  let valid = call_596882.validator(path, query, header, formData, body)
  let scheme = call_596882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596882.url(scheme.get, call_596882.host, call_596882.base,
                         call_596882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596882, url, valid)

proc call*(call_596953: Call_ApikeysGet_596680; keyId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## apikeysGet
  ## Get the API Key for this key id.
  ##   keyId: string (required)
  ##        : The API Key ID. This is unique within a Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_596954 = newJObject()
  var query_596956 = newJObject()
  add(path_596954, "keyId", newJString(keyId))
  add(path_596954, "resourceGroupName", newJString(resourceGroupName))
  add(query_596956, "api-version", newJString(apiVersion))
  add(path_596954, "subscriptionId", newJString(subscriptionId))
  add(path_596954, "resourceName", newJString(resourceName))
  result = call_596953.call(path_596954, query_596956, nil, nil, nil)

var apikeysGet* = Call_ApikeysGet_596680(name: "apikeysGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/APIKeys/{keyId}",
                                      validator: validate_ApikeysGet_596681,
                                      base: "", url: url_ApikeysGet_596682,
                                      schemes: {Scheme.Https})
type
  Call_ApikeysDelete_596995 = ref object of OpenApiRestCall_596458
proc url_ApikeysDelete_596997(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "keyId" in path, "`keyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/APIKeys/"),
               (kind: VariableSegment, value: "keyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApikeysDelete_596996(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an API Key of an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   keyId: JString (required)
  ##        : The API Key ID. This is unique within a Application Insights component.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `keyId` field"
  var valid_596998 = path.getOrDefault("keyId")
  valid_596998 = validateParameter(valid_596998, JString, required = true,
                                 default = nil)
  if valid_596998 != nil:
    section.add "keyId", valid_596998
  var valid_596999 = path.getOrDefault("resourceGroupName")
  valid_596999 = validateParameter(valid_596999, JString, required = true,
                                 default = nil)
  if valid_596999 != nil:
    section.add "resourceGroupName", valid_596999
  var valid_597000 = path.getOrDefault("subscriptionId")
  valid_597000 = validateParameter(valid_597000, JString, required = true,
                                 default = nil)
  if valid_597000 != nil:
    section.add "subscriptionId", valid_597000
  var valid_597001 = path.getOrDefault("resourceName")
  valid_597001 = validateParameter(valid_597001, JString, required = true,
                                 default = nil)
  if valid_597001 != nil:
    section.add "resourceName", valid_597001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597002 = query.getOrDefault("api-version")
  valid_597002 = validateParameter(valid_597002, JString, required = true,
                                 default = nil)
  if valid_597002 != nil:
    section.add "api-version", valid_597002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597003: Call_ApikeysDelete_596995; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an API Key of an Application Insights component.
  ## 
  let valid = call_597003.validator(path, query, header, formData, body)
  let scheme = call_597003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597003.url(scheme.get, call_597003.host, call_597003.base,
                         call_597003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597003, url, valid)

proc call*(call_597004: Call_ApikeysDelete_596995; keyId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## apikeysDelete
  ## Delete an API Key of an Application Insights component.
  ##   keyId: string (required)
  ##        : The API Key ID. This is unique within a Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597005 = newJObject()
  var query_597006 = newJObject()
  add(path_597005, "keyId", newJString(keyId))
  add(path_597005, "resourceGroupName", newJString(resourceGroupName))
  add(query_597006, "api-version", newJString(apiVersion))
  add(path_597005, "subscriptionId", newJString(subscriptionId))
  add(path_597005, "resourceName", newJString(resourceName))
  result = call_597004.call(path_597005, query_597006, nil, nil, nil)

var apikeysDelete* = Call_ApikeysDelete_596995(name: "apikeysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/APIKeys/{keyId}",
    validator: validate_ApikeysDelete_596996, base: "", url: url_ApikeysDelete_596997,
    schemes: {Scheme.Https})
type
  Call_ApikeysCreate_597018 = ref object of OpenApiRestCall_596458
proc url_ApikeysCreate_597020(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/ApiKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApikeysCreate_597019(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Create an API Key of an Application Insights component.
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
  ## parameters in `body` object:
  ##   APIKeyProperties: JObject (required)
  ##                   : Properties that need to be specified to create an API key of a Application Insights component.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597026: Call_ApikeysCreate_597018; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an API Key of an Application Insights component.
  ## 
  let valid = call_597026.validator(path, query, header, formData, body)
  let scheme = call_597026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597026.url(scheme.get, call_597026.host, call_597026.base,
                         call_597026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597026, url, valid)

proc call*(call_597027: Call_ApikeysCreate_597018; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          APIKeyProperties: JsonNode): Recallable =
  ## apikeysCreate
  ## Create an API Key of an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   APIKeyProperties: JObject (required)
  ##                   : Properties that need to be specified to create an API key of a Application Insights component.
  var path_597028 = newJObject()
  var query_597029 = newJObject()
  var body_597030 = newJObject()
  add(path_597028, "resourceGroupName", newJString(resourceGroupName))
  add(query_597029, "api-version", newJString(apiVersion))
  add(path_597028, "subscriptionId", newJString(subscriptionId))
  add(path_597028, "resourceName", newJString(resourceName))
  if APIKeyProperties != nil:
    body_597030 = APIKeyProperties
  result = call_597027.call(path_597028, query_597029, nil, nil, body_597030)

var apikeysCreate* = Call_ApikeysCreate_597018(name: "apikeysCreate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/ApiKeys",
    validator: validate_ApikeysCreate_597019, base: "", url: url_ApikeysCreate_597020,
    schemes: {Scheme.Https})
type
  Call_ApikeysList_597007 = ref object of OpenApiRestCall_596458
proc url_ApikeysList_597009(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/ApiKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApikeysList_597008(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of API keys of an Application Insights component.
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
  if body != nil:
    result.add "body", body

proc call*(call_597014: Call_ApikeysList_597007; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of API keys of an Application Insights component.
  ## 
  let valid = call_597014.validator(path, query, header, formData, body)
  let scheme = call_597014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597014.url(scheme.get, call_597014.host, call_597014.base,
                         call_597014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597014, url, valid)

proc call*(call_597015: Call_ApikeysList_597007; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string): Recallable =
  ## apikeysList
  ## Gets a list of API keys of an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_597016 = newJObject()
  var query_597017 = newJObject()
  add(path_597016, "resourceGroupName", newJString(resourceGroupName))
  add(query_597017, "api-version", newJString(apiVersion))
  add(path_597016, "subscriptionId", newJString(subscriptionId))
  add(path_597016, "resourceName", newJString(resourceName))
  result = call_597015.call(path_597016, query_597017, nil, nil, nil)

var apikeysList* = Call_ApikeysList_597007(name: "apikeysList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/ApiKeys",
                                        validator: validate_ApikeysList_597008,
                                        base: "", url: url_ApikeysList_597009,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
