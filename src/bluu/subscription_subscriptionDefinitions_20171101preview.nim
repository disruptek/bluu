
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SubscriptionDefinitionsClient
## version: 2017-11-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Subscription definitions client provides an interface to create, modify and retrieve azure subscriptions programmatically.
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
  macServiceName = "subscription-subscriptionDefinitions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubscriptionDefinitionsOperationMetadataList_593630 = ref object of OpenApiRestCall_593408
proc url_SubscriptionDefinitionsOperationMetadataList_593632(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SubscriptionDefinitionsOperationMetadataList_593631(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the available Microsoft.Subscription API operations.
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
  var valid_593791 = query.getOrDefault("api-version")
  valid_593791 = validateParameter(valid_593791, JString, required = true,
                                 default = nil)
  if valid_593791 != nil:
    section.add "api-version", valid_593791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593814: Call_SubscriptionDefinitionsOperationMetadataList_593630;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Subscription API operations.
  ## 
  let valid = call_593814.validator(path, query, header, formData, body)
  let scheme = call_593814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593814.url(scheme.get, call_593814.host, call_593814.base,
                         call_593814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593814, url, valid)

proc call*(call_593885: Call_SubscriptionDefinitionsOperationMetadataList_593630;
          apiVersion: string): Recallable =
  ## subscriptionDefinitionsOperationMetadataList
  ## Lists all of the available Microsoft.Subscription API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  var query_593886 = newJObject()
  add(query_593886, "api-version", newJString(apiVersion))
  result = call_593885.call(nil, query_593886, nil, nil, nil)

var subscriptionDefinitionsOperationMetadataList* = Call_SubscriptionDefinitionsOperationMetadataList_593630(
    name: "subscriptionDefinitionsOperationMetadataList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Subscription/operations",
    validator: validate_SubscriptionDefinitionsOperationMetadataList_593631,
    base: "", url: url_SubscriptionDefinitionsOperationMetadataList_593632,
    schemes: {Scheme.Https})
type
  Call_SubscriptionDefinitionsList_593926 = ref object of OpenApiRestCall_593408
proc url_SubscriptionDefinitionsList_593928(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SubscriptionDefinitionsList_593927(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List an Azure subscription definition by subscriptionId.
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
  var valid_593929 = query.getOrDefault("api-version")
  valid_593929 = validateParameter(valid_593929, JString, required = true,
                                 default = nil)
  if valid_593929 != nil:
    section.add "api-version", valid_593929
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593930: Call_SubscriptionDefinitionsList_593926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List an Azure subscription definition by subscriptionId.
  ## 
  let valid = call_593930.validator(path, query, header, formData, body)
  let scheme = call_593930.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593930.url(scheme.get, call_593930.host, call_593930.base,
                         call_593930.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593930, url, valid)

proc call*(call_593931: Call_SubscriptionDefinitionsList_593926; apiVersion: string): Recallable =
  ## subscriptionDefinitionsList
  ## List an Azure subscription definition by subscriptionId.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  var query_593932 = newJObject()
  add(query_593932, "api-version", newJString(apiVersion))
  result = call_593931.call(nil, query_593932, nil, nil, nil)

var subscriptionDefinitionsList* = Call_SubscriptionDefinitionsList_593926(
    name: "subscriptionDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Subscription/subscriptionDefinitions",
    validator: validate_SubscriptionDefinitionsList_593927, base: "",
    url: url_SubscriptionDefinitionsList_593928, schemes: {Scheme.Https})
type
  Call_SubscriptionDefinitionsCreate_593956 = ref object of OpenApiRestCall_593408
proc url_SubscriptionDefinitionsCreate_593958(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionDefinitionName" in path,
        "`subscriptionDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.Subscription/subscriptionDefinitions/"),
               (kind: VariableSegment, value: "subscriptionDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionDefinitionsCreate_593957(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create an Azure subscription definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionDefinitionName: JString (required)
  ##                             : The name of the Azure subscription definition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `subscriptionDefinitionName` field"
  var valid_593976 = path.getOrDefault("subscriptionDefinitionName")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "subscriptionDefinitionName", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "api-version", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The subscription definition creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593979: Call_SubscriptionDefinitionsCreate_593956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an Azure subscription definition.
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_SubscriptionDefinitionsCreate_593956;
          apiVersion: string; subscriptionDefinitionName: string; body: JsonNode): Recallable =
  ## subscriptionDefinitionsCreate
  ## Create an Azure subscription definition.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionDefinitionName: string (required)
  ##                             : The name of the Azure subscription definition.
  ##   body: JObject (required)
  ##       : The subscription definition creation.
  var path_593981 = newJObject()
  var query_593982 = newJObject()
  var body_593983 = newJObject()
  add(query_593982, "api-version", newJString(apiVersion))
  add(path_593981, "subscriptionDefinitionName",
      newJString(subscriptionDefinitionName))
  if body != nil:
    body_593983 = body
  result = call_593980.call(path_593981, query_593982, nil, nil, body_593983)

var subscriptionDefinitionsCreate* = Call_SubscriptionDefinitionsCreate_593956(
    name: "subscriptionDefinitionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Subscription/subscriptionDefinitions/{subscriptionDefinitionName}",
    validator: validate_SubscriptionDefinitionsCreate_593957, base: "",
    url: url_SubscriptionDefinitionsCreate_593958, schemes: {Scheme.Https})
type
  Call_SubscriptionDefinitionsGet_593933 = ref object of OpenApiRestCall_593408
proc url_SubscriptionDefinitionsGet_593935(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionDefinitionName" in path,
        "`subscriptionDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.Subscription/subscriptionDefinitions/"),
               (kind: VariableSegment, value: "subscriptionDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionDefinitionsGet_593934(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an Azure subscription definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionDefinitionName: JString (required)
  ##                             : The name of the Azure subscription definition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `subscriptionDefinitionName` field"
  var valid_593950 = path.getOrDefault("subscriptionDefinitionName")
  valid_593950 = validateParameter(valid_593950, JString, required = true,
                                 default = nil)
  if valid_593950 != nil:
    section.add "subscriptionDefinitionName", valid_593950
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593951 = query.getOrDefault("api-version")
  valid_593951 = validateParameter(valid_593951, JString, required = true,
                                 default = nil)
  if valid_593951 != nil:
    section.add "api-version", valid_593951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593952: Call_SubscriptionDefinitionsGet_593933; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an Azure subscription definition.
  ## 
  let valid = call_593952.validator(path, query, header, formData, body)
  let scheme = call_593952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593952.url(scheme.get, call_593952.host, call_593952.base,
                         call_593952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593952, url, valid)

proc call*(call_593953: Call_SubscriptionDefinitionsGet_593933; apiVersion: string;
          subscriptionDefinitionName: string): Recallable =
  ## subscriptionDefinitionsGet
  ## Get an Azure subscription definition.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionDefinitionName: string (required)
  ##                             : The name of the Azure subscription definition.
  var path_593954 = newJObject()
  var query_593955 = newJObject()
  add(query_593955, "api-version", newJString(apiVersion))
  add(path_593954, "subscriptionDefinitionName",
      newJString(subscriptionDefinitionName))
  result = call_593953.call(path_593954, query_593955, nil, nil, nil)

var subscriptionDefinitionsGet* = Call_SubscriptionDefinitionsGet_593933(
    name: "subscriptionDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Subscription/subscriptionDefinitions/{subscriptionDefinitionName}",
    validator: validate_SubscriptionDefinitionsGet_593934, base: "",
    url: url_SubscriptionDefinitionsGet_593935, schemes: {Scheme.Https})
type
  Call_SubscriptionDefinitionsGetOperationStatus_593984 = ref object of OpenApiRestCall_593408
proc url_SubscriptionDefinitionsGetOperationStatus_593986(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_SubscriptionDefinitionsGetOperationStatus_593985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the status of the subscription definition PUT operation. The URI of this API is returned in the Location field of the response header.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_593987 = path.getOrDefault("operationId")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "operationId", valid_593987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "api-version", valid_593988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_SubscriptionDefinitionsGetOperationStatus_593984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the status of the subscription definition PUT operation. The URI of this API is returned in the Location field of the response header.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_SubscriptionDefinitionsGetOperationStatus_593984;
          apiVersion: string; operationId: string): Recallable =
  ## subscriptionDefinitionsGetOperationStatus
  ## Retrieves the status of the subscription definition PUT operation. The URI of this API is returned in the Location field of the response header.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   operationId: string (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "operationId", newJString(operationId))
  result = call_593990.call(path_593991, query_593992, nil, nil, nil)

var subscriptionDefinitionsGetOperationStatus* = Call_SubscriptionDefinitionsGetOperationStatus_593984(
    name: "subscriptionDefinitionsGetOperationStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Subscription/subscriptionOperations/{operationId}",
    validator: validate_SubscriptionDefinitionsGetOperationStatus_593985,
    base: "", url: url_SubscriptionDefinitionsGetOperationStatus_593986,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
