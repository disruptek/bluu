
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Provider API Client
## version: 2016-03-01
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "web-Provider"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProviderGetAvailableStacks_567863 = ref object of OpenApiRestCall_567641
proc url_ProviderGetAvailableStacks_567865(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderGetAvailableStacks_567864(path: JsonNode; query: JsonNode;
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
  var valid_568024 = query.getOrDefault("api-version")
  valid_568024 = validateParameter(valid_568024, JString, required = true,
                                 default = nil)
  if valid_568024 != nil:
    section.add "api-version", valid_568024
  var valid_568038 = query.getOrDefault("osTypeSelected")
  valid_568038 = validateParameter(valid_568038, JString, required = false,
                                 default = newJString("Windows"))
  if valid_568038 != nil:
    section.add "osTypeSelected", valid_568038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568061: Call_ProviderGetAvailableStacks_567863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get available application frameworks and their versions
  ## 
  let valid = call_568061.validator(path, query, header, formData, body)
  let scheme = call_568061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568061.url(scheme.get, call_568061.host, call_568061.base,
                         call_568061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568061, url, valid)

proc call*(call_568132: Call_ProviderGetAvailableStacks_567863; apiVersion: string;
          osTypeSelected: string = "Windows"): Recallable =
  ## providerGetAvailableStacks
  ## Get available application frameworks and their versions
  ##   apiVersion: string (required)
  ##             : API Version
  ##   osTypeSelected: string
  var query_568133 = newJObject()
  add(query_568133, "api-version", newJString(apiVersion))
  add(query_568133, "osTypeSelected", newJString(osTypeSelected))
  result = call_568132.call(nil, query_568133, nil, nil, nil)

var providerGetAvailableStacks* = Call_ProviderGetAvailableStacks_567863(
    name: "providerGetAvailableStacks", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Web/availableStacks",
    validator: validate_ProviderGetAvailableStacks_567864, base: "",
    url: url_ProviderGetAvailableStacks_567865, schemes: {Scheme.Https})
type
  Call_ProviderListOperations_568173 = ref object of OpenApiRestCall_567641
proc url_ProviderListOperations_568175(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProviderListOperations_568174(path: JsonNode; query: JsonNode;
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
  var valid_568176 = query.getOrDefault("api-version")
  valid_568176 = validateParameter(valid_568176, JString, required = true,
                                 default = nil)
  if valid_568176 != nil:
    section.add "api-version", valid_568176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568177: Call_ProviderListOperations_568173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all available operations for the Microsoft.Web resource provider. Also exposes resource metric definitions
  ## 
  let valid = call_568177.validator(path, query, header, formData, body)
  let scheme = call_568177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568177.url(scheme.get, call_568177.host, call_568177.base,
                         call_568177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568177, url, valid)

proc call*(call_568178: Call_ProviderListOperations_568173; apiVersion: string): Recallable =
  ## providerListOperations
  ## Gets all available operations for the Microsoft.Web resource provider. Also exposes resource metric definitions
  ##   apiVersion: string (required)
  ##             : API Version
  var query_568179 = newJObject()
  add(query_568179, "api-version", newJString(apiVersion))
  result = call_568178.call(nil, query_568179, nil, nil, nil)

var providerListOperations* = Call_ProviderListOperations_568173(
    name: "providerListOperations", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Web/operations",
    validator: validate_ProviderListOperations_568174, base: "",
    url: url_ProviderListOperations_568175, schemes: {Scheme.Https})
type
  Call_ProviderGetAvailableStacksOnPrem_568180 = ref object of OpenApiRestCall_567641
proc url_ProviderGetAvailableStacksOnPrem_568182(protocol: Scheme; host: string;
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

proc validate_ProviderGetAvailableStacksOnPrem_568181(path: JsonNode;
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
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  ##   osTypeSelected: JString
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  var valid_568199 = query.getOrDefault("osTypeSelected")
  valid_568199 = validateParameter(valid_568199, JString, required = false,
                                 default = newJString("Windows"))
  if valid_568199 != nil:
    section.add "osTypeSelected", valid_568199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568200: Call_ProviderGetAvailableStacksOnPrem_568180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get available application frameworks and their versions
  ## 
  let valid = call_568200.validator(path, query, header, formData, body)
  let scheme = call_568200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568200.url(scheme.get, call_568200.host, call_568200.base,
                         call_568200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568200, url, valid)

proc call*(call_568201: Call_ProviderGetAvailableStacksOnPrem_568180;
          apiVersion: string; subscriptionId: string;
          osTypeSelected: string = "Windows"): Recallable =
  ## providerGetAvailableStacksOnPrem
  ## Get available application frameworks and their versions
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   osTypeSelected: string
  var path_568202 = newJObject()
  var query_568203 = newJObject()
  add(query_568203, "api-version", newJString(apiVersion))
  add(path_568202, "subscriptionId", newJString(subscriptionId))
  add(query_568203, "osTypeSelected", newJString(osTypeSelected))
  result = call_568201.call(path_568202, query_568203, nil, nil, nil)

var providerGetAvailableStacksOnPrem* = Call_ProviderGetAvailableStacksOnPrem_568180(
    name: "providerGetAvailableStacksOnPrem", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Web/availableStacks",
    validator: validate_ProviderGetAvailableStacksOnPrem_568181, base: "",
    url: url_ProviderGetAvailableStacksOnPrem_568182, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
