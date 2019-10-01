
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SubscriptionClient
## version: 2018-03-01-preview
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
  Call_SubscriptionFactoryCreateSubscriptionInEnrollmentAccount_567863 = ref object of OpenApiRestCall_567641
proc url_SubscriptionFactoryCreateSubscriptionInEnrollmentAccount_567865(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enrollmentAccountName" in path,
        "`enrollmentAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Subscription/createSubscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionFactoryCreateSubscriptionInEnrollmentAccount_567864(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates an Azure subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enrollmentAccountName: JString (required)
  ##                        : The name of the enrollment account to which the subscription will be billed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `enrollmentAccountName` field"
  var valid_568055 = path.getOrDefault("enrollmentAccountName")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "enrollmentAccountName", valid_568055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568056 = query.getOrDefault("api-version")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "api-version", valid_568056
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

proc call*(call_568080: Call_SubscriptionFactoryCreateSubscriptionInEnrollmentAccount_567863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Azure subscription
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_SubscriptionFactoryCreateSubscriptionInEnrollmentAccount_567863;
          apiVersion: string; body: JsonNode; enrollmentAccountName: string): Recallable =
  ## subscriptionFactoryCreateSubscriptionInEnrollmentAccount
  ## Creates an Azure subscription
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   body: JObject (required)
  ##       : The subscription creation parameters.
  ##   enrollmentAccountName: string (required)
  ##                        : The name of the enrollment account to which the subscription will be billed.
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  var body_568155 = newJObject()
  add(query_568154, "api-version", newJString(apiVersion))
  if body != nil:
    body_568155 = body
  add(path_568152, "enrollmentAccountName", newJString(enrollmentAccountName))
  result = call_568151.call(path_568152, query_568154, nil, nil, body_568155)

var subscriptionFactoryCreateSubscriptionInEnrollmentAccount* = Call_SubscriptionFactoryCreateSubscriptionInEnrollmentAccount_567863(
    name: "subscriptionFactoryCreateSubscriptionInEnrollmentAccount",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/enrollmentAccounts/{enrollmentAccountName}/providers/Microsoft.Subscription/createSubscription", validator: validate_SubscriptionFactoryCreateSubscriptionInEnrollmentAccount_567864,
    base: "", url: url_SubscriptionFactoryCreateSubscriptionInEnrollmentAccount_567865,
    schemes: {Scheme.Https})
type
  Call_SubscriptionOperationsList_568194 = ref object of OpenApiRestCall_567641
proc url_SubscriptionOperationsList_568196(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SubscriptionOperationsList_568195(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the available pending Microsoft.Subscription API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568197 = query.getOrDefault("api-version")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "api-version", valid_568197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568198: Call_SubscriptionOperationsList_568194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available pending Microsoft.Subscription API operations.
  ## 
  let valid = call_568198.validator(path, query, header, formData, body)
  let scheme = call_568198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568198.url(scheme.get, call_568198.host, call_568198.base,
                         call_568198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568198, url, valid)

proc call*(call_568199: Call_SubscriptionOperationsList_568194; apiVersion: string): Recallable =
  ## subscriptionOperationsList
  ## Lists all of the available pending Microsoft.Subscription API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  var query_568200 = newJObject()
  add(query_568200, "api-version", newJString(apiVersion))
  result = call_568199.call(nil, query_568200, nil, nil, nil)

var subscriptionOperationsList* = Call_SubscriptionOperationsList_568194(
    name: "subscriptionOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Subscription/subscriptionOperations",
    validator: validate_SubscriptionOperationsList_568195, base: "",
    url: url_SubscriptionOperationsList_568196, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
