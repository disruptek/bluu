
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SubscriptionClient
## version: 2018-11-01-preview
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
  macServiceName = "subscription-subscriptions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubscriptionFactoryCreateSubscription_567879 = ref object of OpenApiRestCall_567657
proc url_SubscriptionFactoryCreateSubscription_567881(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscription/createSubscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionFactoryCreateSubscription_567880(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a new Azure subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : The name of the Microsoft Customer Agreement billing account for which you want to create the subscription.
  ##   invoiceSectionName: JString (required)
  ##                     : The name of the invoice section in the billing account for which you want to create the subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_568071 = path.getOrDefault("billingAccountName")
  valid_568071 = validateParameter(valid_568071, JString, required = true,
                                 default = nil)
  if valid_568071 != nil:
    section.add "billingAccountName", valid_568071
  var valid_568072 = path.getOrDefault("invoiceSectionName")
  valid_568072 = validateParameter(valid_568072, JString, required = true,
                                 default = nil)
  if valid_568072 != nil:
    section.add "invoiceSectionName", valid_568072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2018-11-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568073 = query.getOrDefault("api-version")
  valid_568073 = validateParameter(valid_568073, JString, required = true,
                                 default = nil)
  if valid_568073 != nil:
    section.add "api-version", valid_568073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The subscription creation parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568097: Call_SubscriptionFactoryCreateSubscription_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a new Azure subscription
  ## 
  let valid = call_568097.validator(path, query, header, formData, body)
  let scheme = call_568097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568097.url(scheme.get, call_568097.host, call_568097.base,
                         call_568097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568097, url, valid)

proc call*(call_568168: Call_SubscriptionFactoryCreateSubscription_567879;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; body: JsonNode): Recallable =
  ## subscriptionFactoryCreateSubscription
  ## The operation to create a new Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2018-11-01-preview
  ##   billingAccountName: string (required)
  ##                     : The name of the Microsoft Customer Agreement billing account for which you want to create the subscription.
  ##   invoiceSectionName: string (required)
  ##                     : The name of the invoice section in the billing account for which you want to create the subscription.
  ##   body: JObject (required)
  ##       : The subscription creation parameters.
  var path_568169 = newJObject()
  var query_568171 = newJObject()
  var body_568172 = newJObject()
  add(query_568171, "api-version", newJString(apiVersion))
  add(path_568169, "billingAccountName", newJString(billingAccountName))
  add(path_568169, "invoiceSectionName", newJString(invoiceSectionName))
  if body != nil:
    body_568172 = body
  result = call_568168.call(path_568169, query_568171, nil, nil, body_568172)

var subscriptionFactoryCreateSubscription* = Call_SubscriptionFactoryCreateSubscription_567879(
    name: "subscriptionFactoryCreateSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Subscription/createSubscription",
    validator: validate_SubscriptionFactoryCreateSubscription_567880, base: "",
    url: url_SubscriptionFactoryCreateSubscription_567881, schemes: {Scheme.Https})
type
  Call_SubscriptionOperationGet_568211 = ref object of OpenApiRestCall_567657
proc url_SubscriptionOperationGet_568213(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.Subscription/subscriptionOperations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionOperationGet_568212(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the status of the pending Microsoft.Subscription API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_568214 = path.getOrDefault("operationId")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "operationId", valid_568214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2018-11-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568215 = query.getOrDefault("api-version")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "api-version", valid_568215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_SubscriptionOperationGet_568211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the status of the pending Microsoft.Subscription API operations.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_SubscriptionOperationGet_568211; apiVersion: string;
          operationId: string): Recallable =
  ## subscriptionOperationGet
  ## Get the status of the pending Microsoft.Subscription API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2018-11-01-preview
  ##   operationId: string (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  add(query_568219, "api-version", newJString(apiVersion))
  add(path_568218, "operationId", newJString(operationId))
  result = call_568217.call(path_568218, query_568219, nil, nil, nil)

var subscriptionOperationGet* = Call_SubscriptionOperationGet_568211(
    name: "subscriptionOperationGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Subscription/subscriptionOperations/{operationId}",
    validator: validate_SubscriptionOperationGet_568212, base: "",
    url: url_SubscriptionOperationGet_568213, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
