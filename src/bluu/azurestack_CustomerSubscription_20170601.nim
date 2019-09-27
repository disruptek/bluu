
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AzureStack Azure Bridge Client
## version: 2017-06-01
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
  macServiceName = "azurestack-CustomerSubscription"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CustomerSubscriptionsList_593630 = ref object of OpenApiRestCall_593408
proc url_CustomerSubscriptionsList_593632(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "registrationName" in path,
        "`registrationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureStack/registrations/"),
               (kind: VariableSegment, value: "registrationName"),
               (kind: ConstantSegment, value: "/customerSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomerSubscriptionsList_593631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of products.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationName: JString (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `registrationName` field"
  var valid_593792 = path.getOrDefault("registrationName")
  valid_593792 = validateParameter(valid_593792, JString, required = true,
                                 default = nil)
  if valid_593792 != nil:
    section.add "registrationName", valid_593792
  var valid_593793 = path.getOrDefault("subscriptionId")
  valid_593793 = validateParameter(valid_593793, JString, required = true,
                                 default = nil)
  if valid_593793 != nil:
    section.add "subscriptionId", valid_593793
  var valid_593794 = path.getOrDefault("resourceGroup")
  valid_593794 = validateParameter(valid_593794, JString, required = true,
                                 default = nil)
  if valid_593794 != nil:
    section.add "resourceGroup", valid_593794
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_593808 != nil:
    section.add "api-version", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593835: Call_CustomerSubscriptionsList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of products.
  ## 
  let valid = call_593835.validator(path, query, header, formData, body)
  let scheme = call_593835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593835.url(scheme.get, call_593835.host, call_593835.base,
                         call_593835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593835, url, valid)

proc call*(call_593906: Call_CustomerSubscriptionsList_593630;
          registrationName: string; subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2017-06-01"): Recallable =
  ## customerSubscriptionsList
  ## Returns a list of products.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   registrationName: string (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Name of the resource group.
  var path_593907 = newJObject()
  var query_593909 = newJObject()
  add(query_593909, "api-version", newJString(apiVersion))
  add(path_593907, "registrationName", newJString(registrationName))
  add(path_593907, "subscriptionId", newJString(subscriptionId))
  add(path_593907, "resourceGroup", newJString(resourceGroup))
  result = call_593906.call(path_593907, query_593909, nil, nil, nil)

var customerSubscriptionsList* = Call_CustomerSubscriptionsList_593630(
    name: "customerSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions",
    validator: validate_CustomerSubscriptionsList_593631, base: "",
    url: url_CustomerSubscriptionsList_593632, schemes: {Scheme.Https})
type
  Call_CustomerSubscriptionsCreate_593969 = ref object of OpenApiRestCall_593408
proc url_CustomerSubscriptionsCreate_593971(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "registrationName" in path,
        "`registrationName` is a required path parameter"
  assert "customerSubscriptionName" in path,
        "`customerSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureStack/registrations/"),
               (kind: VariableSegment, value: "registrationName"),
               (kind: ConstantSegment, value: "/customerSubscriptions/"),
               (kind: VariableSegment, value: "customerSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomerSubscriptionsCreate_593970(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new customer subscription under a registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationName: JString (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Name of the resource group.
  ##   customerSubscriptionName: JString (required)
  ##                           : Name of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `registrationName` field"
  var valid_593972 = path.getOrDefault("registrationName")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "registrationName", valid_593972
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  var valid_593974 = path.getOrDefault("resourceGroup")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "resourceGroup", valid_593974
  var valid_593975 = path.getOrDefault("customerSubscriptionName")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "customerSubscriptionName", valid_593975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customerCreationParameters: JObject (required)
  ##                             : Parameters use to create a customer subscription.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_CustomerSubscriptionsCreate_593969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new customer subscription under a registration.
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_CustomerSubscriptionsCreate_593969;
          registrationName: string; subscriptionId: string; resourceGroup: string;
          customerCreationParameters: JsonNode; customerSubscriptionName: string;
          apiVersion: string = "2017-06-01"): Recallable =
  ## customerSubscriptionsCreate
  ## Creates a new customer subscription under a registration.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   registrationName: string (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Name of the resource group.
  ##   customerCreationParameters: JObject (required)
  ##                             : Parameters use to create a customer subscription.
  ##   customerSubscriptionName: string (required)
  ##                           : Name of the product.
  var path_593980 = newJObject()
  var query_593981 = newJObject()
  var body_593982 = newJObject()
  add(query_593981, "api-version", newJString(apiVersion))
  add(path_593980, "registrationName", newJString(registrationName))
  add(path_593980, "subscriptionId", newJString(subscriptionId))
  add(path_593980, "resourceGroup", newJString(resourceGroup))
  if customerCreationParameters != nil:
    body_593982 = customerCreationParameters
  add(path_593980, "customerSubscriptionName",
      newJString(customerSubscriptionName))
  result = call_593979.call(path_593980, query_593981, nil, nil, body_593982)

var customerSubscriptionsCreate* = Call_CustomerSubscriptionsCreate_593969(
    name: "customerSubscriptionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions/{customerSubscriptionName}",
    validator: validate_CustomerSubscriptionsCreate_593970, base: "",
    url: url_CustomerSubscriptionsCreate_593971, schemes: {Scheme.Https})
type
  Call_CustomerSubscriptionsGet_593948 = ref object of OpenApiRestCall_593408
proc url_CustomerSubscriptionsGet_593950(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "registrationName" in path,
        "`registrationName` is a required path parameter"
  assert "customerSubscriptionName" in path,
        "`customerSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureStack/registrations/"),
               (kind: VariableSegment, value: "registrationName"),
               (kind: ConstantSegment, value: "/customerSubscriptions/"),
               (kind: VariableSegment, value: "customerSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomerSubscriptionsGet_593949(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationName: JString (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Name of the resource group.
  ##   customerSubscriptionName: JString (required)
  ##                           : Name of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `registrationName` field"
  var valid_593960 = path.getOrDefault("registrationName")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "registrationName", valid_593960
  var valid_593961 = path.getOrDefault("subscriptionId")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "subscriptionId", valid_593961
  var valid_593962 = path.getOrDefault("resourceGroup")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "resourceGroup", valid_593962
  var valid_593963 = path.getOrDefault("customerSubscriptionName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "customerSubscriptionName", valid_593963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593964 = query.getOrDefault("api-version")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_593964 != nil:
    section.add "api-version", valid_593964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593965: Call_CustomerSubscriptionsGet_593948; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified product.
  ## 
  let valid = call_593965.validator(path, query, header, formData, body)
  let scheme = call_593965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593965.url(scheme.get, call_593965.host, call_593965.base,
                         call_593965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593965, url, valid)

proc call*(call_593966: Call_CustomerSubscriptionsGet_593948;
          registrationName: string; subscriptionId: string; resourceGroup: string;
          customerSubscriptionName: string; apiVersion: string = "2017-06-01"): Recallable =
  ## customerSubscriptionsGet
  ## Returns the specified product.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   registrationName: string (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Name of the resource group.
  ##   customerSubscriptionName: string (required)
  ##                           : Name of the product.
  var path_593967 = newJObject()
  var query_593968 = newJObject()
  add(query_593968, "api-version", newJString(apiVersion))
  add(path_593967, "registrationName", newJString(registrationName))
  add(path_593967, "subscriptionId", newJString(subscriptionId))
  add(path_593967, "resourceGroup", newJString(resourceGroup))
  add(path_593967, "customerSubscriptionName",
      newJString(customerSubscriptionName))
  result = call_593966.call(path_593967, query_593968, nil, nil, nil)

var customerSubscriptionsGet* = Call_CustomerSubscriptionsGet_593948(
    name: "customerSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions/{customerSubscriptionName}",
    validator: validate_CustomerSubscriptionsGet_593949, base: "",
    url: url_CustomerSubscriptionsGet_593950, schemes: {Scheme.Https})
type
  Call_CustomerSubscriptionsDelete_593983 = ref object of OpenApiRestCall_593408
proc url_CustomerSubscriptionsDelete_593985(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "registrationName" in path,
        "`registrationName` is a required path parameter"
  assert "customerSubscriptionName" in path,
        "`customerSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureStack/registrations/"),
               (kind: VariableSegment, value: "registrationName"),
               (kind: ConstantSegment, value: "/customerSubscriptions/"),
               (kind: VariableSegment, value: "customerSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomerSubscriptionsDelete_593984(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a customer subscription under a registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationName: JString (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Name of the resource group.
  ##   customerSubscriptionName: JString (required)
  ##                           : Name of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `registrationName` field"
  var valid_593986 = path.getOrDefault("registrationName")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "registrationName", valid_593986
  var valid_593987 = path.getOrDefault("subscriptionId")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "subscriptionId", valid_593987
  var valid_593988 = path.getOrDefault("resourceGroup")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "resourceGroup", valid_593988
  var valid_593989 = path.getOrDefault("customerSubscriptionName")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "customerSubscriptionName", valid_593989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_CustomerSubscriptionsDelete_593983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a customer subscription under a registration.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_CustomerSubscriptionsDelete_593983;
          registrationName: string; subscriptionId: string; resourceGroup: string;
          customerSubscriptionName: string; apiVersion: string = "2017-06-01"): Recallable =
  ## customerSubscriptionsDelete
  ## Deletes a customer subscription under a registration.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   registrationName: string (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Name of the resource group.
  ##   customerSubscriptionName: string (required)
  ##                           : Name of the product.
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  add(query_593994, "api-version", newJString(apiVersion))
  add(path_593993, "registrationName", newJString(registrationName))
  add(path_593993, "subscriptionId", newJString(subscriptionId))
  add(path_593993, "resourceGroup", newJString(resourceGroup))
  add(path_593993, "customerSubscriptionName",
      newJString(customerSubscriptionName))
  result = call_593992.call(path_593993, query_593994, nil, nil, nil)

var customerSubscriptionsDelete* = Call_CustomerSubscriptionsDelete_593983(
    name: "customerSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions/{customerSubscriptionName}",
    validator: validate_CustomerSubscriptionsDelete_593984, base: "",
    url: url_CustomerSubscriptionsDelete_593985, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
