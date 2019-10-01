
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CognitiveServicesManagementClient
## version: 2017-04-18
## termsOfService: (not provided)
## license: (not provided)
## 
## Cognitive Services Management Client
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

  OpenApiRestCall_569458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_569458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_569458): Option[Scheme] {.used.} =
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
  macServiceName = "cognitiveservices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_569680 = ref object of OpenApiRestCall_569458
proc url_OperationsList_569682(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_569681(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the available Cognitive Services account operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569841 = query.getOrDefault("api-version")
  valid_569841 = validateParameter(valid_569841, JString, required = true,
                                 default = nil)
  if valid_569841 != nil:
    section.add "api-version", valid_569841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569864: Call_OperationsList_569680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available Cognitive Services account operations.
  ## 
  let valid = call_569864.validator(path, query, header, formData, body)
  let scheme = call_569864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569864.url(scheme.get, call_569864.host, call_569864.base,
                         call_569864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569864, url, valid)

proc call*(call_569935: Call_OperationsList_569680; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all the available Cognitive Services account operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  var query_569936 = newJObject()
  add(query_569936, "api-version", newJString(apiVersion))
  result = call_569935.call(nil, query_569936, nil, nil, nil)

var operationsList* = Call_OperationsList_569680(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CognitiveServices/operations",
    validator: validate_OperationsList_569681, base: "", url: url_OperationsList_569682,
    schemes: {Scheme.Https})
type
  Call_AccountsList_569976 = ref object of OpenApiRestCall_569458
proc url_AccountsList_569978(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CognitiveServices/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsList_569977(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all the resources of a particular type belonging to a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_569993 = path.getOrDefault("subscriptionId")
  valid_569993 = validateParameter(valid_569993, JString, required = true,
                                 default = nil)
  if valid_569993 != nil:
    section.add "subscriptionId", valid_569993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569994 = query.getOrDefault("api-version")
  valid_569994 = validateParameter(valid_569994, JString, required = true,
                                 default = nil)
  if valid_569994 != nil:
    section.add "api-version", valid_569994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569995: Call_AccountsList_569976; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a subscription.
  ## 
  let valid = call_569995.validator(path, query, header, formData, body)
  let scheme = call_569995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569995.url(scheme.get, call_569995.host, call_569995.base,
                         call_569995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569995, url, valid)

proc call*(call_569996: Call_AccountsList_569976; apiVersion: string;
          subscriptionId: string): Recallable =
  ## accountsList
  ## Returns all the resources of a particular type belonging to a subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_569997 = newJObject()
  var query_569998 = newJObject()
  add(query_569998, "api-version", newJString(apiVersion))
  add(path_569997, "subscriptionId", newJString(subscriptionId))
  result = call_569996.call(path_569997, query_569998, nil, nil, nil)

var accountsList* = Call_AccountsList_569976(name: "accountsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CognitiveServices/accounts",
    validator: validate_AccountsList_569977, base: "", url: url_AccountsList_569978,
    schemes: {Scheme.Https})
type
  Call_CheckDomainAvailability_569999 = ref object of OpenApiRestCall_569458
proc url_CheckDomainAvailability_570001(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CognitiveServices/checkDomainAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckDomainAvailability_570000(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check whether a domain is available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_570019 = path.getOrDefault("subscriptionId")
  valid_570019 = validateParameter(valid_570019, JString, required = true,
                                 default = nil)
  if valid_570019 != nil:
    section.add "subscriptionId", valid_570019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570020 = query.getOrDefault("api-version")
  valid_570020 = validateParameter(valid_570020, JString, required = true,
                                 default = nil)
  if valid_570020 != nil:
    section.add "api-version", valid_570020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Check Domain Availability parameter.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_570022: Call_CheckDomainAvailability_569999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check whether a domain is available.
  ## 
  let valid = call_570022.validator(path, query, header, formData, body)
  let scheme = call_570022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570022.url(scheme.get, call_570022.host, call_570022.base,
                         call_570022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570022, url, valid)

proc call*(call_570023: Call_CheckDomainAvailability_569999; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## checkDomainAvailability
  ## Check whether a domain is available.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Check Domain Availability parameter.
  var path_570024 = newJObject()
  var query_570025 = newJObject()
  var body_570026 = newJObject()
  add(query_570025, "api-version", newJString(apiVersion))
  add(path_570024, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_570026 = parameters
  result = call_570023.call(path_570024, query_570025, nil, nil, body_570026)

var checkDomainAvailability* = Call_CheckDomainAvailability_569999(
    name: "checkDomainAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CognitiveServices/checkDomainAvailability",
    validator: validate_CheckDomainAvailability_570000, base: "",
    url: url_CheckDomainAvailability_570001, schemes: {Scheme.Https})
type
  Call_CheckSkuAvailabilityList_570027 = ref object of OpenApiRestCall_569458
proc url_CheckSkuAvailabilityList_570029(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CognitiveServices/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkSkuAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckSkuAvailabilityList_570028(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check available SKUs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   location: JString (required)
  ##           : Resource location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_570030 = path.getOrDefault("subscriptionId")
  valid_570030 = validateParameter(valid_570030, JString, required = true,
                                 default = nil)
  if valid_570030 != nil:
    section.add "subscriptionId", valid_570030
  var valid_570031 = path.getOrDefault("location")
  valid_570031 = validateParameter(valid_570031, JString, required = true,
                                 default = nil)
  if valid_570031 != nil:
    section.add "location", valid_570031
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570032 = query.getOrDefault("api-version")
  valid_570032 = validateParameter(valid_570032, JString, required = true,
                                 default = nil)
  if valid_570032 != nil:
    section.add "api-version", valid_570032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Check SKU Availability POST body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_570034: Call_CheckSkuAvailabilityList_570027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check available SKUs.
  ## 
  let valid = call_570034.validator(path, query, header, formData, body)
  let scheme = call_570034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570034.url(scheme.get, call_570034.host, call_570034.base,
                         call_570034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570034, url, valid)

proc call*(call_570035: Call_CheckSkuAvailabilityList_570027; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; location: string): Recallable =
  ## checkSkuAvailabilityList
  ## Check available SKUs.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : Check SKU Availability POST body.
  ##   location: string (required)
  ##           : Resource location.
  var path_570036 = newJObject()
  var query_570037 = newJObject()
  var body_570038 = newJObject()
  add(query_570037, "api-version", newJString(apiVersion))
  add(path_570036, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_570038 = parameters
  add(path_570036, "location", newJString(location))
  result = call_570035.call(path_570036, query_570037, nil, nil, body_570038)

var checkSkuAvailabilityList* = Call_CheckSkuAvailabilityList_570027(
    name: "checkSkuAvailabilityList", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CognitiveServices/locations/{location}/checkSkuAvailability",
    validator: validate_CheckSkuAvailabilityList_570028, base: "",
    url: url_CheckSkuAvailabilityList_570029, schemes: {Scheme.Https})
type
  Call_ResourceSkusList_570039 = ref object of OpenApiRestCall_569458
proc url_ResourceSkusList_570041(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CognitiveServices/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceSkusList_570040(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the list of Microsoft.CognitiveServices SKUs available for your Subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_570042 = path.getOrDefault("subscriptionId")
  valid_570042 = validateParameter(valid_570042, JString, required = true,
                                 default = nil)
  if valid_570042 != nil:
    section.add "subscriptionId", valid_570042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570043 = query.getOrDefault("api-version")
  valid_570043 = validateParameter(valid_570043, JString, required = true,
                                 default = nil)
  if valid_570043 != nil:
    section.add "api-version", valid_570043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_570044: Call_ResourceSkusList_570039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Microsoft.CognitiveServices SKUs available for your Subscription.
  ## 
  let valid = call_570044.validator(path, query, header, formData, body)
  let scheme = call_570044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570044.url(scheme.get, call_570044.host, call_570044.base,
                         call_570044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570044, url, valid)

proc call*(call_570045: Call_ResourceSkusList_570039; apiVersion: string;
          subscriptionId: string): Recallable =
  ## resourceSkusList
  ## Gets the list of Microsoft.CognitiveServices SKUs available for your Subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_570046 = newJObject()
  var query_570047 = newJObject()
  add(query_570047, "api-version", newJString(apiVersion))
  add(path_570046, "subscriptionId", newJString(subscriptionId))
  result = call_570045.call(path_570046, query_570047, nil, nil, nil)

var resourceSkusList* = Call_ResourceSkusList_570039(name: "resourceSkusList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CognitiveServices/skus",
    validator: validate_ResourceSkusList_570040, base: "",
    url: url_ResourceSkusList_570041, schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_570048 = ref object of OpenApiRestCall_569458
proc url_AccountsListByResourceGroup_570050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CognitiveServices/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListByResourceGroup_570049(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all the resources of a particular type belonging to a resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_570051 = path.getOrDefault("resourceGroupName")
  valid_570051 = validateParameter(valid_570051, JString, required = true,
                                 default = nil)
  if valid_570051 != nil:
    section.add "resourceGroupName", valid_570051
  var valid_570052 = path.getOrDefault("subscriptionId")
  valid_570052 = validateParameter(valid_570052, JString, required = true,
                                 default = nil)
  if valid_570052 != nil:
    section.add "subscriptionId", valid_570052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570053 = query.getOrDefault("api-version")
  valid_570053 = validateParameter(valid_570053, JString, required = true,
                                 default = nil)
  if valid_570053 != nil:
    section.add "api-version", valid_570053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_570054: Call_AccountsListByResourceGroup_570048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all the resources of a particular type belonging to a resource group
  ## 
  let valid = call_570054.validator(path, query, header, formData, body)
  let scheme = call_570054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570054.url(scheme.get, call_570054.host, call_570054.base,
                         call_570054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570054, url, valid)

proc call*(call_570055: Call_AccountsListByResourceGroup_570048;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## accountsListByResourceGroup
  ## Returns all the resources of a particular type belonging to a resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_570056 = newJObject()
  var query_570057 = newJObject()
  add(path_570056, "resourceGroupName", newJString(resourceGroupName))
  add(query_570057, "api-version", newJString(apiVersion))
  add(path_570056, "subscriptionId", newJString(subscriptionId))
  result = call_570055.call(path_570056, query_570057, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_570048(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts",
    validator: validate_AccountsListByResourceGroup_570049, base: "",
    url: url_AccountsListByResourceGroup_570050, schemes: {Scheme.Https})
type
  Call_AccountsCreate_570069 = ref object of OpenApiRestCall_569458
proc url_AccountsCreate_570071(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsCreate_570070(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create Cognitive Services Account. Accounts is a resource group wide resource type. It holds the keys for developer to access intelligent APIs. It's also the resource type for billing.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of Cognitive Services account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_570072 = path.getOrDefault("resourceGroupName")
  valid_570072 = validateParameter(valid_570072, JString, required = true,
                                 default = nil)
  if valid_570072 != nil:
    section.add "resourceGroupName", valid_570072
  var valid_570073 = path.getOrDefault("subscriptionId")
  valid_570073 = validateParameter(valid_570073, JString, required = true,
                                 default = nil)
  if valid_570073 != nil:
    section.add "subscriptionId", valid_570073
  var valid_570074 = path.getOrDefault("accountName")
  valid_570074 = validateParameter(valid_570074, JString, required = true,
                                 default = nil)
  if valid_570074 != nil:
    section.add "accountName", valid_570074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570075 = query.getOrDefault("api-version")
  valid_570075 = validateParameter(valid_570075, JString, required = true,
                                 default = nil)
  if valid_570075 != nil:
    section.add "api-version", valid_570075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_570077: Call_AccountsCreate_570069; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create Cognitive Services Account. Accounts is a resource group wide resource type. It holds the keys for developer to access intelligent APIs. It's also the resource type for billing.
  ## 
  let valid = call_570077.validator(path, query, header, formData, body)
  let scheme = call_570077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570077.url(scheme.get, call_570077.host, call_570077.base,
                         call_570077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570077, url, valid)

proc call*(call_570078: Call_AccountsCreate_570069; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## accountsCreate
  ## Create Cognitive Services Account. Accounts is a resource group wide resource type. It holds the keys for developer to access intelligent APIs. It's also the resource type for billing.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created account.
  ##   accountName: string (required)
  ##              : The name of Cognitive Services account.
  var path_570079 = newJObject()
  var query_570080 = newJObject()
  var body_570081 = newJObject()
  add(path_570079, "resourceGroupName", newJString(resourceGroupName))
  add(query_570080, "api-version", newJString(apiVersion))
  add(path_570079, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_570081 = parameters
  add(path_570079, "accountName", newJString(accountName))
  result = call_570078.call(path_570079, query_570080, nil, nil, body_570081)

var accountsCreate* = Call_AccountsCreate_570069(name: "accountsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}",
    validator: validate_AccountsCreate_570070, base: "", url: url_AccountsCreate_570071,
    schemes: {Scheme.Https})
type
  Call_AccountsGetProperties_570058 = ref object of OpenApiRestCall_569458
proc url_AccountsGetProperties_570060(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsGetProperties_570059(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a Cognitive Services account specified by the parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of Cognitive Services account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_570061 = path.getOrDefault("resourceGroupName")
  valid_570061 = validateParameter(valid_570061, JString, required = true,
                                 default = nil)
  if valid_570061 != nil:
    section.add "resourceGroupName", valid_570061
  var valid_570062 = path.getOrDefault("subscriptionId")
  valid_570062 = validateParameter(valid_570062, JString, required = true,
                                 default = nil)
  if valid_570062 != nil:
    section.add "subscriptionId", valid_570062
  var valid_570063 = path.getOrDefault("accountName")
  valid_570063 = validateParameter(valid_570063, JString, required = true,
                                 default = nil)
  if valid_570063 != nil:
    section.add "accountName", valid_570063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570064 = query.getOrDefault("api-version")
  valid_570064 = validateParameter(valid_570064, JString, required = true,
                                 default = nil)
  if valid_570064 != nil:
    section.add "api-version", valid_570064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_570065: Call_AccountsGetProperties_570058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a Cognitive Services account specified by the parameters.
  ## 
  let valid = call_570065.validator(path, query, header, formData, body)
  let scheme = call_570065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570065.url(scheme.get, call_570065.host, call_570065.base,
                         call_570065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570065, url, valid)

proc call*(call_570066: Call_AccountsGetProperties_570058;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## accountsGetProperties
  ## Returns a Cognitive Services account specified by the parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   accountName: string (required)
  ##              : The name of Cognitive Services account.
  var path_570067 = newJObject()
  var query_570068 = newJObject()
  add(path_570067, "resourceGroupName", newJString(resourceGroupName))
  add(query_570068, "api-version", newJString(apiVersion))
  add(path_570067, "subscriptionId", newJString(subscriptionId))
  add(path_570067, "accountName", newJString(accountName))
  result = call_570066.call(path_570067, query_570068, nil, nil, nil)

var accountsGetProperties* = Call_AccountsGetProperties_570058(
    name: "accountsGetProperties", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}",
    validator: validate_AccountsGetProperties_570059, base: "",
    url: url_AccountsGetProperties_570060, schemes: {Scheme.Https})
type
  Call_AccountsUpdate_570093 = ref object of OpenApiRestCall_569458
proc url_AccountsUpdate_570095(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsUpdate_570094(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates a Cognitive Services account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of Cognitive Services account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_570096 = path.getOrDefault("resourceGroupName")
  valid_570096 = validateParameter(valid_570096, JString, required = true,
                                 default = nil)
  if valid_570096 != nil:
    section.add "resourceGroupName", valid_570096
  var valid_570097 = path.getOrDefault("subscriptionId")
  valid_570097 = validateParameter(valid_570097, JString, required = true,
                                 default = nil)
  if valid_570097 != nil:
    section.add "subscriptionId", valid_570097
  var valid_570098 = path.getOrDefault("accountName")
  valid_570098 = validateParameter(valid_570098, JString, required = true,
                                 default = nil)
  if valid_570098 != nil:
    section.add "accountName", valid_570098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570099 = query.getOrDefault("api-version")
  valid_570099 = validateParameter(valid_570099, JString, required = true,
                                 default = nil)
  if valid_570099 != nil:
    section.add "api-version", valid_570099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_570101: Call_AccountsUpdate_570093; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Cognitive Services account
  ## 
  let valid = call_570101.validator(path, query, header, formData, body)
  let scheme = call_570101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570101.url(scheme.get, call_570101.host, call_570101.base,
                         call_570101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570101, url, valid)

proc call*(call_570102: Call_AccountsUpdate_570093; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## accountsUpdate
  ## Updates a Cognitive Services account
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created account.
  ##   accountName: string (required)
  ##              : The name of Cognitive Services account.
  var path_570103 = newJObject()
  var query_570104 = newJObject()
  var body_570105 = newJObject()
  add(path_570103, "resourceGroupName", newJString(resourceGroupName))
  add(query_570104, "api-version", newJString(apiVersion))
  add(path_570103, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_570105 = parameters
  add(path_570103, "accountName", newJString(accountName))
  result = call_570102.call(path_570103, query_570104, nil, nil, body_570105)

var accountsUpdate* = Call_AccountsUpdate_570093(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}",
    validator: validate_AccountsUpdate_570094, base: "", url: url_AccountsUpdate_570095,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_570082 = ref object of OpenApiRestCall_569458
proc url_AccountsDelete_570084(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsDelete_570083(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a Cognitive Services account from the resource group. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of Cognitive Services account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_570085 = path.getOrDefault("resourceGroupName")
  valid_570085 = validateParameter(valid_570085, JString, required = true,
                                 default = nil)
  if valid_570085 != nil:
    section.add "resourceGroupName", valid_570085
  var valid_570086 = path.getOrDefault("subscriptionId")
  valid_570086 = validateParameter(valid_570086, JString, required = true,
                                 default = nil)
  if valid_570086 != nil:
    section.add "subscriptionId", valid_570086
  var valid_570087 = path.getOrDefault("accountName")
  valid_570087 = validateParameter(valid_570087, JString, required = true,
                                 default = nil)
  if valid_570087 != nil:
    section.add "accountName", valid_570087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570088 = query.getOrDefault("api-version")
  valid_570088 = validateParameter(valid_570088, JString, required = true,
                                 default = nil)
  if valid_570088 != nil:
    section.add "api-version", valid_570088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_570089: Call_AccountsDelete_570082; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Cognitive Services account from the resource group. 
  ## 
  let valid = call_570089.validator(path, query, header, formData, body)
  let scheme = call_570089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570089.url(scheme.get, call_570089.host, call_570089.base,
                         call_570089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570089, url, valid)

proc call*(call_570090: Call_AccountsDelete_570082; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsDelete
  ## Deletes a Cognitive Services account from the resource group. 
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   accountName: string (required)
  ##              : The name of Cognitive Services account.
  var path_570091 = newJObject()
  var query_570092 = newJObject()
  add(path_570091, "resourceGroupName", newJString(resourceGroupName))
  add(query_570092, "api-version", newJString(apiVersion))
  add(path_570091, "subscriptionId", newJString(subscriptionId))
  add(path_570091, "accountName", newJString(accountName))
  result = call_570090.call(path_570091, query_570092, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_570082(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}",
    validator: validate_AccountsDelete_570083, base: "", url: url_AccountsDelete_570084,
    schemes: {Scheme.Https})
type
  Call_AccountsListKeys_570106 = ref object of OpenApiRestCall_569458
proc url_AccountsListKeys_570108(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListKeys_570107(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists the account keys for the specified Cognitive Services account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of Cognitive Services account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_570109 = path.getOrDefault("resourceGroupName")
  valid_570109 = validateParameter(valid_570109, JString, required = true,
                                 default = nil)
  if valid_570109 != nil:
    section.add "resourceGroupName", valid_570109
  var valid_570110 = path.getOrDefault("subscriptionId")
  valid_570110 = validateParameter(valid_570110, JString, required = true,
                                 default = nil)
  if valid_570110 != nil:
    section.add "subscriptionId", valid_570110
  var valid_570111 = path.getOrDefault("accountName")
  valid_570111 = validateParameter(valid_570111, JString, required = true,
                                 default = nil)
  if valid_570111 != nil:
    section.add "accountName", valid_570111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570112 = query.getOrDefault("api-version")
  valid_570112 = validateParameter(valid_570112, JString, required = true,
                                 default = nil)
  if valid_570112 != nil:
    section.add "api-version", valid_570112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_570113: Call_AccountsListKeys_570106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the account keys for the specified Cognitive Services account.
  ## 
  let valid = call_570113.validator(path, query, header, formData, body)
  let scheme = call_570113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570113.url(scheme.get, call_570113.host, call_570113.base,
                         call_570113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570113, url, valid)

proc call*(call_570114: Call_AccountsListKeys_570106; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsListKeys
  ## Lists the account keys for the specified Cognitive Services account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   accountName: string (required)
  ##              : The name of Cognitive Services account.
  var path_570115 = newJObject()
  var query_570116 = newJObject()
  add(path_570115, "resourceGroupName", newJString(resourceGroupName))
  add(query_570116, "api-version", newJString(apiVersion))
  add(path_570115, "subscriptionId", newJString(subscriptionId))
  add(path_570115, "accountName", newJString(accountName))
  result = call_570114.call(path_570115, query_570116, nil, nil, nil)

var accountsListKeys* = Call_AccountsListKeys_570106(name: "accountsListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}/listKeys",
    validator: validate_AccountsListKeys_570107, base: "",
    url: url_AccountsListKeys_570108, schemes: {Scheme.Https})
type
  Call_AccountsRegenerateKey_570117 = ref object of OpenApiRestCall_569458
proc url_AccountsRegenerateKey_570119(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/regenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsRegenerateKey_570118(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the specified account key for the specified Cognitive Services account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of Cognitive Services account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_570120 = path.getOrDefault("resourceGroupName")
  valid_570120 = validateParameter(valid_570120, JString, required = true,
                                 default = nil)
  if valid_570120 != nil:
    section.add "resourceGroupName", valid_570120
  var valid_570121 = path.getOrDefault("subscriptionId")
  valid_570121 = validateParameter(valid_570121, JString, required = true,
                                 default = nil)
  if valid_570121 != nil:
    section.add "subscriptionId", valid_570121
  var valid_570122 = path.getOrDefault("accountName")
  valid_570122 = validateParameter(valid_570122, JString, required = true,
                                 default = nil)
  if valid_570122 != nil:
    section.add "accountName", valid_570122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570123 = query.getOrDefault("api-version")
  valid_570123 = validateParameter(valid_570123, JString, required = true,
                                 default = nil)
  if valid_570123 != nil:
    section.add "api-version", valid_570123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : regenerate key parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_570125: Call_AccountsRegenerateKey_570117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the specified account key for the specified Cognitive Services account.
  ## 
  let valid = call_570125.validator(path, query, header, formData, body)
  let scheme = call_570125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570125.url(scheme.get, call_570125.host, call_570125.base,
                         call_570125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570125, url, valid)

proc call*(call_570126: Call_AccountsRegenerateKey_570117;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## accountsRegenerateKey
  ## Regenerates the specified account key for the specified Cognitive Services account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   parameters: JObject (required)
  ##             : regenerate key parameters.
  ##   accountName: string (required)
  ##              : The name of Cognitive Services account.
  var path_570127 = newJObject()
  var query_570128 = newJObject()
  var body_570129 = newJObject()
  add(path_570127, "resourceGroupName", newJString(resourceGroupName))
  add(query_570128, "api-version", newJString(apiVersion))
  add(path_570127, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_570129 = parameters
  add(path_570127, "accountName", newJString(accountName))
  result = call_570126.call(path_570127, query_570128, nil, nil, body_570129)

var accountsRegenerateKey* = Call_AccountsRegenerateKey_570117(
    name: "accountsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}/regenerateKey",
    validator: validate_AccountsRegenerateKey_570118, base: "",
    url: url_AccountsRegenerateKey_570119, schemes: {Scheme.Https})
type
  Call_AccountsListSkus_570130 = ref object of OpenApiRestCall_569458
proc url_AccountsListSkus_570132(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListSkus_570131(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List available SKUs for the requested Cognitive Services account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of Cognitive Services account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_570133 = path.getOrDefault("resourceGroupName")
  valid_570133 = validateParameter(valid_570133, JString, required = true,
                                 default = nil)
  if valid_570133 != nil:
    section.add "resourceGroupName", valid_570133
  var valid_570134 = path.getOrDefault("subscriptionId")
  valid_570134 = validateParameter(valid_570134, JString, required = true,
                                 default = nil)
  if valid_570134 != nil:
    section.add "subscriptionId", valid_570134
  var valid_570135 = path.getOrDefault("accountName")
  valid_570135 = validateParameter(valid_570135, JString, required = true,
                                 default = nil)
  if valid_570135 != nil:
    section.add "accountName", valid_570135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570136 = query.getOrDefault("api-version")
  valid_570136 = validateParameter(valid_570136, JString, required = true,
                                 default = nil)
  if valid_570136 != nil:
    section.add "api-version", valid_570136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_570137: Call_AccountsListSkus_570130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List available SKUs for the requested Cognitive Services account
  ## 
  let valid = call_570137.validator(path, query, header, formData, body)
  let scheme = call_570137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570137.url(scheme.get, call_570137.host, call_570137.base,
                         call_570137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570137, url, valid)

proc call*(call_570138: Call_AccountsListSkus_570130; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsListSkus
  ## List available SKUs for the requested Cognitive Services account
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   accountName: string (required)
  ##              : The name of Cognitive Services account.
  var path_570139 = newJObject()
  var query_570140 = newJObject()
  add(path_570139, "resourceGroupName", newJString(resourceGroupName))
  add(query_570140, "api-version", newJString(apiVersion))
  add(path_570139, "subscriptionId", newJString(subscriptionId))
  add(path_570139, "accountName", newJString(accountName))
  result = call_570138.call(path_570139, query_570140, nil, nil, nil)

var accountsListSkus* = Call_AccountsListSkus_570130(name: "accountsListSkus",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}/skus",
    validator: validate_AccountsListSkus_570131, base: "",
    url: url_AccountsListSkus_570132, schemes: {Scheme.Https})
type
  Call_AccountsGetUsages_570141 = ref object of OpenApiRestCall_569458
proc url_AccountsGetUsages_570143(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CognitiveServices/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsGetUsages_570142(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get usages for the requested Cognitive Services account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   accountName: JString (required)
  ##              : The name of Cognitive Services account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_570145 = path.getOrDefault("resourceGroupName")
  valid_570145 = validateParameter(valid_570145, JString, required = true,
                                 default = nil)
  if valid_570145 != nil:
    section.add "resourceGroupName", valid_570145
  var valid_570146 = path.getOrDefault("subscriptionId")
  valid_570146 = validateParameter(valid_570146, JString, required = true,
                                 default = nil)
  if valid_570146 != nil:
    section.add "subscriptionId", valid_570146
  var valid_570147 = path.getOrDefault("accountName")
  valid_570147 = validateParameter(valid_570147, JString, required = true,
                                 default = nil)
  if valid_570147 != nil:
    section.add "accountName", valid_570147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   $filter: JString
  ##          : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_570148 = query.getOrDefault("api-version")
  valid_570148 = validateParameter(valid_570148, JString, required = true,
                                 default = nil)
  if valid_570148 != nil:
    section.add "api-version", valid_570148
  var valid_570149 = query.getOrDefault("$filter")
  valid_570149 = validateParameter(valid_570149, JString, required = false,
                                 default = nil)
  if valid_570149 != nil:
    section.add "$filter", valid_570149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_570150: Call_AccountsGetUsages_570141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get usages for the requested Cognitive Services account
  ## 
  let valid = call_570150.validator(path, query, header, formData, body)
  let scheme = call_570150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_570150.url(scheme.get, call_570150.host, call_570150.base,
                         call_570150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_570150, url, valid)

proc call*(call_570151: Call_AccountsGetUsages_570141; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string;
          Filter: string = ""): Recallable =
  ## accountsGetUsages
  ## Get usages for the requested Cognitive Services account
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-18
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   accountName: string (required)
  ##              : The name of Cognitive Services account.
  ##   Filter: string
  ##         : An OData filter expression that describes a subset of usages to return. The supported parameter is name.value (name of the metric, can have an or of multiple names).
  var path_570152 = newJObject()
  var query_570153 = newJObject()
  add(path_570152, "resourceGroupName", newJString(resourceGroupName))
  add(query_570153, "api-version", newJString(apiVersion))
  add(path_570152, "subscriptionId", newJString(subscriptionId))
  add(path_570152, "accountName", newJString(accountName))
  add(query_570153, "$filter", newJString(Filter))
  result = call_570151.call(path_570152, query_570153, nil, nil, nil)

var accountsGetUsages* = Call_AccountsGetUsages_570141(name: "accountsGetUsages",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CognitiveServices/accounts/{accountName}/usages",
    validator: validate_AccountsGetUsages_570142, base: "",
    url: url_AccountsGetUsages_570143, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
