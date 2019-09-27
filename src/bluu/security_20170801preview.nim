
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "security"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AutoProvisioningSettingsList_593647 = ref object of OpenApiRestCall_593425
proc url_AutoProvisioningSettingsList_593649(protocol: Scheme; host: string;
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

proc validate_AutoProvisioningSettingsList_593648(path: JsonNode; query: JsonNode;
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
  var valid_593822 = path.getOrDefault("subscriptionId")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "subscriptionId", valid_593822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593836 = query.getOrDefault("api-version")
  valid_593836 = validateParameter(valid_593836, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_593836 != nil:
    section.add "api-version", valid_593836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593859: Call_AutoProvisioningSettingsList_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exposes the auto provisioning settings of the subscriptions
  ## 
  let valid = call_593859.validator(path, query, header, formData, body)
  let scheme = call_593859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593859.url(scheme.get, call_593859.host, call_593859.base,
                         call_593859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593859, url, valid)

proc call*(call_593930: Call_AutoProvisioningSettingsList_593647;
          subscriptionId: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## autoProvisioningSettingsList
  ## Exposes the auto provisioning settings of the subscriptions
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_593931 = newJObject()
  var query_593933 = newJObject()
  add(query_593933, "api-version", newJString(apiVersion))
  add(path_593931, "subscriptionId", newJString(subscriptionId))
  result = call_593930.call(path_593931, query_593933, nil, nil, nil)

var autoProvisioningSettingsList* = Call_AutoProvisioningSettingsList_593647(
    name: "autoProvisioningSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/autoProvisioningSettings",
    validator: validate_AutoProvisioningSettingsList_593648, base: "",
    url: url_AutoProvisioningSettingsList_593649, schemes: {Scheme.Https})
type
  Call_AutoProvisioningSettingsCreate_593982 = ref object of OpenApiRestCall_593425
proc url_AutoProvisioningSettingsCreate_593984(protocol: Scheme; host: string;
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

proc validate_AutoProvisioningSettingsCreate_593983(path: JsonNode;
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
  var valid_593985 = path.getOrDefault("settingName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "settingName", valid_593985
  var valid_593986 = path.getOrDefault("subscriptionId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "subscriptionId", valid_593986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593987 = query.getOrDefault("api-version")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_593987 != nil:
    section.add "api-version", valid_593987
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

proc call*(call_593989: Call_AutoProvisioningSettingsCreate_593982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Details of a specific setting
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_AutoProvisioningSettingsCreate_593982;
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
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  var body_593993 = newJObject()
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "settingName", newJString(settingName))
  add(path_593991, "subscriptionId", newJString(subscriptionId))
  if setting != nil:
    body_593993 = setting
  result = call_593990.call(path_593991, query_593992, nil, nil, body_593993)

var autoProvisioningSettingsCreate* = Call_AutoProvisioningSettingsCreate_593982(
    name: "autoProvisioningSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/autoProvisioningSettings/{settingName}",
    validator: validate_AutoProvisioningSettingsCreate_593983, base: "",
    url: url_AutoProvisioningSettingsCreate_593984, schemes: {Scheme.Https})
type
  Call_AutoProvisioningSettingsGet_593972 = ref object of OpenApiRestCall_593425
proc url_AutoProvisioningSettingsGet_593974(protocol: Scheme; host: string;
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

proc validate_AutoProvisioningSettingsGet_593973(path: JsonNode; query: JsonNode;
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
  var valid_593975 = path.getOrDefault("settingName")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "settingName", valid_593975
  var valid_593976 = path.getOrDefault("subscriptionId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "subscriptionId", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_593977 != nil:
    section.add "api-version", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_AutoProvisioningSettingsGet_593972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Details of a specific setting
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_AutoProvisioningSettingsGet_593972;
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
  var path_593980 = newJObject()
  var query_593981 = newJObject()
  add(query_593981, "api-version", newJString(apiVersion))
  add(path_593980, "settingName", newJString(settingName))
  add(path_593980, "subscriptionId", newJString(subscriptionId))
  result = call_593979.call(path_593980, query_593981, nil, nil, nil)

var autoProvisioningSettingsGet* = Call_AutoProvisioningSettingsGet_593972(
    name: "autoProvisioningSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/autoProvisioningSettings/{settingName}",
    validator: validate_AutoProvisioningSettingsGet_593973, base: "",
    url: url_AutoProvisioningSettingsGet_593974, schemes: {Scheme.Https})
type
  Call_PricingsList_593994 = ref object of OpenApiRestCall_593425
proc url_PricingsList_593996(protocol: Scheme; host: string; base: string;
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

proc validate_PricingsList_593995(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593997 = path.getOrDefault("subscriptionId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "subscriptionId", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593998 = query.getOrDefault("api-version")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_593998 != nil:
    section.add "api-version", valid_593998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593999: Call_PricingsList_593994; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security pricing configurations in the subscription
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_PricingsList_593994; subscriptionId: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## pricingsList
  ## Security pricing configurations in the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  add(query_594002, "api-version", newJString(apiVersion))
  add(path_594001, "subscriptionId", newJString(subscriptionId))
  result = call_594000.call(path_594001, query_594002, nil, nil, nil)

var pricingsList* = Call_PricingsList_593994(name: "pricingsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/pricings",
    validator: validate_PricingsList_593995, base: "", url: url_PricingsList_593996,
    schemes: {Scheme.Https})
type
  Call_PricingsUpdateSubscriptionPricing_594013 = ref object of OpenApiRestCall_593425
proc url_PricingsUpdateSubscriptionPricing_594015(protocol: Scheme; host: string;
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

proc validate_PricingsUpdateSubscriptionPricing_594014(path: JsonNode;
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
  var valid_594016 = path.getOrDefault("subscriptionId")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "subscriptionId", valid_594016
  var valid_594017 = path.getOrDefault("pricingName")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "pricingName", valid_594017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594018 = query.getOrDefault("api-version")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594018 != nil:
    section.add "api-version", valid_594018
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

proc call*(call_594020: Call_PricingsUpdateSubscriptionPricing_594013;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security pricing configuration in the subscription
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_PricingsUpdateSubscriptionPricing_594013;
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
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  var body_594024 = newJObject()
  if pricing != nil:
    body_594024 = pricing
  add(query_594023, "api-version", newJString(apiVersion))
  add(path_594022, "subscriptionId", newJString(subscriptionId))
  add(path_594022, "pricingName", newJString(pricingName))
  result = call_594021.call(path_594022, query_594023, nil, nil, body_594024)

var pricingsUpdateSubscriptionPricing* = Call_PricingsUpdateSubscriptionPricing_594013(
    name: "pricingsUpdateSubscriptionPricing", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/pricings/{pricingName}",
    validator: validate_PricingsUpdateSubscriptionPricing_594014, base: "",
    url: url_PricingsUpdateSubscriptionPricing_594015, schemes: {Scheme.Https})
type
  Call_PricingsGetSubscriptionPricing_594003 = ref object of OpenApiRestCall_593425
proc url_PricingsGetSubscriptionPricing_594005(protocol: Scheme; host: string;
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

proc validate_PricingsGetSubscriptionPricing_594004(path: JsonNode;
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
  var valid_594006 = path.getOrDefault("subscriptionId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "subscriptionId", valid_594006
  var valid_594007 = path.getOrDefault("pricingName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "pricingName", valid_594007
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594008 = query.getOrDefault("api-version")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594008 != nil:
    section.add "api-version", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_PricingsGetSubscriptionPricing_594003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security pricing configuration in the subscriptionSecurity pricing configuration in the subscription
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_PricingsGetSubscriptionPricing_594003;
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
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(query_594012, "api-version", newJString(apiVersion))
  add(path_594011, "subscriptionId", newJString(subscriptionId))
  add(path_594011, "pricingName", newJString(pricingName))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var pricingsGetSubscriptionPricing* = Call_PricingsGetSubscriptionPricing_594003(
    name: "pricingsGetSubscriptionPricing", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/pricings/{pricingName}",
    validator: validate_PricingsGetSubscriptionPricing_594004, base: "",
    url: url_PricingsGetSubscriptionPricing_594005, schemes: {Scheme.Https})
type
  Call_SecurityContactsList_594025 = ref object of OpenApiRestCall_593425
proc url_SecurityContactsList_594027(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityContactsList_594026(path: JsonNode; query: JsonNode;
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
  var valid_594028 = path.getOrDefault("subscriptionId")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "subscriptionId", valid_594028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594029 = query.getOrDefault("api-version")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594029 != nil:
    section.add "api-version", valid_594029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594030: Call_SecurityContactsList_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security contact configurations for the subscription
  ## 
  let valid = call_594030.validator(path, query, header, formData, body)
  let scheme = call_594030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594030.url(scheme.get, call_594030.host, call_594030.base,
                         call_594030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594030, url, valid)

proc call*(call_594031: Call_SecurityContactsList_594025; subscriptionId: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## securityContactsList
  ## Security contact configurations for the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594032 = newJObject()
  var query_594033 = newJObject()
  add(query_594033, "api-version", newJString(apiVersion))
  add(path_594032, "subscriptionId", newJString(subscriptionId))
  result = call_594031.call(path_594032, query_594033, nil, nil, nil)

var securityContactsList* = Call_SecurityContactsList_594025(
    name: "securityContactsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/securityContacts",
    validator: validate_SecurityContactsList_594026, base: "",
    url: url_SecurityContactsList_594027, schemes: {Scheme.Https})
type
  Call_SecurityContactsCreate_594044 = ref object of OpenApiRestCall_593425
proc url_SecurityContactsCreate_594046(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityContactsCreate_594045(path: JsonNode; query: JsonNode;
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
  var valid_594047 = path.getOrDefault("subscriptionId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "subscriptionId", valid_594047
  var valid_594048 = path.getOrDefault("securityContactName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "securityContactName", valid_594048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594049 = query.getOrDefault("api-version")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594049 != nil:
    section.add "api-version", valid_594049
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

proc call*(call_594051: Call_SecurityContactsCreate_594044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security contact configurations for the subscription
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_SecurityContactsCreate_594044; subscriptionId: string;
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
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  var body_594055 = newJObject()
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  add(path_594053, "securityContactName", newJString(securityContactName))
  if securityContact != nil:
    body_594055 = securityContact
  result = call_594052.call(path_594053, query_594054, nil, nil, body_594055)

var securityContactsCreate* = Call_SecurityContactsCreate_594044(
    name: "securityContactsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/securityContacts/{securityContactName}",
    validator: validate_SecurityContactsCreate_594045, base: "",
    url: url_SecurityContactsCreate_594046, schemes: {Scheme.Https})
type
  Call_SecurityContactsGet_594034 = ref object of OpenApiRestCall_593425
proc url_SecurityContactsGet_594036(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityContactsGet_594035(path: JsonNode; query: JsonNode;
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
  var valid_594037 = path.getOrDefault("subscriptionId")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "subscriptionId", valid_594037
  var valid_594038 = path.getOrDefault("securityContactName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "securityContactName", valid_594038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594039 = query.getOrDefault("api-version")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594039 != nil:
    section.add "api-version", valid_594039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_SecurityContactsGet_594034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security contact configurations for the subscription
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_SecurityContactsGet_594034; subscriptionId: string;
          securityContactName: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## securityContactsGet
  ## Security contact configurations for the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   securityContactName: string (required)
  ##                      : Name of the security contact object
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  add(query_594043, "api-version", newJString(apiVersion))
  add(path_594042, "subscriptionId", newJString(subscriptionId))
  add(path_594042, "securityContactName", newJString(securityContactName))
  result = call_594041.call(path_594042, query_594043, nil, nil, nil)

var securityContactsGet* = Call_SecurityContactsGet_594034(
    name: "securityContactsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/securityContacts/{securityContactName}",
    validator: validate_SecurityContactsGet_594035, base: "",
    url: url_SecurityContactsGet_594036, schemes: {Scheme.Https})
type
  Call_SecurityContactsUpdate_594066 = ref object of OpenApiRestCall_593425
proc url_SecurityContactsUpdate_594068(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityContactsUpdate_594067(path: JsonNode; query: JsonNode;
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
  var valid_594069 = path.getOrDefault("subscriptionId")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "subscriptionId", valid_594069
  var valid_594070 = path.getOrDefault("securityContactName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "securityContactName", valid_594070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594071 = query.getOrDefault("api-version")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594071 != nil:
    section.add "api-version", valid_594071
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

proc call*(call_594073: Call_SecurityContactsUpdate_594066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security contact configurations for the subscription
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_SecurityContactsUpdate_594066; subscriptionId: string;
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
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  var body_594077 = newJObject()
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  add(path_594075, "securityContactName", newJString(securityContactName))
  if securityContact != nil:
    body_594077 = securityContact
  result = call_594074.call(path_594075, query_594076, nil, nil, body_594077)

var securityContactsUpdate* = Call_SecurityContactsUpdate_594066(
    name: "securityContactsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/securityContacts/{securityContactName}",
    validator: validate_SecurityContactsUpdate_594067, base: "",
    url: url_SecurityContactsUpdate_594068, schemes: {Scheme.Https})
type
  Call_SecurityContactsDelete_594056 = ref object of OpenApiRestCall_593425
proc url_SecurityContactsDelete_594058(protocol: Scheme; host: string; base: string;
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

proc validate_SecurityContactsDelete_594057(path: JsonNode; query: JsonNode;
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
  var valid_594059 = path.getOrDefault("subscriptionId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "subscriptionId", valid_594059
  var valid_594060 = path.getOrDefault("securityContactName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "securityContactName", valid_594060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594061 = query.getOrDefault("api-version")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594061 != nil:
    section.add "api-version", valid_594061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594062: Call_SecurityContactsDelete_594056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security contact configurations for the subscription
  ## 
  let valid = call_594062.validator(path, query, header, formData, body)
  let scheme = call_594062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594062.url(scheme.get, call_594062.host, call_594062.base,
                         call_594062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594062, url, valid)

proc call*(call_594063: Call_SecurityContactsDelete_594056; subscriptionId: string;
          securityContactName: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## securityContactsDelete
  ## Security contact configurations for the subscription
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   securityContactName: string (required)
  ##                      : Name of the security contact object
  var path_594064 = newJObject()
  var query_594065 = newJObject()
  add(query_594065, "api-version", newJString(apiVersion))
  add(path_594064, "subscriptionId", newJString(subscriptionId))
  add(path_594064, "securityContactName", newJString(securityContactName))
  result = call_594063.call(path_594064, query_594065, nil, nil, nil)

var securityContactsDelete* = Call_SecurityContactsDelete_594056(
    name: "securityContactsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/securityContacts/{securityContactName}",
    validator: validate_SecurityContactsDelete_594057, base: "",
    url: url_SecurityContactsDelete_594058, schemes: {Scheme.Https})
type
  Call_SettingsList_594078 = ref object of OpenApiRestCall_593425
proc url_SettingsList_594080(protocol: Scheme; host: string; base: string;
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

proc validate_SettingsList_594079(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594081 = path.getOrDefault("subscriptionId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "subscriptionId", valid_594081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594082 = query.getOrDefault("api-version")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594082 != nil:
    section.add "api-version", valid_594082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594083: Call_SettingsList_594078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Settings about different configurations in security center
  ## 
  let valid = call_594083.validator(path, query, header, formData, body)
  let scheme = call_594083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594083.url(scheme.get, call_594083.host, call_594083.base,
                         call_594083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594083, url, valid)

proc call*(call_594084: Call_SettingsList_594078; subscriptionId: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## settingsList
  ## Settings about different configurations in security center
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594085 = newJObject()
  var query_594086 = newJObject()
  add(query_594086, "api-version", newJString(apiVersion))
  add(path_594085, "subscriptionId", newJString(subscriptionId))
  result = call_594084.call(path_594085, query_594086, nil, nil, nil)

var settingsList* = Call_SettingsList_594078(name: "settingsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/settings",
    validator: validate_SettingsList_594079, base: "", url: url_SettingsList_594080,
    schemes: {Scheme.Https})
type
  Call_SettingsUpdate_594097 = ref object of OpenApiRestCall_593425
proc url_SettingsUpdate_594099(protocol: Scheme; host: string; base: string;
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

proc validate_SettingsUpdate_594098(path: JsonNode; query: JsonNode;
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
  var valid_594100 = path.getOrDefault("settingName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = newJString("MCAS"))
  if valid_594100 != nil:
    section.add "settingName", valid_594100
  var valid_594101 = path.getOrDefault("subscriptionId")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "subscriptionId", valid_594101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594102 = query.getOrDefault("api-version")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594102 != nil:
    section.add "api-version", valid_594102
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

proc call*(call_594104: Call_SettingsUpdate_594097; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## updating settings about different configurations in security center
  ## 
  let valid = call_594104.validator(path, query, header, formData, body)
  let scheme = call_594104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594104.url(scheme.get, call_594104.host, call_594104.base,
                         call_594104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594104, url, valid)

proc call*(call_594105: Call_SettingsUpdate_594097; subscriptionId: string;
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
  var path_594106 = newJObject()
  var query_594107 = newJObject()
  var body_594108 = newJObject()
  add(query_594107, "api-version", newJString(apiVersion))
  add(path_594106, "settingName", newJString(settingName))
  add(path_594106, "subscriptionId", newJString(subscriptionId))
  if setting != nil:
    body_594108 = setting
  result = call_594105.call(path_594106, query_594107, nil, nil, body_594108)

var settingsUpdate* = Call_SettingsUpdate_594097(name: "settingsUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/settings/{settingName}",
    validator: validate_SettingsUpdate_594098, base: "", url: url_SettingsUpdate_594099,
    schemes: {Scheme.Https})
type
  Call_SettingsGet_594087 = ref object of OpenApiRestCall_593425
proc url_SettingsGet_594089(protocol: Scheme; host: string; base: string;
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

proc validate_SettingsGet_594088(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594090 = path.getOrDefault("settingName")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = newJString("MCAS"))
  if valid_594090 != nil:
    section.add "settingName", valid_594090
  var valid_594091 = path.getOrDefault("subscriptionId")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "subscriptionId", valid_594091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594092 = query.getOrDefault("api-version")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594092 != nil:
    section.add "api-version", valid_594092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594093: Call_SettingsGet_594087; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Settings of different configurations in security center
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_SettingsGet_594087; subscriptionId: string;
          apiVersion: string = "2017-08-01-preview"; settingName: string = "MCAS"): Recallable =
  ## settingsGet
  ## Settings of different configurations in security center
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingName: string (required)
  ##              : Name of setting: (MCAS/WDATP)
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  add(query_594096, "api-version", newJString(apiVersion))
  add(path_594095, "settingName", newJString(settingName))
  add(path_594095, "subscriptionId", newJString(subscriptionId))
  result = call_594094.call(path_594095, query_594096, nil, nil, nil)

var settingsGet* = Call_SettingsGet_594087(name: "settingsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/settings/{settingName}",
                                        validator: validate_SettingsGet_594088,
                                        base: "", url: url_SettingsGet_594089,
                                        schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsList_594109 = ref object of OpenApiRestCall_593425
proc url_WorkspaceSettingsList_594111(protocol: Scheme; host: string; base: string;
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

proc validate_WorkspaceSettingsList_594110(path: JsonNode; query: JsonNode;
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
  var valid_594112 = path.getOrDefault("subscriptionId")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "subscriptionId", valid_594112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594114: Call_WorkspaceSettingsList_594109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ## 
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_WorkspaceSettingsList_594109; subscriptionId: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## workspaceSettingsList
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_594116 = newJObject()
  var query_594117 = newJObject()
  add(query_594117, "api-version", newJString(apiVersion))
  add(path_594116, "subscriptionId", newJString(subscriptionId))
  result = call_594115.call(path_594116, query_594117, nil, nil, nil)

var workspaceSettingsList* = Call_WorkspaceSettingsList_594109(
    name: "workspaceSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings",
    validator: validate_WorkspaceSettingsList_594110, base: "",
    url: url_WorkspaceSettingsList_594111, schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsCreate_594128 = ref object of OpenApiRestCall_593425
proc url_WorkspaceSettingsCreate_594130(protocol: Scheme; host: string; base: string;
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

proc validate_WorkspaceSettingsCreate_594129(path: JsonNode; query: JsonNode;
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
  var valid_594131 = path.getOrDefault("subscriptionId")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "subscriptionId", valid_594131
  var valid_594132 = path.getOrDefault("workspaceSettingName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "workspaceSettingName", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594133 != nil:
    section.add "api-version", valid_594133
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

proc call*(call_594135: Call_WorkspaceSettingsCreate_594128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## creating settings about where we should store your security data and logs
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_WorkspaceSettingsCreate_594128;
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
  var path_594137 = newJObject()
  var query_594138 = newJObject()
  var body_594139 = newJObject()
  add(query_594138, "api-version", newJString(apiVersion))
  add(path_594137, "subscriptionId", newJString(subscriptionId))
  if workspaceSetting != nil:
    body_594139 = workspaceSetting
  add(path_594137, "workspaceSettingName", newJString(workspaceSettingName))
  result = call_594136.call(path_594137, query_594138, nil, nil, body_594139)

var workspaceSettingsCreate* = Call_WorkspaceSettingsCreate_594128(
    name: "workspaceSettingsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings/{workspaceSettingName}",
    validator: validate_WorkspaceSettingsCreate_594129, base: "",
    url: url_WorkspaceSettingsCreate_594130, schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsGet_594118 = ref object of OpenApiRestCall_593425
proc url_WorkspaceSettingsGet_594120(protocol: Scheme; host: string; base: string;
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

proc validate_WorkspaceSettingsGet_594119(path: JsonNode; query: JsonNode;
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
  var valid_594121 = path.getOrDefault("subscriptionId")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "subscriptionId", valid_594121
  var valid_594122 = path.getOrDefault("workspaceSettingName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "workspaceSettingName", valid_594122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594123 = query.getOrDefault("api-version")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594123 != nil:
    section.add "api-version", valid_594123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594124: Call_WorkspaceSettingsGet_594118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ## 
  let valid = call_594124.validator(path, query, header, formData, body)
  let scheme = call_594124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594124.url(scheme.get, call_594124.host, call_594124.base,
                         call_594124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594124, url, valid)

proc call*(call_594125: Call_WorkspaceSettingsGet_594118; subscriptionId: string;
          workspaceSettingName: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## workspaceSettingsGet
  ## Settings about where we should store your security data and logs. If the result is empty, it means that no custom-workspace configuration was set
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceSettingName: string (required)
  ##                       : Name of the security setting
  var path_594126 = newJObject()
  var query_594127 = newJObject()
  add(query_594127, "api-version", newJString(apiVersion))
  add(path_594126, "subscriptionId", newJString(subscriptionId))
  add(path_594126, "workspaceSettingName", newJString(workspaceSettingName))
  result = call_594125.call(path_594126, query_594127, nil, nil, nil)

var workspaceSettingsGet* = Call_WorkspaceSettingsGet_594118(
    name: "workspaceSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings/{workspaceSettingName}",
    validator: validate_WorkspaceSettingsGet_594119, base: "",
    url: url_WorkspaceSettingsGet_594120, schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsUpdate_594150 = ref object of OpenApiRestCall_593425
proc url_WorkspaceSettingsUpdate_594152(protocol: Scheme; host: string; base: string;
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

proc validate_WorkspaceSettingsUpdate_594151(path: JsonNode; query: JsonNode;
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
  var valid_594153 = path.getOrDefault("subscriptionId")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "subscriptionId", valid_594153
  var valid_594154 = path.getOrDefault("workspaceSettingName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "workspaceSettingName", valid_594154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594155 = query.getOrDefault("api-version")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594155 != nil:
    section.add "api-version", valid_594155
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

proc call*(call_594157: Call_WorkspaceSettingsUpdate_594150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Settings about where we should store your security data and logs
  ## 
  let valid = call_594157.validator(path, query, header, formData, body)
  let scheme = call_594157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594157.url(scheme.get, call_594157.host, call_594157.base,
                         call_594157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594157, url, valid)

proc call*(call_594158: Call_WorkspaceSettingsUpdate_594150;
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
  var path_594159 = newJObject()
  var query_594160 = newJObject()
  var body_594161 = newJObject()
  add(query_594160, "api-version", newJString(apiVersion))
  add(path_594159, "subscriptionId", newJString(subscriptionId))
  if workspaceSetting != nil:
    body_594161 = workspaceSetting
  add(path_594159, "workspaceSettingName", newJString(workspaceSettingName))
  result = call_594158.call(path_594159, query_594160, nil, nil, body_594161)

var workspaceSettingsUpdate* = Call_WorkspaceSettingsUpdate_594150(
    name: "workspaceSettingsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings/{workspaceSettingName}",
    validator: validate_WorkspaceSettingsUpdate_594151, base: "",
    url: url_WorkspaceSettingsUpdate_594152, schemes: {Scheme.Https})
type
  Call_WorkspaceSettingsDelete_594140 = ref object of OpenApiRestCall_593425
proc url_WorkspaceSettingsDelete_594142(protocol: Scheme; host: string; base: string;
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

proc validate_WorkspaceSettingsDelete_594141(path: JsonNode; query: JsonNode;
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
  var valid_594143 = path.getOrDefault("subscriptionId")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "subscriptionId", valid_594143
  var valid_594144 = path.getOrDefault("workspaceSettingName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "workspaceSettingName", valid_594144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594145 = query.getOrDefault("api-version")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594145 != nil:
    section.add "api-version", valid_594145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594146: Call_WorkspaceSettingsDelete_594140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the custom workspace settings for this subscription. new VMs will report to the default workspace
  ## 
  let valid = call_594146.validator(path, query, header, formData, body)
  let scheme = call_594146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594146.url(scheme.get, call_594146.host, call_594146.base,
                         call_594146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594146, url, valid)

proc call*(call_594147: Call_WorkspaceSettingsDelete_594140;
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
  var path_594148 = newJObject()
  var query_594149 = newJObject()
  add(query_594149, "api-version", newJString(apiVersion))
  add(path_594148, "subscriptionId", newJString(subscriptionId))
  add(path_594148, "workspaceSettingName", newJString(workspaceSettingName))
  result = call_594147.call(path_594148, query_594149, nil, nil, nil)

var workspaceSettingsDelete* = Call_WorkspaceSettingsDelete_594140(
    name: "workspaceSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/workspaceSettings/{workspaceSettingName}",
    validator: validate_WorkspaceSettingsDelete_594141, base: "",
    url: url_WorkspaceSettingsDelete_594142, schemes: {Scheme.Https})
type
  Call_PricingsListByResourceGroup_594162 = ref object of OpenApiRestCall_593425
proc url_PricingsListByResourceGroup_594164(protocol: Scheme; host: string;
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

proc validate_PricingsListByResourceGroup_594163(path: JsonNode; query: JsonNode;
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
  var valid_594165 = path.getOrDefault("resourceGroupName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "resourceGroupName", valid_594165
  var valid_594166 = path.getOrDefault("subscriptionId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "subscriptionId", valid_594166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594167 = query.getOrDefault("api-version")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594167 != nil:
    section.add "api-version", valid_594167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594168: Call_PricingsListByResourceGroup_594162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Security pricing configurations in the resource group
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_PricingsListByResourceGroup_594162;
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
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  add(path_594170, "resourceGroupName", newJString(resourceGroupName))
  add(query_594171, "api-version", newJString(apiVersion))
  add(path_594170, "subscriptionId", newJString(subscriptionId))
  result = call_594169.call(path_594170, query_594171, nil, nil, nil)

var pricingsListByResourceGroup* = Call_PricingsListByResourceGroup_594162(
    name: "pricingsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/pricings",
    validator: validate_PricingsListByResourceGroup_594163, base: "",
    url: url_PricingsListByResourceGroup_594164, schemes: {Scheme.Https})
type
  Call_PricingsCreateOrUpdateResourceGroupPricing_594183 = ref object of OpenApiRestCall_593425
proc url_PricingsCreateOrUpdateResourceGroupPricing_594185(protocol: Scheme;
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

proc validate_PricingsCreateOrUpdateResourceGroupPricing_594184(path: JsonNode;
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
  var valid_594186 = path.getOrDefault("resourceGroupName")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "resourceGroupName", valid_594186
  var valid_594187 = path.getOrDefault("subscriptionId")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "subscriptionId", valid_594187
  var valid_594188 = path.getOrDefault("pricingName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "pricingName", valid_594188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594189 = query.getOrDefault("api-version")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594189 != nil:
    section.add "api-version", valid_594189
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

proc call*(call_594191: Call_PricingsCreateOrUpdateResourceGroupPricing_594183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security pricing configuration in the resource group
  ## 
  let valid = call_594191.validator(path, query, header, formData, body)
  let scheme = call_594191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594191.url(scheme.get, call_594191.host, call_594191.base,
                         call_594191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594191, url, valid)

proc call*(call_594192: Call_PricingsCreateOrUpdateResourceGroupPricing_594183;
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
  var path_594193 = newJObject()
  var query_594194 = newJObject()
  var body_594195 = newJObject()
  if pricing != nil:
    body_594195 = pricing
  add(path_594193, "resourceGroupName", newJString(resourceGroupName))
  add(query_594194, "api-version", newJString(apiVersion))
  add(path_594193, "subscriptionId", newJString(subscriptionId))
  add(path_594193, "pricingName", newJString(pricingName))
  result = call_594192.call(path_594193, query_594194, nil, nil, body_594195)

var pricingsCreateOrUpdateResourceGroupPricing* = Call_PricingsCreateOrUpdateResourceGroupPricing_594183(
    name: "pricingsCreateOrUpdateResourceGroupPricing", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/pricings/{pricingName}",
    validator: validate_PricingsCreateOrUpdateResourceGroupPricing_594184,
    base: "", url: url_PricingsCreateOrUpdateResourceGroupPricing_594185,
    schemes: {Scheme.Https})
type
  Call_PricingsGetResourceGroupPricing_594172 = ref object of OpenApiRestCall_593425
proc url_PricingsGetResourceGroupPricing_594174(protocol: Scheme; host: string;
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

proc validate_PricingsGetResourceGroupPricing_594173(path: JsonNode;
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
  var valid_594175 = path.getOrDefault("resourceGroupName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "resourceGroupName", valid_594175
  var valid_594176 = path.getOrDefault("subscriptionId")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "subscriptionId", valid_594176
  var valid_594177 = path.getOrDefault("pricingName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "pricingName", valid_594177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594178 = query.getOrDefault("api-version")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594178 != nil:
    section.add "api-version", valid_594178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594179: Call_PricingsGetResourceGroupPricing_594172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Security pricing configuration in the resource group
  ## 
  let valid = call_594179.validator(path, query, header, formData, body)
  let scheme = call_594179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594179.url(scheme.get, call_594179.host, call_594179.base,
                         call_594179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594179, url, valid)

proc call*(call_594180: Call_PricingsGetResourceGroupPricing_594172;
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
  var path_594181 = newJObject()
  var query_594182 = newJObject()
  add(path_594181, "resourceGroupName", newJString(resourceGroupName))
  add(query_594182, "api-version", newJString(apiVersion))
  add(path_594181, "subscriptionId", newJString(subscriptionId))
  add(path_594181, "pricingName", newJString(pricingName))
  result = call_594180.call(path_594181, query_594182, nil, nil, nil)

var pricingsGetResourceGroupPricing* = Call_PricingsGetResourceGroupPricing_594172(
    name: "pricingsGetResourceGroupPricing", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Security/pricings/{pricingName}",
    validator: validate_PricingsGetResourceGroupPricing_594173, base: "",
    url: url_PricingsGetResourceGroupPricing_594174, schemes: {Scheme.Https})
type
  Call_AdvancedThreatProtectionCreate_594206 = ref object of OpenApiRestCall_593425
proc url_AdvancedThreatProtectionCreate_594208(protocol: Scheme; host: string;
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

proc validate_AdvancedThreatProtectionCreate_594207(path: JsonNode;
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
  var valid_594209 = path.getOrDefault("settingName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = newJString("current"))
  if valid_594209 != nil:
    section.add "settingName", valid_594209
  var valid_594210 = path.getOrDefault("resourceId")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "resourceId", valid_594210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594211 = query.getOrDefault("api-version")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594211 != nil:
    section.add "api-version", valid_594211
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

proc call*(call_594213: Call_AdvancedThreatProtectionCreate_594206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the Advanced Threat Protection settings on a specified resource.
  ## 
  let valid = call_594213.validator(path, query, header, formData, body)
  let scheme = call_594213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594213.url(scheme.get, call_594213.host, call_594213.base,
                         call_594213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594213, url, valid)

proc call*(call_594214: Call_AdvancedThreatProtectionCreate_594206;
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
  var path_594215 = newJObject()
  var query_594216 = newJObject()
  var body_594217 = newJObject()
  add(query_594216, "api-version", newJString(apiVersion))
  add(path_594215, "settingName", newJString(settingName))
  add(path_594215, "resourceId", newJString(resourceId))
  if advancedThreatProtectionSetting != nil:
    body_594217 = advancedThreatProtectionSetting
  result = call_594214.call(path_594215, query_594216, nil, nil, body_594217)

var advancedThreatProtectionCreate* = Call_AdvancedThreatProtectionCreate_594206(
    name: "advancedThreatProtectionCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/advancedThreatProtectionSettings/{settingName}",
    validator: validate_AdvancedThreatProtectionCreate_594207, base: "",
    url: url_AdvancedThreatProtectionCreate_594208, schemes: {Scheme.Https})
type
  Call_AdvancedThreatProtectionGet_594196 = ref object of OpenApiRestCall_593425
proc url_AdvancedThreatProtectionGet_594198(protocol: Scheme; host: string;
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

proc validate_AdvancedThreatProtectionGet_594197(path: JsonNode; query: JsonNode;
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
  var valid_594199 = path.getOrDefault("settingName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = newJString("current"))
  if valid_594199 != nil:
    section.add "settingName", valid_594199
  var valid_594200 = path.getOrDefault("resourceId")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "resourceId", valid_594200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594201 = query.getOrDefault("api-version")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594201 != nil:
    section.add "api-version", valid_594201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594202: Call_AdvancedThreatProtectionGet_594196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Advanced Threat Protection settings for the specified resource.
  ## 
  let valid = call_594202.validator(path, query, header, formData, body)
  let scheme = call_594202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594202.url(scheme.get, call_594202.host, call_594202.base,
                         call_594202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594202, url, valid)

proc call*(call_594203: Call_AdvancedThreatProtectionGet_594196;
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
  var path_594204 = newJObject()
  var query_594205 = newJObject()
  add(query_594205, "api-version", newJString(apiVersion))
  add(path_594204, "settingName", newJString(settingName))
  add(path_594204, "resourceId", newJString(resourceId))
  result = call_594203.call(path_594204, query_594205, nil, nil, nil)

var advancedThreatProtectionGet* = Call_AdvancedThreatProtectionGet_594196(
    name: "advancedThreatProtectionGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/advancedThreatProtectionSettings/{settingName}",
    validator: validate_AdvancedThreatProtectionGet_594197, base: "",
    url: url_AdvancedThreatProtectionGet_594198, schemes: {Scheme.Https})
type
  Call_CompliancesList_594218 = ref object of OpenApiRestCall_593425
proc url_CompliancesList_594220(protocol: Scheme; host: string; base: string;
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

proc validate_CompliancesList_594219(path: JsonNode; query: JsonNode;
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
  var valid_594221 = path.getOrDefault("scope")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "scope", valid_594221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594222 = query.getOrDefault("api-version")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594222 != nil:
    section.add "api-version", valid_594222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594223: Call_CompliancesList_594218; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Compliance scores of the specific management group.
  ## 
  let valid = call_594223.validator(path, query, header, formData, body)
  let scheme = call_594223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594223.url(scheme.get, call_594223.host, call_594223.base,
                         call_594223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594223, url, valid)

proc call*(call_594224: Call_CompliancesList_594218; scope: string;
          apiVersion: string = "2017-08-01-preview"): Recallable =
  ## compliancesList
  ## The Compliance scores of the specific management group.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_594225 = newJObject()
  var query_594226 = newJObject()
  add(query_594226, "api-version", newJString(apiVersion))
  add(path_594225, "scope", newJString(scope))
  result = call_594224.call(path_594225, query_594226, nil, nil, nil)

var compliancesList* = Call_CompliancesList_594218(name: "compliancesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Security/compliances",
    validator: validate_CompliancesList_594219, base: "", url: url_CompliancesList_594220,
    schemes: {Scheme.Https})
type
  Call_CompliancesGet_594227 = ref object of OpenApiRestCall_593425
proc url_CompliancesGet_594229(protocol: Scheme; host: string; base: string;
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

proc validate_CompliancesGet_594228(path: JsonNode; query: JsonNode;
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
  var valid_594230 = path.getOrDefault("complianceName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "complianceName", valid_594230
  var valid_594231 = path.getOrDefault("scope")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "scope", valid_594231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594232 = query.getOrDefault("api-version")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594232 != nil:
    section.add "api-version", valid_594232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594233: Call_CompliancesGet_594227; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Details of a specific Compliance.
  ## 
  let valid = call_594233.validator(path, query, header, formData, body)
  let scheme = call_594233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594233.url(scheme.get, call_594233.host, call_594233.base,
                         call_594233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594233, url, valid)

proc call*(call_594234: Call_CompliancesGet_594227; complianceName: string;
          scope: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## compliancesGet
  ## Details of a specific Compliance.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   complianceName: string (required)
  ##                 : name of the Compliance
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_594235 = newJObject()
  var query_594236 = newJObject()
  add(query_594236, "api-version", newJString(apiVersion))
  add(path_594235, "complianceName", newJString(complianceName))
  add(path_594235, "scope", newJString(scope))
  result = call_594234.call(path_594235, query_594236, nil, nil, nil)

var compliancesGet* = Call_CompliancesGet_594227(name: "compliancesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/compliances/{complianceName}",
    validator: validate_CompliancesGet_594228, base: "", url: url_CompliancesGet_594229,
    schemes: {Scheme.Https})
type
  Call_InformationProtectionPoliciesList_594237 = ref object of OpenApiRestCall_593425
proc url_InformationProtectionPoliciesList_594239(protocol: Scheme; host: string;
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

proc validate_InformationProtectionPoliciesList_594238(path: JsonNode;
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
  var valid_594240 = path.getOrDefault("scope")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "scope", valid_594240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594241 = query.getOrDefault("api-version")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594241 != nil:
    section.add "api-version", valid_594241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594242: Call_InformationProtectionPoliciesList_594237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Information protection policies of a specific management group.
  ## 
  let valid = call_594242.validator(path, query, header, formData, body)
  let scheme = call_594242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594242.url(scheme.get, call_594242.host, call_594242.base,
                         call_594242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594242, url, valid)

proc call*(call_594243: Call_InformationProtectionPoliciesList_594237;
          scope: string; apiVersion: string = "2017-08-01-preview"): Recallable =
  ## informationProtectionPoliciesList
  ## Information protection policies of a specific management group.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_594244 = newJObject()
  var query_594245 = newJObject()
  add(query_594245, "api-version", newJString(apiVersion))
  add(path_594244, "scope", newJString(scope))
  result = call_594243.call(path_594244, query_594245, nil, nil, nil)

var informationProtectionPoliciesList* = Call_InformationProtectionPoliciesList_594237(
    name: "informationProtectionPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/informationProtectionPolicies",
    validator: validate_InformationProtectionPoliciesList_594238, base: "",
    url: url_InformationProtectionPoliciesList_594239, schemes: {Scheme.Https})
type
  Call_InformationProtectionPoliciesCreateOrUpdate_594256 = ref object of OpenApiRestCall_593425
proc url_InformationProtectionPoliciesCreateOrUpdate_594258(protocol: Scheme;
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

proc validate_InformationProtectionPoliciesCreateOrUpdate_594257(path: JsonNode;
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
  var valid_594259 = path.getOrDefault("informationProtectionPolicyName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = newJString("effective"))
  if valid_594259 != nil:
    section.add "informationProtectionPolicyName", valid_594259
  var valid_594260 = path.getOrDefault("scope")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "scope", valid_594260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594261 = query.getOrDefault("api-version")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594261 != nil:
    section.add "api-version", valid_594261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594262: Call_InformationProtectionPoliciesCreateOrUpdate_594256;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Details of the information protection policy.
  ## 
  let valid = call_594262.validator(path, query, header, formData, body)
  let scheme = call_594262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594262.url(scheme.get, call_594262.host, call_594262.base,
                         call_594262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594262, url, valid)

proc call*(call_594263: Call_InformationProtectionPoliciesCreateOrUpdate_594256;
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
  var path_594264 = newJObject()
  var query_594265 = newJObject()
  add(path_594264, "informationProtectionPolicyName",
      newJString(informationProtectionPolicyName))
  add(query_594265, "api-version", newJString(apiVersion))
  add(path_594264, "scope", newJString(scope))
  result = call_594263.call(path_594264, query_594265, nil, nil, nil)

var informationProtectionPoliciesCreateOrUpdate* = Call_InformationProtectionPoliciesCreateOrUpdate_594256(
    name: "informationProtectionPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/informationProtectionPolicies/{informationProtectionPolicyName}",
    validator: validate_InformationProtectionPoliciesCreateOrUpdate_594257,
    base: "", url: url_InformationProtectionPoliciesCreateOrUpdate_594258,
    schemes: {Scheme.Https})
type
  Call_InformationProtectionPoliciesGet_594246 = ref object of OpenApiRestCall_593425
proc url_InformationProtectionPoliciesGet_594248(protocol: Scheme; host: string;
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

proc validate_InformationProtectionPoliciesGet_594247(path: JsonNode;
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
  var valid_594249 = path.getOrDefault("informationProtectionPolicyName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = newJString("effective"))
  if valid_594249 != nil:
    section.add "informationProtectionPolicyName", valid_594249
  var valid_594250 = path.getOrDefault("scope")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "scope", valid_594250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594251 = query.getOrDefault("api-version")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = newJString("2017-08-01-preview"))
  if valid_594251 != nil:
    section.add "api-version", valid_594251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594252: Call_InformationProtectionPoliciesGet_594246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Details of the information protection policy.
  ## 
  let valid = call_594252.validator(path, query, header, formData, body)
  let scheme = call_594252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594252.url(scheme.get, call_594252.host, call_594252.base,
                         call_594252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594252, url, valid)

proc call*(call_594253: Call_InformationProtectionPoliciesGet_594246;
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
  var path_594254 = newJObject()
  var query_594255 = newJObject()
  add(path_594254, "informationProtectionPolicyName",
      newJString(informationProtectionPolicyName))
  add(query_594255, "api-version", newJString(apiVersion))
  add(path_594254, "scope", newJString(scope))
  result = call_594253.call(path_594254, query_594255, nil, nil, nil)

var informationProtectionPoliciesGet* = Call_InformationProtectionPoliciesGet_594246(
    name: "informationProtectionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/informationProtectionPolicies/{informationProtectionPolicyName}",
    validator: validate_InformationProtectionPoliciesGet_594247, base: "",
    url: url_InformationProtectionPoliciesGet_594248, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
