
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SubscriptionClient
## version: 2019-03-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Subscription client provides an interface to create and manage Azure subscriptions programmatically.
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
  macServiceName = "subscription-subscriptions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubscriptionsCancel_567863 = ref object of OpenApiRestCall_567641
proc url_SubscriptionsCancel_567865(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Subscription/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsCancel_567864(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The operation to cancel a subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568038 = path.getOrDefault("subscriptionId")
  valid_568038 = validateParameter(valid_568038, JString, required = true,
                                 default = nil)
  if valid_568038 != nil:
    section.add "subscriptionId", valid_568038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568039 = query.getOrDefault("api-version")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "api-version", valid_568039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568062: Call_SubscriptionsCancel_567863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to cancel a subscription
  ## 
  let valid = call_568062.validator(path, query, header, formData, body)
  let scheme = call_568062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568062.url(scheme.get, call_568062.host, call_568062.base,
                         call_568062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568062, url, valid)

proc call*(call_568133: Call_SubscriptionsCancel_567863; apiVersion: string;
          subscriptionId: string): Recallable =
  ## subscriptionsCancel
  ## The operation to cancel a subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2019-03-01-preview
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  var path_568134 = newJObject()
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  add(path_568134, "subscriptionId", newJString(subscriptionId))
  result = call_568133.call(path_568134, query_568136, nil, nil, nil)

var subscriptionsCancel* = Call_SubscriptionsCancel_567863(
    name: "subscriptionsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscription/cancel",
    validator: validate_SubscriptionsCancel_567864, base: "",
    url: url_SubscriptionsCancel_567865, schemes: {Scheme.Https})
type
  Call_SubscriptionsEnable_568175 = ref object of OpenApiRestCall_567641
proc url_SubscriptionsEnable_568177(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Subscription/enable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsEnable_568176(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The operation to enable a subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568178 = path.getOrDefault("subscriptionId")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "subscriptionId", valid_568178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568179 = query.getOrDefault("api-version")
  valid_568179 = validateParameter(valid_568179, JString, required = true,
                                 default = nil)
  if valid_568179 != nil:
    section.add "api-version", valid_568179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568180: Call_SubscriptionsEnable_568175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to enable a subscription
  ## 
  let valid = call_568180.validator(path, query, header, formData, body)
  let scheme = call_568180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568180.url(scheme.get, call_568180.host, call_568180.base,
                         call_568180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568180, url, valid)

proc call*(call_568181: Call_SubscriptionsEnable_568175; apiVersion: string;
          subscriptionId: string): Recallable =
  ## subscriptionsEnable
  ## The operation to enable a subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2019-03-01-preview
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  var path_568182 = newJObject()
  var query_568183 = newJObject()
  add(query_568183, "api-version", newJString(apiVersion))
  add(path_568182, "subscriptionId", newJString(subscriptionId))
  result = call_568181.call(path_568182, query_568183, nil, nil, nil)

var subscriptionsEnable* = Call_SubscriptionsEnable_568175(
    name: "subscriptionsEnable", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscription/enable",
    validator: validate_SubscriptionsEnable_568176, base: "",
    url: url_SubscriptionsEnable_568177, schemes: {Scheme.Https})
type
  Call_SubscriptionsRename_568184 = ref object of OpenApiRestCall_567641
proc url_SubscriptionsRename_568186(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Subscription/rename")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsRename_568185(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The operation to rename a subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568187 = path.getOrDefault("subscriptionId")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "subscriptionId", valid_568187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2019-03-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568188 = query.getOrDefault("api-version")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "api-version", valid_568188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Subscription Name
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568190: Call_SubscriptionsRename_568184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to rename a subscription
  ## 
  let valid = call_568190.validator(path, query, header, formData, body)
  let scheme = call_568190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568190.url(scheme.get, call_568190.host, call_568190.base,
                         call_568190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568190, url, valid)

proc call*(call_568191: Call_SubscriptionsRename_568184; apiVersion: string;
          subscriptionId: string; body: JsonNode): Recallable =
  ## subscriptionsRename
  ## The operation to rename a subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2019-03-01-preview
  ##   subscriptionId: string (required)
  ##                 : Subscription Id.
  ##   body: JObject (required)
  ##       : Subscription Name
  var path_568192 = newJObject()
  var query_568193 = newJObject()
  var body_568194 = newJObject()
  add(query_568193, "api-version", newJString(apiVersion))
  add(path_568192, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_568194 = body
  result = call_568191.call(path_568192, query_568193, nil, nil, body_568194)

var subscriptionsRename* = Call_SubscriptionsRename_568184(
    name: "subscriptionsRename", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Subscription/rename",
    validator: validate_SubscriptionsRename_568185, base: "",
    url: url_SubscriptionsRename_568186, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
