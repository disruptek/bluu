
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Provider API Client
## version: 2018-02-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "web-Provider"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProviderGetAvailableStacks_593630 = ref object of OpenApiRestCall_593408
proc url_ProviderGetAvailableStacks_593632(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderGetAvailableStacks_593631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get available application frameworks and their versions
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   osTypeSelected: JString
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593791 = query.getOrDefault("api-version")
  valid_593791 = validateParameter(valid_593791, JString, required = true,
                                 default = nil)
  if valid_593791 != nil:
    section.add "api-version", valid_593791
  var valid_593805 = query.getOrDefault("osTypeSelected")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = newJString("Windows"))
  if valid_593805 != nil:
    section.add "osTypeSelected", valid_593805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593828: Call_ProviderGetAvailableStacks_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get available application frameworks and their versions
  ## 
  let valid = call_593828.validator(path, query, header, formData, body)
  let scheme = call_593828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593828.url(scheme.get, call_593828.host, call_593828.base,
                         call_593828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593828, url, valid)

proc call*(call_593899: Call_ProviderGetAvailableStacks_593630; apiVersion: string;
          osTypeSelected: string = "Windows"): Recallable =
  ## providerGetAvailableStacks
  ## Get available application frameworks and their versions
  ##   apiVersion: string (required)
  ##             : API Version
  ##   osTypeSelected: string
  var query_593900 = newJObject()
  add(query_593900, "api-version", newJString(apiVersion))
  add(query_593900, "osTypeSelected", newJString(osTypeSelected))
  result = call_593899.call(nil, query_593900, nil, nil, nil)

var providerGetAvailableStacks* = Call_ProviderGetAvailableStacks_593630(
    name: "providerGetAvailableStacks", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Web/availableStacks",
    validator: validate_ProviderGetAvailableStacks_593631, base: "",
    url: url_ProviderGetAvailableStacks_593632, schemes: {Scheme.Https})
type
  Call_ProviderListOperations_593940 = ref object of OpenApiRestCall_593408
proc url_ProviderListOperations_593942(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderListOperations_593941(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all available operations for the Microsoft.Web resource provider. Also exposes resource metric definitions
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593943 = query.getOrDefault("api-version")
  valid_593943 = validateParameter(valid_593943, JString, required = true,
                                 default = nil)
  if valid_593943 != nil:
    section.add "api-version", valid_593943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593944: Call_ProviderListOperations_593940; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all available operations for the Microsoft.Web resource provider. Also exposes resource metric definitions
  ## 
  let valid = call_593944.validator(path, query, header, formData, body)
  let scheme = call_593944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593944.url(scheme.get, call_593944.host, call_593944.base,
                         call_593944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593944, url, valid)

proc call*(call_593945: Call_ProviderListOperations_593940; apiVersion: string): Recallable =
  ## providerListOperations
  ## Gets all available operations for the Microsoft.Web resource provider. Also exposes resource metric definitions
  ##   apiVersion: string (required)
  ##             : API Version
  var query_593946 = newJObject()
  add(query_593946, "api-version", newJString(apiVersion))
  result = call_593945.call(nil, query_593946, nil, nil, nil)

var providerListOperations* = Call_ProviderListOperations_593940(
    name: "providerListOperations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Web/operations",
    validator: validate_ProviderListOperations_593941, base: "",
    url: url_ProviderListOperations_593942, schemes: {Scheme.Https})
type
  Call_ProviderGetAvailableStacksOnPrem_593947 = ref object of OpenApiRestCall_593408
proc url_ProviderGetAvailableStacksOnPrem_593949(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Web/availableStacks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProviderGetAvailableStacksOnPrem_593948(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get available application frameworks and their versions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593964 = path.getOrDefault("subscriptionId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "subscriptionId", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   osTypeSelected: JString
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  var valid_593966 = query.getOrDefault("osTypeSelected")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = newJString("Windows"))
  if valid_593966 != nil:
    section.add "osTypeSelected", valid_593966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593967: Call_ProviderGetAvailableStacksOnPrem_593947;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get available application frameworks and their versions
  ## 
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_ProviderGetAvailableStacksOnPrem_593947;
          apiVersion: string; subscriptionId: string;
          osTypeSelected: string = "Windows"): Recallable =
  ## providerGetAvailableStacksOnPrem
  ## Get available application frameworks and their versions
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   osTypeSelected: string
  var path_593969 = newJObject()
  var query_593970 = newJObject()
  add(query_593970, "api-version", newJString(apiVersion))
  add(path_593969, "subscriptionId", newJString(subscriptionId))
  add(query_593970, "osTypeSelected", newJString(osTypeSelected))
  result = call_593968.call(path_593969, query_593970, nil, nil, nil)

var providerGetAvailableStacksOnPrem* = Call_ProviderGetAvailableStacksOnPrem_593947(
    name: "providerGetAvailableStacksOnPrem", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/availableStacks",
    validator: validate_ProviderGetAvailableStacksOnPrem_593948, base: "",
    url: url_ProviderGetAvailableStacksOnPrem_593949, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
