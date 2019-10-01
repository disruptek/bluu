
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_574441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574441): Option[Scheme] {.used.} =
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
  macServiceName = "azurestack-CustomerSubscription"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CustomerSubscriptionsList_574663 = ref object of OpenApiRestCall_574441
proc url_CustomerSubscriptionsList_574665(protocol: Scheme; host: string;
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

proc validate_CustomerSubscriptionsList_574664(path: JsonNode; query: JsonNode;
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
  var valid_574825 = path.getOrDefault("registrationName")
  valid_574825 = validateParameter(valid_574825, JString, required = true,
                                 default = nil)
  if valid_574825 != nil:
    section.add "registrationName", valid_574825
  var valid_574826 = path.getOrDefault("subscriptionId")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "subscriptionId", valid_574826
  var valid_574827 = path.getOrDefault("resourceGroup")
  valid_574827 = validateParameter(valid_574827, JString, required = true,
                                 default = nil)
  if valid_574827 != nil:
    section.add "resourceGroup", valid_574827
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574841 = query.getOrDefault("api-version")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_574841 != nil:
    section.add "api-version", valid_574841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574868: Call_CustomerSubscriptionsList_574663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of products.
  ## 
  let valid = call_574868.validator(path, query, header, formData, body)
  let scheme = call_574868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574868.url(scheme.get, call_574868.host, call_574868.base,
                         call_574868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574868, url, valid)

proc call*(call_574939: Call_CustomerSubscriptionsList_574663;
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
  var path_574940 = newJObject()
  var query_574942 = newJObject()
  add(query_574942, "api-version", newJString(apiVersion))
  add(path_574940, "registrationName", newJString(registrationName))
  add(path_574940, "subscriptionId", newJString(subscriptionId))
  add(path_574940, "resourceGroup", newJString(resourceGroup))
  result = call_574939.call(path_574940, query_574942, nil, nil, nil)

var customerSubscriptionsList* = Call_CustomerSubscriptionsList_574663(
    name: "customerSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions",
    validator: validate_CustomerSubscriptionsList_574664, base: "",
    url: url_CustomerSubscriptionsList_574665, schemes: {Scheme.Https})
type
  Call_CustomerSubscriptionsCreate_575002 = ref object of OpenApiRestCall_574441
proc url_CustomerSubscriptionsCreate_575004(protocol: Scheme; host: string;
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

proc validate_CustomerSubscriptionsCreate_575003(path: JsonNode; query: JsonNode;
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
  var valid_575005 = path.getOrDefault("registrationName")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "registrationName", valid_575005
  var valid_575006 = path.getOrDefault("subscriptionId")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "subscriptionId", valid_575006
  var valid_575007 = path.getOrDefault("resourceGroup")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "resourceGroup", valid_575007
  var valid_575008 = path.getOrDefault("customerSubscriptionName")
  valid_575008 = validateParameter(valid_575008, JString, required = true,
                                 default = nil)
  if valid_575008 != nil:
    section.add "customerSubscriptionName", valid_575008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575009 = query.getOrDefault("api-version")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_575009 != nil:
    section.add "api-version", valid_575009
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

proc call*(call_575011: Call_CustomerSubscriptionsCreate_575002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new customer subscription under a registration.
  ## 
  let valid = call_575011.validator(path, query, header, formData, body)
  let scheme = call_575011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575011.url(scheme.get, call_575011.host, call_575011.base,
                         call_575011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575011, url, valid)

proc call*(call_575012: Call_CustomerSubscriptionsCreate_575002;
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
  var path_575013 = newJObject()
  var query_575014 = newJObject()
  var body_575015 = newJObject()
  add(query_575014, "api-version", newJString(apiVersion))
  add(path_575013, "registrationName", newJString(registrationName))
  add(path_575013, "subscriptionId", newJString(subscriptionId))
  add(path_575013, "resourceGroup", newJString(resourceGroup))
  if customerCreationParameters != nil:
    body_575015 = customerCreationParameters
  add(path_575013, "customerSubscriptionName",
      newJString(customerSubscriptionName))
  result = call_575012.call(path_575013, query_575014, nil, nil, body_575015)

var customerSubscriptionsCreate* = Call_CustomerSubscriptionsCreate_575002(
    name: "customerSubscriptionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions/{customerSubscriptionName}",
    validator: validate_CustomerSubscriptionsCreate_575003, base: "",
    url: url_CustomerSubscriptionsCreate_575004, schemes: {Scheme.Https})
type
  Call_CustomerSubscriptionsGet_574981 = ref object of OpenApiRestCall_574441
proc url_CustomerSubscriptionsGet_574983(protocol: Scheme; host: string;
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

proc validate_CustomerSubscriptionsGet_574982(path: JsonNode; query: JsonNode;
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
  var valid_574993 = path.getOrDefault("registrationName")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "registrationName", valid_574993
  var valid_574994 = path.getOrDefault("subscriptionId")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "subscriptionId", valid_574994
  var valid_574995 = path.getOrDefault("resourceGroup")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "resourceGroup", valid_574995
  var valid_574996 = path.getOrDefault("customerSubscriptionName")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "customerSubscriptionName", valid_574996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574997 = query.getOrDefault("api-version")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_574997 != nil:
    section.add "api-version", valid_574997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574998: Call_CustomerSubscriptionsGet_574981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified product.
  ## 
  let valid = call_574998.validator(path, query, header, formData, body)
  let scheme = call_574998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574998.url(scheme.get, call_574998.host, call_574998.base,
                         call_574998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574998, url, valid)

proc call*(call_574999: Call_CustomerSubscriptionsGet_574981;
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
  var path_575000 = newJObject()
  var query_575001 = newJObject()
  add(query_575001, "api-version", newJString(apiVersion))
  add(path_575000, "registrationName", newJString(registrationName))
  add(path_575000, "subscriptionId", newJString(subscriptionId))
  add(path_575000, "resourceGroup", newJString(resourceGroup))
  add(path_575000, "customerSubscriptionName",
      newJString(customerSubscriptionName))
  result = call_574999.call(path_575000, query_575001, nil, nil, nil)

var customerSubscriptionsGet* = Call_CustomerSubscriptionsGet_574981(
    name: "customerSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions/{customerSubscriptionName}",
    validator: validate_CustomerSubscriptionsGet_574982, base: "",
    url: url_CustomerSubscriptionsGet_574983, schemes: {Scheme.Https})
type
  Call_CustomerSubscriptionsDelete_575016 = ref object of OpenApiRestCall_574441
proc url_CustomerSubscriptionsDelete_575018(protocol: Scheme; host: string;
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

proc validate_CustomerSubscriptionsDelete_575017(path: JsonNode; query: JsonNode;
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
  var valid_575019 = path.getOrDefault("registrationName")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = nil)
  if valid_575019 != nil:
    section.add "registrationName", valid_575019
  var valid_575020 = path.getOrDefault("subscriptionId")
  valid_575020 = validateParameter(valid_575020, JString, required = true,
                                 default = nil)
  if valid_575020 != nil:
    section.add "subscriptionId", valid_575020
  var valid_575021 = path.getOrDefault("resourceGroup")
  valid_575021 = validateParameter(valid_575021, JString, required = true,
                                 default = nil)
  if valid_575021 != nil:
    section.add "resourceGroup", valid_575021
  var valid_575022 = path.getOrDefault("customerSubscriptionName")
  valid_575022 = validateParameter(valid_575022, JString, required = true,
                                 default = nil)
  if valid_575022 != nil:
    section.add "customerSubscriptionName", valid_575022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575023 = query.getOrDefault("api-version")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_575023 != nil:
    section.add "api-version", valid_575023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575024: Call_CustomerSubscriptionsDelete_575016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a customer subscription under a registration.
  ## 
  let valid = call_575024.validator(path, query, header, formData, body)
  let scheme = call_575024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575024.url(scheme.get, call_575024.host, call_575024.base,
                         call_575024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575024, url, valid)

proc call*(call_575025: Call_CustomerSubscriptionsDelete_575016;
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
  var path_575026 = newJObject()
  var query_575027 = newJObject()
  add(query_575027, "api-version", newJString(apiVersion))
  add(path_575026, "registrationName", newJString(registrationName))
  add(path_575026, "subscriptionId", newJString(subscriptionId))
  add(path_575026, "resourceGroup", newJString(resourceGroup))
  add(path_575026, "customerSubscriptionName",
      newJString(customerSubscriptionName))
  result = call_575025.call(path_575026, query_575027, nil, nil, nil)

var customerSubscriptionsDelete* = Call_CustomerSubscriptionsDelete_575016(
    name: "customerSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions/{customerSubscriptionName}",
    validator: validate_CustomerSubscriptionsDelete_575017, base: "",
    url: url_CustomerSubscriptionsDelete_575018, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
