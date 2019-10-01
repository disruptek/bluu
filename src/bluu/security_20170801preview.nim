
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2017-08-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.Security (Azure Security Center) resource provider
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "security"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AutoProvisioningSettingsList_567880 = ref object of OpenApiRestCall_567658
proc url_AutoProvisioningSettingsList_567882(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/autoProvisioningSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AutoProvisioningSettingsList_567881(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exposes the auto provisioning settings of the subscriptions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568055 = path.getOrDefault("subscriptionId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "subscriptionId", valid_568055
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568069 = query.getOrDefault("api-version")
  valid_568069 = validateParameter(valid_568069, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568069 != nil:
    section.add "api-version", valid_568069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568092: Call_AutoProvisioningSettingsList_567880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exposes the auto provisioning settings of the subscriptions
  ## 
  let valid = call_568092.validator(path, query, header, formData, body)
  let scheme = call_568092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568092.url(scheme.get, call_568092.host, call_568092.base,
                         call_568092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568092, url, valid)

proc call*(call_568163: Call_AutoProvisioningSettingsList_567880;
          subscriptionId: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## autoProvisioningSettingsList
  ## Exposes the auto provisioning settings of the subscriptions
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568164 = newJObject()
  var query_568166 = newJObject()
  add(query_568166, "api-version", newJString(apiVersion))
  add(path_568164, "subscriptionId", newJString(subscriptionId))
  result = call_568163.call(path_568164, query_568166, nil, nil, nil)

var autoProvisioningSettingsList* = Call_AutoProvisioningSettingsList_567880(
    name: "autoProvisioningSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/autoProvisioningSettings",
    validator: validate_AutoProvisioningSettingsList_567881, base: "",
    url: url_AutoProvisioningSettingsList_567882, schemes: {Scheme.Https})
type
  Call_AutoProvisioningSettingsCreate_568215 = ref object of OpenApiRestCall_567658
proc url_AutoProvisioningSettingsCreate_568217(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "settingName" in path, "`settingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/autoProvisioningSettings/"),
               (kind: VariableSegment, value: "settingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AutoProvisioningSettingsCreate_568216(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Details of a specific setting
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   settingName: JString (required)
  ##              : Auto provisioning setting key
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `settingName` field"
  var valid_568218 = path.getOrDefault("settingName")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "settingName", valid_568218
  var valid_568219 = path.getOrDefault("subscriptionId")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "subscriptionId", valid_568219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568220 = query.getOrDefault("api-version")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568220 != nil:
    section.add "api-version", valid_568220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   setting: JObject (required)
  ##          : Auto provisioning setting key
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_AutoProvisioningSettingsCreate_568215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Details of a specific setting
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_AutoProvisioningSettingsCreate_568215;
          settingName: string; subscriptionId: string; setting: JsonNode;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## autoProvisioningSettingsCreate
  ## Details of a specific setting
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingName: string (required)
  ##              : Auto provisioning setting key
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   setting: JObject (required)
  ##          : Auto provisioning setting key
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  var body_568226 = newJObject()
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "settingName", newJString(settingName))
  add(path_568224, "subscriptionId", newJString(subscriptionId))
  if setting != nil:
    body_568226 = setting
  result = call_568223.call(path_568224, query_568225, nil, nil, body_568226)

var autoProvisioningSettingsCreate* = Call_AutoProvisioningSettingsCreate_568215(
    name: "autoProvisioningSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/autoProvisioningSettings/{settingName}",
    validator: validate_AutoProvisioningSettingsCreate_568216, base: "",
    url: url_AutoProvisioningSettingsCreate_568217, schemes: {Scheme.Https})
type
  Call_AutoProvisioningSettingsGet_568205 = ref object of OpenApiRestCall_567658
proc url_AutoProvisioningSettingsGet_568207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "settingName" in path, "`settingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/autoProvisioningSettings/"),
               (kind: VariableSegment, value: "settingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AutoProvisioningSettingsGet_568206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Details of a specific setting
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   settingName: JString (required)
  ##              : Auto provisioning setting key
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `settingName` field"
  var valid_568208 = path.getOrDefault("settingName")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "settingName", valid_568208
  var valid_568209 = path.getOrDefault("subscriptionId")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "subscriptionId", valid_568209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568210 = query.getOrDefault("api-version")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568210 != nil:
    section.add "api-version", valid_568210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568211: Call_AutoProvisioningSettingsGet_568205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Details of a specific setting
  ## 
  let valid = call_568211.validator(path, query, header, formData, body)
  let scheme = call_568211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568211.url(scheme.get, call_568211.host, call_568211.base,
                         call_568211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568211, url, valid)

proc call*(call_568212: Call_AutoProvisioningSettingsGet_568205;
          settingName: string; subscriptionId: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## autoProvisioningSettingsGet
  ## Details of a specific setting
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingName: string (required)
  ##              : Auto provisioning setting key
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568213 = newJObject()
  var query_568214 = newJObject()
  add(query_568214, "api-version", newJString(apiVersion))
  add(path_568213, "settingName", newJString(settingName))
  add(path_568213, "subscriptionId", newJString(subscriptionId))
  result = call_568212.call(path_568213, query_568214, nil, nil, nil)

var autoProvisioningSettingsGet* = Call_AutoProvisioningSettingsGet_568205(
    name: "autoProvisioningSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/autoProvisioningSettings/{settingName}",
    validator: validate_AutoProvisioningSettingsGet_568206, base: "",
    url: url_AutoProvisioningSettingsGet_568207, schemes: {Scheme.Https})
type
  Call_PricingsList_568227 = ref object of OpenApiRestCall_567658
proc url_PricingsList_568229(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/pricings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PricingsList_568228(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Security pricing configurations in the subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568230 = path.getOrDefault("subscriptionId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "subscriptionId", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568232: Call_PricingsList_568227; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security pricing configurations in the subscription
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_PricingsList_568227; subscriptionId: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## pricingsList
  ## Security pricing configurations in the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  add(query_568235, "api-version", newJString(apiVersion))
  add(path_568234, "subscriptionId", newJString(subscriptionId))
  result = call_568233.call(path_568234, query_568235, nil, nil, nil)

var pricingsList* = Call_PricingsList_568227(name: "pricingsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/pricings",
    validator: validate_PricingsList_568228, base: "", url: url_PricingsList_568229,
    schemes: {Scheme.Https})
type
  Call_PricingsUpdateSubscriptionPricing_568246 = ref object of OpenApiRestCall_567658
proc url_PricingsUpdateSubscriptionPricing_568248(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "pricingName" in path, "`pricingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/pricings/"),
               (kind: VariableSegment, value: "pricingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PricingsUpdateSubscriptionPricing_568247(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Security pricing configuration in the subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   pricingName: JString (required)
  ##              : name of the pricing configuration
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568249 = path.getOrDefault("subscriptionId")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "subscriptionId", valid_568249
  var valid_568250 = path.getOrDefault("pricingName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "pricingName", valid_568250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568251 = query.getOrDefault("api-version")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568251 != nil:
    section.add "api-version", valid_568251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   pricing: JObject (required)
  ##          : Pricing object
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568253: Call_PricingsUpdateSubscriptionPricing_568246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security pricing configuration in the subscription
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_PricingsUpdateSubscriptionPricing_568246;
          pricing: JsonNode; subscriptionId: string; pricingName: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## pricingsUpdateSubscriptionPricing
  ## Security pricing configuration in the subscription
  ##   pricing: JObject (required)
  ##          : Pricing object
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   pricingName: string (required)
  ##              : name of the pricing configuration
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  var body_568257 = newJObject()
  if pricing != nil:
    body_568257 = pricing
  add(query_568256, "api-version", newJString(apiVersion))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  add(path_568255, "pricingName", newJString(pricingName))
  result = call_568254.call(path_568255, query_568256, nil, nil, body_568257)

var pricingsUpdateSubscriptionPricing* = Call_PricingsUpdateSubscriptionPricing_568246(
    name: "pricingsUpdateSubscriptionPricing", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/pricings/{pricingName}",
    validator: validate_PricingsUpdateSubscriptionPricing_568247, base: "",
    url: url_PricingsUpdateSubscriptionPricing_568248, schemes: {Scheme.Https})
type
  Call_PricingsGetSubscriptionPricing_568236 = ref object of OpenApiRestCall_567658
proc url_PricingsGetSubscriptionPricing_568238(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "pricingName" in path, "`pricingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/pricings/"),
               (kind: VariableSegment, value: "pricingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PricingsGetSubscriptionPricing_568237(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Security pricing configuration in the subscriptionSecurity pricing configuration in the subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   pricingName: JString (required)
  ##              : name of the pricing configuration
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
  var valid_568240 = path.getOrDefault("pricingName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "pricingName", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568241 != nil:
    section.add "api-version", valid_568241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568242: Call_PricingsGetSubscriptionPricing_568236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security pricing configuration in the subscriptionSecurity pricing configuration in the subscription
  ## 
  let valid = call_568242.validator(path, query, header, formData, body)
  let scheme = call_568242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568242.url(scheme.get, call_568242.host, call_568242.base,
                         call_568242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568242, url, valid)

proc call*(call_568243: Call_PricingsGetSubscriptionPricing_568236;
          subscriptionId: string; pricingName: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## pricingsGetSubscriptionPricing
  ## Security pricing configuration in the subscriptionSecurity pricing configuration in the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   pricingName: string (required)
  ##              : name of the pricing configuration
  var path_568244 = newJObject()
  var query_568245 = newJObject()
  add(query_568245, "api-version", newJString(apiVersion))
  add(path_568244, "subscriptionId", newJString(subscriptionId))
  add(path_568244, "pricingName", newJString(pricingName))
  result = call_568243.call(path_568244, query_568245, nil, nil, nil)

var pricingsGetSubscriptionPricing* = Call_PricingsGetSubscriptionPricing_568236(
    name: "pricingsGetSubscriptionPricing", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/pricings/{pricingName}",
    validator: validate_PricingsGetSubscriptionPricing_568237, base: "",
    url: url_PricingsGetSubscriptionPricing_568238, schemes: {Scheme.Https})
type
  Call_SecurityContactsList_568258 = ref object of OpenApiRestCall_567658
proc url_SecurityContactsList_568260(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Security/securityContacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecurityContactsList_568259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Security contact configurations for the subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568261 = path.getOrDefault("subscriptionId")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "subscriptionId", valid_568261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568262 != nil:
    section.add "api-version", valid_568262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568263: Call_SecurityContactsList_568258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security contact configurations for the subscription
  ## 
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_SecurityContactsList_568258; subscriptionId: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## securityContactsList
  ## Security contact configurations for the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568265 = newJObject()
  var query_568266 = newJObject()
  add(query_568266, "api-version", newJString(apiVersion))
  add(path_568265, "subscriptionId", newJString(subscriptionId))
  result = call_568264.call(path_568265, query_568266, nil, nil, nil)

var securityContactsList* = Call_SecurityContactsList_568258(
    name: "securityContactsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/securityContacts",
    validator: validate_SecurityContactsList_568259, base: "",
    url: url_SecurityContactsList_568260, schemes: {Scheme.Https})
type
  Call_SecurityContactsCreate_568277 = ref object of OpenApiRestCall_567658
proc url_SecurityContactsCreate_568279(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "securityContactName" in path,
        "`securityContactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/securityContacts/"),
               (kind: VariableSegment, value: "securityContactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecurityContactsCreate_568278(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Security contact configurations for the subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   securityContactName: JString (required)
  ##                      : Name of the security contact object
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568280 = path.getOrDefault("subscriptionId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "subscriptionId", valid_568280
  var valid_568281 = path.getOrDefault("securityContactName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "securityContactName", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   securityContact: JObject (required)
  ##                  : Security contact object
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568284: Call_SecurityContactsCreate_568277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security contact configurations for the subscription
  ## 
  let valid = call_568284.validator(path, query, header, formData, body)
  let scheme = call_568284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568284.url(scheme.get, call_568284.host, call_568284.base,
                         call_568284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568284, url, valid)

proc call*(call_568285: Call_SecurityContactsCreate_568277; subscriptionId: string;
          securityContactName: string; securityContact: JsonNode;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## securityContactsCreate
  ## Security contact configurations for the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   securityContactName: string (required)
  ##                      : Name of the security contact object
  ##   securityContact: JObject (required)
  ##                  : Security contact object
  var path_568286 = newJObject()
  var query_568287 = newJObject()
  var body_568288 = newJObject()
  add(query_568287, "api-version", newJString(apiVersion))
  add(path_568286, "subscriptionId", newJString(subscriptionId))
  add(path_568286, "securityContactName", newJString(securityContactName))
  if securityContact != nil:
    body_568288 = securityContact
  result = call_568285.call(path_568286, query_568287, nil, nil, body_568288)

var securityContactsCreate* = Call_SecurityContactsCreate_568277(
    name: "securityContactsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/securityContacts/{securityContactName}",
    validator: validate_SecurityContactsCreate_568278, base: "",
    url: url_SecurityContactsCreate_568279, schemes: {Scheme.Https})
type
  Call_SecurityContactsGet_568267 = ref object of OpenApiRestCall_567658
proc url_SecurityContactsGet_568269(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "securityContactName" in path,
        "`securityContactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/securityContacts/"),
               (kind: VariableSegment, value: "securityContactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecurityContactsGet_568268(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Security contact configurations for the subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   securityContactName: JString (required)
  ##                      : Name of the security contact object
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568270 = path.getOrDefault("subscriptionId")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "subscriptionId", valid_568270
  var valid_568271 = path.getOrDefault("securityContactName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "securityContactName", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_SecurityContactsGet_568267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security contact configurations for the subscription
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_SecurityContactsGet_568267; subscriptionId: string;
          securityContactName: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## securityContactsGet
  ## Security contact configurations for the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   securityContactName: string (required)
  ##                      : Name of the security contact object
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  add(query_568276, "api-version", newJString(apiVersion))
  add(path_568275, "subscriptionId", newJString(subscriptionId))
  add(path_568275, "securityContactName", newJString(securityContactName))
  result = call_568274.call(path_568275, query_568276, nil, nil, nil)

var securityContactsGet* = Call_SecurityContactsGet_568267(
    name: "securityContactsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/securityContacts/{securityContactName}",
    validator: validate_SecurityContactsGet_568268, base: "",
    url: url_SecurityContactsGet_568269, schemes: {Scheme.Https})
type
  Call_SecurityContactsUpdate_568299 = ref object of OpenApiRestCall_567658
proc url_SecurityContactsUpdate_568301(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "securityContactName" in path,
        "`securityContactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/securityContacts/"),
               (kind: VariableSegment, value: "securityContactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecurityContactsUpdate_568300(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Security contact configurations for the subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   securityContactName: JString (required)
  ##                      : Name of the security contact object
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568302 = path.getOrDefault("subscriptionId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "subscriptionId", valid_568302
  var valid_568303 = path.getOrDefault("securityContactName")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "securityContactName", valid_568303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568304 = query.getOrDefault("api-version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568304 != nil:
    section.add "api-version", valid_568304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   securityContact: JObject (required)
  ##                  : Security contact object
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568306: Call_SecurityContactsUpdate_568299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security contact configurations for the subscription
  ## 
  let valid = call_568306.validator(path, query, header, formData, body)
  let scheme = call_568306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568306.url(scheme.get, call_568306.host, call_568306.base,
                         call_568306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568306, url, valid)

proc call*(call_568307: Call_SecurityContactsUpdate_568299; subscriptionId: string;
          securityContactName: string; securityContact: JsonNode;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## securityContactsUpdate
  ## Security contact configurations for the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   securityContactName: string (required)
  ##                      : Name of the security contact object
  ##   securityContact: JObject (required)
  ##                  : Security contact object
  var path_568308 = newJObject()
  var query_568309 = newJObject()
  var body_568310 = newJObject()
  add(query_568309, "api-version", newJString(apiVersion))
  add(path_568308, "subscriptionId", newJString(subscriptionId))
  add(path_568308, "securityContactName", newJString(securityContactName))
  if securityContact != nil:
    body_568310 = securityContact
  result = call_568307.call(path_568308, query_568309, nil, nil, body_568310)

var securityContactsUpdate* = Call_SecurityContactsUpdate_568299(
    name: "securityContactsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/securityContacts/{securityContactName}",
    validator: validate_SecurityContactsUpdate_568300, base: "",
    url: url_SecurityContactsUpdate_568301, schemes: {Scheme.Https})
type
  Call_SecurityContactsDelete_568289 = ref object of OpenApiRestCall_567658
proc url_SecurityContactsDelete_568291(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "securityContactName" in path,
        "`securityContactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/securityContacts/"),
               (kind: VariableSegment, value: "securityContactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecurityContactsDelete_568290(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Security contact configurations for the subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   securityContactName: JString (required)
  ##                      : Name of the security contact object
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568292 = path.getOrDefault("subscriptionId")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "subscriptionId", valid_568292
  var valid_568293 = path.getOrDefault("securityContactName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "securityContactName", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_SecurityContactsDelete_568289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security contact configurations for the subscription
  ## 
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_SecurityContactsDelete_568289; subscriptionId: string;
          securityContactName: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## securityContactsDelete
  ## Security contact configurations for the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   securityContactName: string (required)
  ##                      : Name of the security contact object
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "subscriptionId", newJString(subscriptionId))
  add(path_568297, "securityContactName", newJString(securityContactName))
  result = call_568296.call(path_568297, query_568298, nil, nil, nil)

var securityContactsDelete* = Call_SecurityContactsDelete_568289(
    name: "securityContactsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/securityContacts/{securityContactName}",
    validator: validate_SecurityContactsDelete_568290, base: "",
    url: url_SecurityContactsDelete_568291, schemes: {Scheme.Https})
type
  Call_SettingsList_568311 = ref object of OpenApiRestCall_567658
proc url_SettingsList_568313(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/settings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SettingsList_568312(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Settings about different configurations in security center
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568314 = path.getOrDefault("subscriptionId")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "subscriptionId", valid_568314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568315 = query.getOrDefault("api-version")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568315 != nil:
    section.add "api-version", valid_568315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568316: Call_SettingsList_568311; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Settings about different configurations in security center
  ## 
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_SettingsList_568311; subscriptionId: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## settingsList
  ## Settings about different configurations in security center
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568318 = newJObject()
  var query_568319 = newJObject()
  add(query_568319, "api-version", newJString(apiVersion))
  add(path_568318, "subscriptionId", newJString(subscriptionId))
  result = call_568317.call(path_568318, query_568319, nil, nil, nil)

var settingsList* = Call_SettingsList_568311(name: "settingsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/settings",
    validator: validate_SettingsList_568312, base: "", url: url_SettingsList_568313,
    schemes: {Scheme.Https})
type
  Call_SettingsUpdate_568330 = ref object of OpenApiRestCall_567658
proc url_SettingsUpdate_568332(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "settingName" in path, "`settingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/settings/"),
               (kind: VariableSegment, value: "settingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SettingsUpdate_568331(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## updating settings about different configurations in security center
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   settingName: JString (required)
  ##              : Name of setting: (MCAS/WDATP)
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `settingName` field"
  var valid_568333 = path.getOrDefault("settingName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = newJString("MCAS"))
  if valid_568333 != nil:
    section.add "settingName", valid_568333
  var valid_568334 = path.getOrDefault("subscriptionId")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "subscriptionId", valid_568334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568335 = query.getOrDefault("api-version")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568335 != nil:
    section.add "api-version", valid_568335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   setting: JObject (required)
  ##          : Setting object
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568337: Call_SettingsUpdate_568330; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## updating settings about different configurations in security center
  ## 
  let valid = call_568337.validator(path, query, header, formData, body)
  let scheme = call_568337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568337.url(scheme.get, call_568337.host, call_568337.base,
                         call_568337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568337, url, valid)

proc call*(call_568338: Call_SettingsUpdate_568330; subscriptionId: string;
          setting: JsonNode; apiVersion: string = "2017-08-01-preview";
          settingName: string = "MCAS"): Recallable =
  ## settingsUpdate
  ## updating settings about different configurations in security center
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingName: string (required)
  ##              : Name of setting: (MCAS/WDATP)
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   setting: JObject (required)
  ##          : Setting object
  var path_568339 = newJObject()
  var query_568340 = newJObject()
  var body_568341 = newJObject()
  add(query_568340, "api-version", newJString(apiVersion))
  add(path_568339, "settingName", newJString(settingName))
  add(path_568339, "subscriptionId", newJString(subscriptionId))
  if setting != nil:
    body_568341 = setting
  result = call_568338.call(path_568339, query_568340, nil, nil, body_568341)

var settingsUpdate* = Call_SettingsUpdate_568330(name: "settingsUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/settings/{settingName}",
    validator: validate_SettingsUpdate_568331, base: "", url: url_SettingsUpdate_568332,
    schemes: {Scheme.Https})
type
  Call_SettingsGet_568320 = ref object of OpenApiRestCall_567658
proc url_SettingsGet_568322(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "settingName" in path, "`settingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/settings/"),
               (kind: VariableSegment, value: "settingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SettingsGet_568321(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Settings of different configurations in security center
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   settingName: JString (required)
  ##              : Name of setting: (MCAS/WDATP)
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `settingName` field"
  var valid_568323 = path.getOrDefault("settingName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = newJString("MCAS"))
  if valid_568323 != nil:
    section.add "settingName", valid_568323
  var valid_568324 = path.getOrDefault("subscriptionId")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "subscriptionId", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568325 != nil:
    section.add "api-version", valid_568325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568326: Call_SettingsGet_568320; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Settings of different configurations in security center
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_SettingsGet_568320; subscriptionId: string;
          apiVersion: string = "2017-08-01-preview"; settingName: string = "MCAS"): Recallable =
  ## settingsGet
  ## Settings of different configurations in security center
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingName: string (required)
  ##              : Name of setting: (MCAS/WDATP)
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "settingName", newJString(settingName))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  result = call_568327.call(path_568328, query_568329, nil, nil, nil)

var settingsGet* = Call_SettingsGet_568320(name: "settingsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/settings/{settingName}",
                                        validator: validate_SettingsGet_568321,
                                        base: "", url: url_SettingsGet_568322,
                                        schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsList_568342 = ref object of OpenApiRestCall_567658
proc url_WorkspaceSettingsList_568344(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Security/workspaceSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceSettingsList_568343(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568345 = path.getOrDefault("subscriptionId")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "subscriptionId", valid_568345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568347: Call_WorkspaceSettingsList_568342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ## 
  let valid = call_568347.validator(path, query, header, formData, body)
  let scheme = call_568347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568347.url(scheme.get, call_568347.host, call_568347.base,
                         call_568347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568347, url, valid)

proc call*(call_568348: Call_WorkspaceSettingsList_568342; subscriptionId: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## workspaceSettingsList
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568349 = newJObject()
  var query_568350 = newJObject()
  add(query_568350, "api-version", newJString(apiVersion))
  add(path_568349, "subscriptionId", newJString(subscriptionId))
  result = call_568348.call(path_568349, query_568350, nil, nil, nil)

var workspaceSettingsList* = Call_WorkspaceSettingsList_568342(
    name: "workspaceSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings",
    validator: validate_WorkspaceSettingsList_568343, base: "",
    url: url_WorkspaceSettingsList_568344, schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsCreate_568361 = ref object of OpenApiRestCall_567658
proc url_WorkspaceSettingsCreate_568363(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "workspaceSettingName" in path,
        "`workspaceSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/workspaceSettings/"),
               (kind: VariableSegment, value: "workspaceSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceSettingsCreate_568362(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## creating settings about where we should store your security data and logs
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceSettingName: JString (required)
  ##                       : Name of the security setting
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568364 = path.getOrDefault("subscriptionId")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "subscriptionId", valid_568364
  var valid_568365 = path.getOrDefault("workspaceSettingName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "workspaceSettingName", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workspaceSetting: JObject (required)
  ##                   : Security data setting object
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568368: Call_WorkspaceSettingsCreate_568361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## creating settings about where we should store your security data and logs
  ## 
  let valid = call_568368.validator(path, query, header, formData, body)
  let scheme = call_568368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568368.url(scheme.get, call_568368.host, call_568368.base,
                         call_568368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568368, url, valid)

proc call*(call_568369: Call_WorkspaceSettingsCreate_568361;
          subscriptionId: string; workspaceSetting: JsonNode;
          workspaceSettingName: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## workspaceSettingsCreate
  ## creating settings about where we should store your security data and logs
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceSetting: JObject (required)
  ##                   : Security data setting object
  ##   workspaceSettingName: string (required)
  ##                       : Name of the security setting
  var path_568370 = newJObject()
  var query_568371 = newJObject()
  var body_568372 = newJObject()
  add(query_568371, "api-version", newJString(apiVersion))
  add(path_568370, "subscriptionId", newJString(subscriptionId))
  if workspaceSetting != nil:
    body_568372 = workspaceSetting
  add(path_568370, "workspaceSettingName", newJString(workspaceSettingName))
  result = call_568369.call(path_568370, query_568371, nil, nil, body_568372)

var workspaceSettingsCreate* = Call_WorkspaceSettingsCreate_568361(
    name: "workspaceSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings/{workspaceSettingName}",
    validator: validate_WorkspaceSettingsCreate_568362, base: "",
    url: url_WorkspaceSettingsCreate_568363, schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsGet_568351 = ref object of OpenApiRestCall_567658
proc url_WorkspaceSettingsGet_568353(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "workspaceSettingName" in path,
        "`workspaceSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/workspaceSettings/"),
               (kind: VariableSegment, value: "workspaceSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceSettingsGet_568352(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceSettingName: JString (required)
  ##                       : Name of the security setting
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568354 = path.getOrDefault("subscriptionId")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "subscriptionId", valid_568354
  var valid_568355 = path.getOrDefault("workspaceSettingName")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "workspaceSettingName", valid_568355
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568357: Call_WorkspaceSettingsGet_568351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ## 
  let valid = call_568357.validator(path, query, header, formData, body)
  let scheme = call_568357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568357.url(scheme.get, call_568357.host, call_568357.base,
                         call_568357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568357, url, valid)

proc call*(call_568358: Call_WorkspaceSettingsGet_568351; subscriptionId: string;
          workspaceSettingName: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## workspaceSettingsGet
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceSettingName: string (required)
  ##                       : Name of the security setting
  var path_568359 = newJObject()
  var query_568360 = newJObject()
  add(query_568360, "api-version", newJString(apiVersion))
  add(path_568359, "subscriptionId", newJString(subscriptionId))
  add(path_568359, "workspaceSettingName", newJString(workspaceSettingName))
  result = call_568358.call(path_568359, query_568360, nil, nil, nil)

var workspaceSettingsGet* = Call_WorkspaceSettingsGet_568351(
    name: "workspaceSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings/{workspaceSettingName}",
    validator: validate_WorkspaceSettingsGet_568352, base: "",
    url: url_WorkspaceSettingsGet_568353, schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsUpdate_568383 = ref object of OpenApiRestCall_567658
proc url_WorkspaceSettingsUpdate_568385(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "workspaceSettingName" in path,
        "`workspaceSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/workspaceSettings/"),
               (kind: VariableSegment, value: "workspaceSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceSettingsUpdate_568384(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Settings about where we should store your security data and logs
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceSettingName: JString (required)
  ##                       : Name of the security setting
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568386 = path.getOrDefault("subscriptionId")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "subscriptionId", valid_568386
  var valid_568387 = path.getOrDefault("workspaceSettingName")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "workspaceSettingName", valid_568387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568388 = query.getOrDefault("api-version")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568388 != nil:
    section.add "api-version", valid_568388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   workspaceSetting: JObject (required)
  ##                   : Security data setting object
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568390: Call_WorkspaceSettingsUpdate_568383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Settings about where we should store your security data and logs
  ## 
  let valid = call_568390.validator(path, query, header, formData, body)
  let scheme = call_568390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568390.url(scheme.get, call_568390.host, call_568390.base,
                         call_568390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568390, url, valid)

proc call*(call_568391: Call_WorkspaceSettingsUpdate_568383;
          subscriptionId: string; workspaceSetting: JsonNode;
          workspaceSettingName: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## workspaceSettingsUpdate
  ## Settings about where we should store your security data and logs
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceSetting: JObject (required)
  ##                   : Security data setting object
  ##   workspaceSettingName: string (required)
  ##                       : Name of the security setting
  var path_568392 = newJObject()
  var query_568393 = newJObject()
  var body_568394 = newJObject()
  add(query_568393, "api-version", newJString(apiVersion))
  add(path_568392, "subscriptionId", newJString(subscriptionId))
  if workspaceSetting != nil:
    body_568394 = workspaceSetting
  add(path_568392, "workspaceSettingName", newJString(workspaceSettingName))
  result = call_568391.call(path_568392, query_568393, nil, nil, body_568394)

var workspaceSettingsUpdate* = Call_WorkspaceSettingsUpdate_568383(
    name: "workspaceSettingsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings/{workspaceSettingName}",
    validator: validate_WorkspaceSettingsUpdate_568384, base: "",
    url: url_WorkspaceSettingsUpdate_568385, schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsDelete_568373 = ref object of OpenApiRestCall_567658
proc url_WorkspaceSettingsDelete_568375(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "workspaceSettingName" in path,
        "`workspaceSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/workspaceSettings/"),
               (kind: VariableSegment, value: "workspaceSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceSettingsDelete_568374(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the custom workspace settings for this subscription. new VMs will report to the default workspace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceSettingName: JString (required)
  ##                       : Name of the security setting
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568376 = path.getOrDefault("subscriptionId")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "subscriptionId", valid_568376
  var valid_568377 = path.getOrDefault("workspaceSettingName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "workspaceSettingName", valid_568377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568378 = query.getOrDefault("api-version")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568378 != nil:
    section.add "api-version", valid_568378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568379: Call_WorkspaceSettingsDelete_568373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the custom workspace settings for this subscription. new VMs will report to the default workspace
  ## 
  let valid = call_568379.validator(path, query, header, formData, body)
  let scheme = call_568379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568379.url(scheme.get, call_568379.host, call_568379.base,
                         call_568379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568379, url, valid)

proc call*(call_568380: Call_WorkspaceSettingsDelete_568373;
          subscriptionId: string; workspaceSettingName: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## workspaceSettingsDelete
  ## Deletes the custom workspace settings for this subscription. new VMs will report to the default workspace
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceSettingName: string (required)
  ##                       : Name of the security setting
  var path_568381 = newJObject()
  var query_568382 = newJObject()
  add(query_568382, "api-version", newJString(apiVersion))
  add(path_568381, "subscriptionId", newJString(subscriptionId))
  add(path_568381, "workspaceSettingName", newJString(workspaceSettingName))
  result = call_568380.call(path_568381, query_568382, nil, nil, nil)

var workspaceSettingsDelete* = Call_WorkspaceSettingsDelete_568373(
    name: "workspaceSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings/{workspaceSettingName}",
    validator: validate_WorkspaceSettingsDelete_568374, base: "",
    url: url_WorkspaceSettingsDelete_568375, schemes: {Scheme.Https})
type
  Call_PricingsListByResourceGroup_568395 = ref object of OpenApiRestCall_567658
proc url_PricingsListByResourceGroup_568397(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.Security/pricings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PricingsListByResourceGroup_568396(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Security pricing configurations in the resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568398 = path.getOrDefault("resourceGroupName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "resourceGroupName", valid_568398
  var valid_568399 = path.getOrDefault("subscriptionId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "subscriptionId", valid_568399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568400 = query.getOrDefault("api-version")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568400 != nil:
    section.add "api-version", valid_568400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568401: Call_PricingsListByResourceGroup_568395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security pricing configurations in the resource group
  ## 
  let valid = call_568401.validator(path, query, header, formData, body)
  let scheme = call_568401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568401.url(scheme.get, call_568401.host, call_568401.base,
                         call_568401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568401, url, valid)

proc call*(call_568402: Call_PricingsListByResourceGroup_568395;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## pricingsListByResourceGroup
  ## Security pricing configurations in the resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568403 = newJObject()
  var query_568404 = newJObject()
  add(path_568403, "resourceGroupName", newJString(resourceGroupName))
  add(query_568404, "api-version", newJString(apiVersion))
  add(path_568403, "subscriptionId", newJString(subscriptionId))
  result = call_568402.call(path_568403, query_568404, nil, nil, nil)

var pricingsListByResourceGroup* = Call_PricingsListByResourceGroup_568395(
    name: "pricingsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/pricings",
    validator: validate_PricingsListByResourceGroup_568396, base: "",
    url: url_PricingsListByResourceGroup_568397, schemes: {Scheme.Https})
type
  Call_PricingsCreateOrUpdateResourceGroupPricing_568416 = ref object of OpenApiRestCall_567658
proc url_PricingsCreateOrUpdateResourceGroupPricing_568418(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "pricingName" in path, "`pricingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/pricings/"),
               (kind: VariableSegment, value: "pricingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PricingsCreateOrUpdateResourceGroupPricing_568417(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Security pricing configuration in the resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   pricingName: JString (required)
  ##              : name of the pricing configuration
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568419 = path.getOrDefault("resourceGroupName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "resourceGroupName", valid_568419
  var valid_568420 = path.getOrDefault("subscriptionId")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "subscriptionId", valid_568420
  var valid_568421 = path.getOrDefault("pricingName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "pricingName", valid_568421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568422 = query.getOrDefault("api-version")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568422 != nil:
    section.add "api-version", valid_568422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   pricing: JObject (required)
  ##          : Pricing object
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568424: Call_PricingsCreateOrUpdateResourceGroupPricing_568416;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security pricing configuration in the resource group
  ## 
  let valid = call_568424.validator(path, query, header, formData, body)
  let scheme = call_568424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568424.url(scheme.get, call_568424.host, call_568424.base,
                         call_568424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568424, url, valid)

proc call*(call_568425: Call_PricingsCreateOrUpdateResourceGroupPricing_568416;
          pricing: JsonNode; resourceGroupName: string; subscriptionId: string;
          pricingName: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## pricingsCreateOrUpdateResourceGroupPricing
  ## Security pricing configuration in the resource group
  ##   pricing: JObject (required)
  ##          : Pricing object
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   pricingName: string (required)
  ##              : name of the pricing configuration
  var path_568426 = newJObject()
  var query_568427 = newJObject()
  var body_568428 = newJObject()
  if pricing != nil:
    body_568428 = pricing
  add(path_568426, "resourceGroupName", newJString(resourceGroupName))
  add(query_568427, "api-version", newJString(apiVersion))
  add(path_568426, "subscriptionId", newJString(subscriptionId))
  add(path_568426, "pricingName", newJString(pricingName))
  result = call_568425.call(path_568426, query_568427, nil, nil, body_568428)

var pricingsCreateOrUpdateResourceGroupPricing* = Call_PricingsCreateOrUpdateResourceGroupPricing_568416(
    name: "pricingsCreateOrUpdateResourceGroupPricing", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/pricings/{pricingName}",
    validator: validate_PricingsCreateOrUpdateResourceGroupPricing_568417,
    base: "", url: url_PricingsCreateOrUpdateResourceGroupPricing_568418,
    schemes: {Scheme.Https})
type
  Call_PricingsGetResourceGroupPricing_568405 = ref object of OpenApiRestCall_567658
proc url_PricingsGetResourceGroupPricing_568407(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "pricingName" in path, "`pricingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Security/pricings/"),
               (kind: VariableSegment, value: "pricingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PricingsGetResourceGroupPricing_568406(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Security pricing configuration in the resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   pricingName: JString (required)
  ##              : name of the pricing configuration
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568408 = path.getOrDefault("resourceGroupName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "resourceGroupName", valid_568408
  var valid_568409 = path.getOrDefault("subscriptionId")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "subscriptionId", valid_568409
  var valid_568410 = path.getOrDefault("pricingName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "pricingName", valid_568410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568411 = query.getOrDefault("api-version")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568411 != nil:
    section.add "api-version", valid_568411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568412: Call_PricingsGetResourceGroupPricing_568405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security pricing configuration in the resource group
  ## 
  let valid = call_568412.validator(path, query, header, formData, body)
  let scheme = call_568412.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568412.url(scheme.get, call_568412.host, call_568412.base,
                         call_568412.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568412, url, valid)

proc call*(call_568413: Call_PricingsGetResourceGroupPricing_568405;
          resourceGroupName: string; subscriptionId: string; pricingName: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## pricingsGetResourceGroupPricing
  ## Security pricing configuration in the resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   pricingName: string (required)
  ##              : name of the pricing configuration
  var path_568414 = newJObject()
  var query_568415 = newJObject()
  add(path_568414, "resourceGroupName", newJString(resourceGroupName))
  add(query_568415, "api-version", newJString(apiVersion))
  add(path_568414, "subscriptionId", newJString(subscriptionId))
  add(path_568414, "pricingName", newJString(pricingName))
  result = call_568413.call(path_568414, query_568415, nil, nil, nil)

var pricingsGetResourceGroupPricing* = Call_PricingsGetResourceGroupPricing_568405(
    name: "pricingsGetResourceGroupPricing", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/pricings/{pricingName}",
    validator: validate_PricingsGetResourceGroupPricing_568406, base: "",
    url: url_PricingsGetResourceGroupPricing_568407, schemes: {Scheme.Https})
type
  Call_AdvancedThreatProtectionCreate_568439 = ref object of OpenApiRestCall_567658
proc url_AdvancedThreatProtectionCreate_568441(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "settingName" in path, "`settingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment, value: "/providers/Microsoft.Security/advancedThreatProtectionSettings/"),
               (kind: VariableSegment, value: "settingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdvancedThreatProtectionCreate_568440(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the Advanced Threat Protection settings on a specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   settingName: JString (required)
  ##              : Advanced Threat Protection setting name.
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `settingName` field"
  var valid_568442 = path.getOrDefault("settingName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = newJString("current"))
  if valid_568442 != nil:
    section.add "settingName", valid_568442
  var valid_568443 = path.getOrDefault("resourceId")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "resourceId", valid_568443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568444 = query.getOrDefault("api-version")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568444 != nil:
    section.add "api-version", valid_568444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   advancedThreatProtectionSetting: JObject (required)
  ##                                  : Advanced Threat Protection Settings
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568446: Call_AdvancedThreatProtectionCreate_568439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the Advanced Threat Protection settings on a specified resource.
  ## 
  let valid = call_568446.validator(path, query, header, formData, body)
  let scheme = call_568446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568446.url(scheme.get, call_568446.host, call_568446.base,
                         call_568446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568446, url, valid)

proc call*(call_568447: Call_AdvancedThreatProtectionCreate_568439;
          resourceId: string; advancedThreatProtectionSetting: JsonNode;
          apiVersion: string = "2017-08-01-preview"; settingName: string = "current"): Recallable =
  ## advancedThreatProtectionCreate
  ## Creates or updates the Advanced Threat Protection settings on a specified resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingName: string (required)
  ##              : Advanced Threat Protection setting name.
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  ##   advancedThreatProtectionSetting: JObject (required)
  ##                                  : Advanced Threat Protection Settings
  var path_568448 = newJObject()
  var query_568449 = newJObject()
  var body_568450 = newJObject()
  add(query_568449, "api-version", newJString(apiVersion))
  add(path_568448, "settingName", newJString(settingName))
  add(path_568448, "resourceId", newJString(resourceId))
  if advancedThreatProtectionSetting != nil:
    body_568450 = advancedThreatProtectionSetting
  result = call_568447.call(path_568448, query_568449, nil, nil, body_568450)

var advancedThreatProtectionCreate* = Call_AdvancedThreatProtectionCreate_568439(
    name: "advancedThreatProtectionCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/advancedThreatProtectionSettings/{settingName}",
    validator: validate_AdvancedThreatProtectionCreate_568440, base: "",
    url: url_AdvancedThreatProtectionCreate_568441, schemes: {Scheme.Https})
type
  Call_AdvancedThreatProtectionGet_568429 = ref object of OpenApiRestCall_567658
proc url_AdvancedThreatProtectionGet_568431(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "settingName" in path, "`settingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment, value: "/providers/Microsoft.Security/advancedThreatProtectionSettings/"),
               (kind: VariableSegment, value: "settingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdvancedThreatProtectionGet_568430(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Advanced Threat Protection settings for the specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   settingName: JString (required)
  ##              : Advanced Threat Protection setting name.
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `settingName` field"
  var valid_568432 = path.getOrDefault("settingName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = newJString("current"))
  if valid_568432 != nil:
    section.add "settingName", valid_568432
  var valid_568433 = path.getOrDefault("resourceId")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "resourceId", valid_568433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568434 = query.getOrDefault("api-version")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568434 != nil:
    section.add "api-version", valid_568434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568435: Call_AdvancedThreatProtectionGet_568429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Advanced Threat Protection settings for the specified resource.
  ## 
  let valid = call_568435.validator(path, query, header, formData, body)
  let scheme = call_568435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568435.url(scheme.get, call_568435.host, call_568435.base,
                         call_568435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568435, url, valid)

proc call*(call_568436: Call_AdvancedThreatProtectionGet_568429;
          resourceId: string; apiVersion: string = "2017-08-01-preview";
          settingName: string = "current"): Recallable =
  ## advancedThreatProtectionGet
  ## Gets the Advanced Threat Protection settings for the specified resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingName: string (required)
  ##              : Advanced Threat Protection setting name.
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  var path_568437 = newJObject()
  var query_568438 = newJObject()
  add(query_568438, "api-version", newJString(apiVersion))
  add(path_568437, "settingName", newJString(settingName))
  add(path_568437, "resourceId", newJString(resourceId))
  result = call_568436.call(path_568437, query_568438, nil, nil, nil)

var advancedThreatProtectionGet* = Call_AdvancedThreatProtectionGet_568429(
    name: "advancedThreatProtectionGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/advancedThreatProtectionSettings/{settingName}",
    validator: validate_AdvancedThreatProtectionGet_568430, base: "",
    url: url_AdvancedThreatProtectionGet_568431, schemes: {Scheme.Https})
type
  Call_CompliancesList_568451 = ref object of OpenApiRestCall_567658
proc url_CompliancesList_568453(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/compliances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CompliancesList_568452(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## The Compliance scores of the specific management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568454 = path.getOrDefault("scope")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "scope", valid_568454
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568455 = query.getOrDefault("api-version")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568455 != nil:
    section.add "api-version", valid_568455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568456: Call_CompliancesList_568451; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Compliance scores of the specific management group.
  ## 
  let valid = call_568456.validator(path, query, header, formData, body)
  let scheme = call_568456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568456.url(scheme.get, call_568456.host, call_568456.base,
                         call_568456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568456, url, valid)

proc call*(call_568457: Call_CompliancesList_568451; scope: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## compliancesList
  ## The Compliance scores of the specific management group.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_568458 = newJObject()
  var query_568459 = newJObject()
  add(query_568459, "api-version", newJString(apiVersion))
  add(path_568458, "scope", newJString(scope))
  result = call_568457.call(path_568458, query_568459, nil, nil, nil)

var compliancesList* = Call_CompliancesList_568451(name: "compliancesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Security/compliances",
    validator: validate_CompliancesList_568452, base: "", url: url_CompliancesList_568453,
    schemes: {Scheme.Https})
type
  Call_CompliancesGet_568460 = ref object of OpenApiRestCall_567658
proc url_CompliancesGet_568462(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "complianceName" in path, "`complianceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/compliances/"),
               (kind: VariableSegment, value: "complianceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CompliancesGet_568461(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Details of a specific Compliance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   complianceName: JString (required)
  ##                 : name of the Compliance
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `complianceName` field"
  var valid_568463 = path.getOrDefault("complianceName")
  valid_568463 = validateParameter(valid_568463, JString, required = true,
                                 default = nil)
  if valid_568463 != nil:
    section.add "complianceName", valid_568463
  var valid_568464 = path.getOrDefault("scope")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "scope", valid_568464
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568465 = query.getOrDefault("api-version")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568465 != nil:
    section.add "api-version", valid_568465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568466: Call_CompliancesGet_568460; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Details of a specific Compliance.
  ## 
  let valid = call_568466.validator(path, query, header, formData, body)
  let scheme = call_568466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568466.url(scheme.get, call_568466.host, call_568466.base,
                         call_568466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568466, url, valid)

proc call*(call_568467: Call_CompliancesGet_568460; complianceName: string;
          scope: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## compliancesGet
  ## Details of a specific Compliance.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   complianceName: string (required)
  ##                 : name of the Compliance
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_568468 = newJObject()
  var query_568469 = newJObject()
  add(query_568469, "api-version", newJString(apiVersion))
  add(path_568468, "complianceName", newJString(complianceName))
  add(path_568468, "scope", newJString(scope))
  result = call_568467.call(path_568468, query_568469, nil, nil, nil)

var compliancesGet* = Call_CompliancesGet_568460(name: "compliancesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/compliances/{complianceName}",
    validator: validate_CompliancesGet_568461, base: "", url: url_CompliancesGet_568462,
    schemes: {Scheme.Https})
type
  Call_InformationProtectionPoliciesList_568470 = ref object of OpenApiRestCall_567658
proc url_InformationProtectionPoliciesList_568472(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/informationProtectionPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InformationProtectionPoliciesList_568471(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Information protection policies of a specific management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568473 = path.getOrDefault("scope")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "scope", valid_568473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568474 = query.getOrDefault("api-version")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568474 != nil:
    section.add "api-version", valid_568474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568475: Call_InformationProtectionPoliciesList_568470;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Information protection policies of a specific management group.
  ## 
  let valid = call_568475.validator(path, query, header, formData, body)
  let scheme = call_568475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568475.url(scheme.get, call_568475.host, call_568475.base,
                         call_568475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568475, url, valid)

proc call*(call_568476: Call_InformationProtectionPoliciesList_568470;
          scope: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## informationProtectionPoliciesList
  ## Information protection policies of a specific management group.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_568477 = newJObject()
  var query_568478 = newJObject()
  add(query_568478, "api-version", newJString(apiVersion))
  add(path_568477, "scope", newJString(scope))
  result = call_568476.call(path_568477, query_568478, nil, nil, nil)

var informationProtectionPoliciesList* = Call_InformationProtectionPoliciesList_568470(
    name: "informationProtectionPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/informationProtectionPolicies",
    validator: validate_InformationProtectionPoliciesList_568471, base: "",
    url: url_InformationProtectionPoliciesList_568472, schemes: {Scheme.Https})
type
  Call_InformationProtectionPoliciesCreateOrUpdate_568489 = ref object of OpenApiRestCall_567658
proc url_InformationProtectionPoliciesCreateOrUpdate_568491(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "informationProtectionPolicyName" in path,
        "`informationProtectionPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/informationProtectionPolicies/"), (
        kind: VariableSegment, value: "informationProtectionPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InformationProtectionPoliciesCreateOrUpdate_568490(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Details of the information protection policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   informationProtectionPolicyName: JString (required)
  ##                                  : Name of the information protection policy.
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `informationProtectionPolicyName` field"
  var valid_568492 = path.getOrDefault("informationProtectionPolicyName")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = newJString("effective"))
  if valid_568492 != nil:
    section.add "informationProtectionPolicyName", valid_568492
  var valid_568493 = path.getOrDefault("scope")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "scope", valid_568493
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568494 = query.getOrDefault("api-version")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568494 != nil:
    section.add "api-version", valid_568494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568495: Call_InformationProtectionPoliciesCreateOrUpdate_568489;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Details of the information protection policy.
  ## 
  let valid = call_568495.validator(path, query, header, formData, body)
  let scheme = call_568495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568495.url(scheme.get, call_568495.host, call_568495.base,
                         call_568495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568495, url, valid)

proc call*(call_568496: Call_InformationProtectionPoliciesCreateOrUpdate_568489;
          scope: string; informationProtectionPolicyName: string = "effective";
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## informationProtectionPoliciesCreateOrUpdate
  ## Details of the information protection policy.
  ##   informationProtectionPolicyName: string (required)
  ##                                  : Name of the information protection policy.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_568497 = newJObject()
  var query_568498 = newJObject()
  add(path_568497, "informationProtectionPolicyName",
      newJString(informationProtectionPolicyName))
  add(query_568498, "api-version", newJString(apiVersion))
  add(path_568497, "scope", newJString(scope))
  result = call_568496.call(path_568497, query_568498, nil, nil, nil)

var informationProtectionPoliciesCreateOrUpdate* = Call_InformationProtectionPoliciesCreateOrUpdate_568489(
    name: "informationProtectionPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/informationProtectionPolicies/{informationProtectionPolicyName}",
    validator: validate_InformationProtectionPoliciesCreateOrUpdate_568490,
    base: "", url: url_InformationProtectionPoliciesCreateOrUpdate_568491,
    schemes: {Scheme.Https})
type
  Call_InformationProtectionPoliciesGet_568479 = ref object of OpenApiRestCall_567658
proc url_InformationProtectionPoliciesGet_568481(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "informationProtectionPolicyName" in path,
        "`informationProtectionPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/informationProtectionPolicies/"), (
        kind: VariableSegment, value: "informationProtectionPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InformationProtectionPoliciesGet_568480(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Details of the information protection policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   informationProtectionPolicyName: JString (required)
  ##                                  : Name of the information protection policy.
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `informationProtectionPolicyName` field"
  var valid_568482 = path.getOrDefault("informationProtectionPolicyName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = newJString("effective"))
  if valid_568482 != nil:
    section.add "informationProtectionPolicyName", valid_568482
  var valid_568483 = path.getOrDefault("scope")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "scope", valid_568483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568484 = query.getOrDefault("api-version")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_568484 != nil:
    section.add "api-version", valid_568484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568485: Call_InformationProtectionPoliciesGet_568479;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Details of the information protection policy.
  ## 
  let valid = call_568485.validator(path, query, header, formData, body)
  let scheme = call_568485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568485.url(scheme.get, call_568485.host, call_568485.base,
                         call_568485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568485, url, valid)

proc call*(call_568486: Call_InformationProtectionPoliciesGet_568479;
          scope: string; informationProtectionPolicyName: string = "effective";
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## informationProtectionPoliciesGet
  ## Details of the information protection policy.
  ##   informationProtectionPolicyName: string (required)
  ##                                  : Name of the information protection policy.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_568487 = newJObject()
  var query_568488 = newJObject()
  add(path_568487, "informationProtectionPolicyName",
      newJString(informationProtectionPolicyName))
  add(query_568488, "api-version", newJString(apiVersion))
  add(path_568487, "scope", newJString(scope))
  result = call_568486.call(path_568487, query_568488, nil, nil, nil)

var informationProtectionPoliciesGet* = Call_InformationProtectionPoliciesGet_568479(
    name: "informationProtectionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/informationProtectionPolicies/{informationProtectionPolicyName}",
    validator: validate_InformationProtectionPoliciesGet_568480, base: "",
    url: url_InformationProtectionPoliciesGet_568481, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
