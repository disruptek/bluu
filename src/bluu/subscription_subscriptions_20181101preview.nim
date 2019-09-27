
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "subscription-subscriptions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubscriptionFactoryCreateSubscription_593646 = ref object of OpenApiRestCall_593424
proc url_SubscriptionFactoryCreateSubscription_593648(protocol: Scheme;
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

proc validate_SubscriptionFactoryCreateSubscription_593647(path: JsonNode;
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
  var valid_593838 = path.getOrDefault("billingAccountName")
  valid_593838 = validateParameter(valid_593838, JString, required = true,
                                 default = nil)
  if valid_593838 != nil:
    section.add "billingAccountName", valid_593838
  var valid_593839 = path.getOrDefault("invoiceSectionName")
  valid_593839 = validateParameter(valid_593839, JString, required = true,
                                 default = nil)
  if valid_593839 != nil:
    section.add "invoiceSectionName", valid_593839
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2018-11-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593840 = query.getOrDefault("api-version")
  valid_593840 = validateParameter(valid_593840, JString, required = true,
                                 default = nil)
  if valid_593840 != nil:
    section.add "api-version", valid_593840
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

proc call*(call_593864: Call_SubscriptionFactoryCreateSubscription_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create a new Azure subscription
  ## 
  let valid = call_593864.validator(path, query, header, formData, body)
  let scheme = call_593864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593864.url(scheme.get, call_593864.host, call_593864.base,
                         call_593864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593864, url, valid)

proc call*(call_593935: Call_SubscriptionFactoryCreateSubscription_593646;
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
  var path_593936 = newJObject()
  var query_593938 = newJObject()
  var body_593939 = newJObject()
  add(query_593938, "api-version", newJString(apiVersion))
  add(path_593936, "billingAccountName", newJString(billingAccountName))
  add(path_593936, "invoiceSectionName", newJString(invoiceSectionName))
  if body != nil:
    body_593939 = body
  result = call_593935.call(path_593936, query_593938, nil, nil, body_593939)

var subscriptionFactoryCreateSubscription* = Call_SubscriptionFactoryCreateSubscription_593646(
    name: "subscriptionFactoryCreateSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Subscription/createSubscription",
    validator: validate_SubscriptionFactoryCreateSubscription_593647, base: "",
    url: url_SubscriptionFactoryCreateSubscription_593648, schemes: {Scheme.Https})
type
  Call_SubscriptionOperationGet_593978 = ref object of OpenApiRestCall_593424
proc url_SubscriptionOperationGet_593980(protocol: Scheme; host: string;
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

proc validate_SubscriptionOperationGet_593979(path: JsonNode; query: JsonNode;
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
  var valid_593981 = path.getOrDefault("operationId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "operationId", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2018-11-01-preview
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_SubscriptionOperationGet_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the status of the pending Microsoft.Subscription API operations.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_SubscriptionOperationGet_593978; apiVersion: string;
          operationId: string): Recallable =
  ## subscriptionOperationGet
  ## Get the status of the pending Microsoft.Subscription API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2018-11-01-preview
  ##   operationId: string (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  add(query_593986, "api-version", newJString(apiVersion))
  add(path_593985, "operationId", newJString(operationId))
  result = call_593984.call(path_593985, query_593986, nil, nil, nil)

var subscriptionOperationGet* = Call_SubscriptionOperationGet_593978(
    name: "subscriptionOperationGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Subscription/subscriptionOperations/{operationId}",
    validator: validate_SubscriptionOperationGet_593979, base: "",
    url: url_SubscriptionOperationGet_593980, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
