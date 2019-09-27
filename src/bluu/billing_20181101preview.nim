
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BillingManagementClient
## version: 2018-11-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Billing client provides access to billing resources for Azure subscriptions.
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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "billing"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BillingAccountsList_593660 = ref object of OpenApiRestCall_593438
proc url_BillingAccountsList_593662(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BillingAccountsList_593661(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists all billing accounts for which a user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections and billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  var valid_593823 = query.getOrDefault("$expand")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "$expand", valid_593823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593846: Call_BillingAccountsList_593660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all billing accounts for which a user has access.
  ## 
  let valid = call_593846.validator(path, query, header, formData, body)
  let scheme = call_593846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593846.url(scheme.get, call_593846.host, call_593846.base,
                         call_593846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593846, url, valid)

proc call*(call_593917: Call_BillingAccountsList_593660; apiVersion: string;
          Expand: string = ""): Recallable =
  ## billingAccountsList
  ## Lists all billing accounts for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections and billingProfiles.
  var query_593918 = newJObject()
  add(query_593918, "api-version", newJString(apiVersion))
  add(query_593918, "$expand", newJString(Expand))
  result = call_593917.call(nil, query_593918, nil, nil, nil)

var billingAccountsList* = Call_BillingAccountsList_593660(
    name: "billingAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/billingAccounts",
    validator: validate_BillingAccountsList_593661, base: "",
    url: url_BillingAccountsList_593662, schemes: {Scheme.Https})
type
  Call_BillingAccountsGet_593958 = ref object of OpenApiRestCall_593438
proc url_BillingAccountsGet_593960(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingAccountsGet_593959(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the billing account by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_593975 = path.getOrDefault("billingAccountName")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "billingAccountName", valid_593975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections and billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  var valid_593977 = query.getOrDefault("$expand")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "$expand", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_BillingAccountsGet_593958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the billing account by id.
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_BillingAccountsGet_593958; apiVersion: string;
          billingAccountName: string; Expand: string = ""): Recallable =
  ## billingAccountsGet
  ## Get the billing account by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections and billingProfiles.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_593980 = newJObject()
  var query_593981 = newJObject()
  add(query_593981, "api-version", newJString(apiVersion))
  add(query_593981, "$expand", newJString(Expand))
  add(path_593980, "billingAccountName", newJString(billingAccountName))
  result = call_593979.call(path_593980, query_593981, nil, nil, nil)

var billingAccountsGet* = Call_BillingAccountsGet_593958(
    name: "billingAccountsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}",
    validator: validate_BillingAccountsGet_593959, base: "",
    url: url_BillingAccountsGet_593960, schemes: {Scheme.Https})
type
  Call_BillingAccountsUpdate_593982 = ref object of OpenApiRestCall_593438
proc url_BillingAccountsUpdate_593984(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingAccountsUpdate_593983(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594002 = path.getOrDefault("billingAccountName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "billingAccountName", valid_594002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update billing account operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594005: Call_BillingAccountsUpdate_593982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a billing account.
  ## 
  let valid = call_594005.validator(path, query, header, formData, body)
  let scheme = call_594005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594005.url(scheme.get, call_594005.host, call_594005.base,
                         call_594005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594005, url, valid)

proc call*(call_594006: Call_BillingAccountsUpdate_593982; apiVersion: string;
          billingAccountName: string; parameters: JsonNode): Recallable =
  ## billingAccountsUpdate
  ## The operation to update a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update billing account operation.
  var path_594007 = newJObject()
  var query_594008 = newJObject()
  var body_594009 = newJObject()
  add(query_594008, "api-version", newJString(apiVersion))
  add(path_594007, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_594009 = parameters
  result = call_594006.call(path_594007, query_594008, nil, nil, body_594009)

var billingAccountsUpdate* = Call_BillingAccountsUpdate_593982(
    name: "billingAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}",
    validator: validate_BillingAccountsUpdate_593983, base: "",
    url: url_BillingAccountsUpdate_593984, schemes: {Scheme.Https})
type
  Call_AgreementsListByBillingAccountName_594010 = ref object of OpenApiRestCall_593438
proc url_AgreementsListByBillingAccountName_594012(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/agreements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgreementsListByBillingAccountName_594011(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all agreements for a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594013 = path.getOrDefault("billingAccountName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "billingAccountName", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the participants.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "api-version", valid_594014
  var valid_594015 = query.getOrDefault("$expand")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "$expand", valid_594015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594016: Call_AgreementsListByBillingAccountName_594010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all agreements for a billing account.
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_AgreementsListByBillingAccountName_594010;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## agreementsListByBillingAccountName
  ## Lists all agreements for a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the participants.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  add(query_594019, "api-version", newJString(apiVersion))
  add(query_594019, "$expand", newJString(Expand))
  add(path_594018, "billingAccountName", newJString(billingAccountName))
  result = call_594017.call(path_594018, query_594019, nil, nil, nil)

var agreementsListByBillingAccountName* = Call_AgreementsListByBillingAccountName_594010(
    name: "agreementsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/agreements",
    validator: validate_AgreementsListByBillingAccountName_594011, base: "",
    url: url_AgreementsListByBillingAccountName_594012, schemes: {Scheme.Https})
type
  Call_AgreementsGet_594020 = ref object of OpenApiRestCall_593438
proc url_AgreementsGet_594022(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "agreementName" in path, "`agreementName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/agreements/"),
               (kind: VariableSegment, value: "agreementName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AgreementsGet_594021(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the agreement by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   agreementName: JString (required)
  ##                : Agreement Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594023 = path.getOrDefault("billingAccountName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "billingAccountName", valid_594023
  var valid_594024 = path.getOrDefault("agreementName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "agreementName", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the participants.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
  var valid_594026 = query.getOrDefault("$expand")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "$expand", valid_594026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_AgreementsGet_594020; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the agreement by name.
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_AgreementsGet_594020; apiVersion: string;
          billingAccountName: string; agreementName: string; Expand: string = ""): Recallable =
  ## agreementsGet
  ## Get the agreement by name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the participants.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   agreementName: string (required)
  ##                : Agreement Id.
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  add(query_594030, "api-version", newJString(apiVersion))
  add(query_594030, "$expand", newJString(Expand))
  add(path_594029, "billingAccountName", newJString(billingAccountName))
  add(path_594029, "agreementName", newJString(agreementName))
  result = call_594028.call(path_594029, query_594030, nil, nil, nil)

var agreementsGet* = Call_AgreementsGet_594020(name: "agreementsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/agreements/{agreementName}",
    validator: validate_AgreementsGet_594021, base: "", url: url_AgreementsGet_594022,
    schemes: {Scheme.Https})
type
  Call_BillingProfilesCreate_594041 = ref object of OpenApiRestCall_593438
proc url_BillingProfilesCreate_594043(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingProfilesCreate_594042(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a BillingProfile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594044 = path.getOrDefault("billingAccountName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "billingAccountName", valid_594044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594045 = query.getOrDefault("api-version")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "api-version", valid_594045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create BillingProfile operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_BillingProfilesCreate_594041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a BillingProfile.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_BillingProfilesCreate_594041; apiVersion: string;
          billingAccountName: string; parameters: JsonNode): Recallable =
  ## billingProfilesCreate
  ## The operation to create a BillingProfile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create BillingProfile operation.
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  var body_594051 = newJObject()
  add(query_594050, "api-version", newJString(apiVersion))
  add(path_594049, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_594051 = parameters
  result = call_594048.call(path_594049, query_594050, nil, nil, body_594051)

var billingProfilesCreate* = Call_BillingProfilesCreate_594041(
    name: "billingProfilesCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles",
    validator: validate_BillingProfilesCreate_594042, base: "",
    url: url_BillingProfilesCreate_594043, schemes: {Scheme.Https})
type
  Call_BillingProfilesListByBillingAccountName_594031 = ref object of OpenApiRestCall_593438
proc url_BillingProfilesListByBillingAccountName_594033(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingProfilesListByBillingAccountName_594032(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing profiles for a user which that user has access to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594034 = path.getOrDefault("billingAccountName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "billingAccountName", valid_594034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594035 = query.getOrDefault("api-version")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "api-version", valid_594035
  var valid_594036 = query.getOrDefault("$expand")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "$expand", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_BillingProfilesListByBillingAccountName_594031;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing profiles for a user which that user has access to.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_BillingProfilesListByBillingAccountName_594031;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## billingProfilesListByBillingAccountName
  ## Lists all billing profiles for a user which that user has access to.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(query_594040, "api-version", newJString(apiVersion))
  add(query_594040, "$expand", newJString(Expand))
  add(path_594039, "billingAccountName", newJString(billingAccountName))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var billingProfilesListByBillingAccountName* = Call_BillingProfilesListByBillingAccountName_594031(
    name: "billingProfilesListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles",
    validator: validate_BillingProfilesListByBillingAccountName_594032, base: "",
    url: url_BillingProfilesListByBillingAccountName_594033,
    schemes: {Scheme.Https})
type
  Call_BillingProfilesUpdate_594063 = ref object of OpenApiRestCall_593438
proc url_BillingProfilesUpdate_594065(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingProfilesUpdate_594064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a billing profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594066 = path.getOrDefault("billingAccountName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "billingAccountName", valid_594066
  var valid_594067 = path.getOrDefault("billingProfileName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "billingProfileName", valid_594067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594068 = query.getOrDefault("api-version")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "api-version", valid_594068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update billing profile operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594070: Call_BillingProfilesUpdate_594063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a billing profile.
  ## 
  let valid = call_594070.validator(path, query, header, formData, body)
  let scheme = call_594070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594070.url(scheme.get, call_594070.host, call_594070.base,
                         call_594070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594070, url, valid)

proc call*(call_594071: Call_BillingProfilesUpdate_594063; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          parameters: JsonNode): Recallable =
  ## billingProfilesUpdate
  ## The operation to update a billing profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update billing profile operation.
  var path_594072 = newJObject()
  var query_594073 = newJObject()
  var body_594074 = newJObject()
  add(query_594073, "api-version", newJString(apiVersion))
  add(path_594072, "billingAccountName", newJString(billingAccountName))
  add(path_594072, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_594074 = parameters
  result = call_594071.call(path_594072, query_594073, nil, nil, body_594074)

var billingProfilesUpdate* = Call_BillingProfilesUpdate_594063(
    name: "billingProfilesUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}",
    validator: validate_BillingProfilesUpdate_594064, base: "",
    url: url_BillingProfilesUpdate_594065, schemes: {Scheme.Https})
type
  Call_BillingProfilesGet_594052 = ref object of OpenApiRestCall_593438
proc url_BillingProfilesGet_594054(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingProfilesGet_594053(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the billing profile by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594055 = path.getOrDefault("billingAccountName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "billingAccountName", valid_594055
  var valid_594056 = path.getOrDefault("billingProfileName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "billingProfileName", valid_594056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the invoiceSections.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594057 = query.getOrDefault("api-version")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "api-version", valid_594057
  var valid_594058 = query.getOrDefault("$expand")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "$expand", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_BillingProfilesGet_594052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the billing profile by id.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_BillingProfilesGet_594052; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          Expand: string = ""): Recallable =
  ## billingProfilesGet
  ## Get the billing profile by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the invoiceSections.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  add(query_594062, "api-version", newJString(apiVersion))
  add(query_594062, "$expand", newJString(Expand))
  add(path_594061, "billingAccountName", newJString(billingAccountName))
  add(path_594061, "billingProfileName", newJString(billingProfileName))
  result = call_594060.call(path_594061, query_594062, nil, nil, nil)

var billingProfilesGet* = Call_BillingProfilesGet_594052(
    name: "billingProfilesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}",
    validator: validate_BillingProfilesGet_594053, base: "",
    url: url_BillingProfilesGet_594054, schemes: {Scheme.Https})
type
  Call_AvailableBalancesGetByBillingProfile_594075 = ref object of OpenApiRestCall_593438
proc url_AvailableBalancesGetByBillingProfile_594077(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/availableBalance/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailableBalancesGetByBillingProfile_594076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The latest available credit balance for a given billingAccountName and billingProfileName.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594078 = path.getOrDefault("billingAccountName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "billingAccountName", valid_594078
  var valid_594079 = path.getOrDefault("billingProfileName")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "billingProfileName", valid_594079
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594080 = query.getOrDefault("api-version")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "api-version", valid_594080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594081: Call_AvailableBalancesGetByBillingProfile_594075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The latest available credit balance for a given billingAccountName and billingProfileName.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_AvailableBalancesGetByBillingProfile_594075;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## availableBalancesGetByBillingProfile
  ## The latest available credit balance for a given billingAccountName and billingProfileName.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  add(query_594084, "api-version", newJString(apiVersion))
  add(path_594083, "billingAccountName", newJString(billingAccountName))
  add(path_594083, "billingProfileName", newJString(billingProfileName))
  result = call_594082.call(path_594083, query_594084, nil, nil, nil)

var availableBalancesGetByBillingProfile* = Call_AvailableBalancesGetByBillingProfile_594075(
    name: "availableBalancesGetByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/availableBalance/default",
    validator: validate_AvailableBalancesGetByBillingProfile_594076, base: "",
    url: url_AvailableBalancesGetByBillingProfile_594077, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByBillingProfileName_594085 = ref object of OpenApiRestCall_593438
proc url_BillingSubscriptionsListByBillingProfileName_594087(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/billingSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsListByBillingProfileName_594086(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists billing subscriptions by billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594088 = path.getOrDefault("billingAccountName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "billingAccountName", valid_594088
  var valid_594089 = path.getOrDefault("billingProfileName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "billingProfileName", valid_594089
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594090 = query.getOrDefault("api-version")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "api-version", valid_594090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594091: Call_BillingSubscriptionsListByBillingProfileName_594085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscriptions by billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_BillingSubscriptionsListByBillingProfileName_594085;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingSubscriptionsListByBillingProfileName
  ## Lists billing subscriptions by billing profile name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594093 = newJObject()
  var query_594094 = newJObject()
  add(query_594094, "api-version", newJString(apiVersion))
  add(path_594093, "billingAccountName", newJString(billingAccountName))
  add(path_594093, "billingProfileName", newJString(billingProfileName))
  result = call_594092.call(path_594093, query_594094, nil, nil, nil)

var billingSubscriptionsListByBillingProfileName* = Call_BillingSubscriptionsListByBillingProfileName_594085(
    name: "billingSubscriptionsListByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByBillingProfileName_594086,
    base: "", url: url_BillingSubscriptionsListByBillingProfileName_594087,
    schemes: {Scheme.Https})
type
  Call_InvoiceSectionsListByBillingProfileName_594095 = ref object of OpenApiRestCall_593438
proc url_InvoiceSectionsListByBillingProfileName_594097(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoiceSections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsListByBillingProfileName_594096(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all invoice sections under a billing profile for which a user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594098 = path.getOrDefault("billingAccountName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "billingAccountName", valid_594098
  var valid_594099 = path.getOrDefault("billingProfileName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "billingProfileName", valid_594099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "api-version", valid_594100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_InvoiceSectionsListByBillingProfileName_594095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all invoice sections under a billing profile for which a user has access.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_InvoiceSectionsListByBillingProfileName_594095;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## invoiceSectionsListByBillingProfileName
  ## Lists all invoice sections under a billing profile for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  add(query_594104, "api-version", newJString(apiVersion))
  add(path_594103, "billingAccountName", newJString(billingAccountName))
  add(path_594103, "billingProfileName", newJString(billingProfileName))
  result = call_594102.call(path_594103, query_594104, nil, nil, nil)

var invoiceSectionsListByBillingProfileName* = Call_InvoiceSectionsListByBillingProfileName_594095(
    name: "invoiceSectionsListByBillingProfileName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoiceSections",
    validator: validate_InvoiceSectionsListByBillingProfileName_594096, base: "",
    url: url_InvoiceSectionsListByBillingProfileName_594097,
    schemes: {Scheme.Https})
type
  Call_InvoicesListByBillingProfile_594105 = ref object of OpenApiRestCall_593438
proc url_InvoicesListByBillingProfile_594107(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoicesListByBillingProfile_594106(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of invoices for a billing profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594108 = path.getOrDefault("billingAccountName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "billingAccountName", valid_594108
  var valid_594109 = path.getOrDefault("billingProfileName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "billingProfileName", valid_594109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   periodEndDate: JString (required)
  ##                : Invoice period end date.
  ##   periodStartDate: JString (required)
  ##                  : Invoice period start date.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594110 = query.getOrDefault("api-version")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "api-version", valid_594110
  var valid_594111 = query.getOrDefault("periodEndDate")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "periodEndDate", valid_594111
  var valid_594112 = query.getOrDefault("periodStartDate")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "periodStartDate", valid_594112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594113: Call_InvoicesListByBillingProfile_594105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of invoices for a billing profile.
  ## 
  let valid = call_594113.validator(path, query, header, formData, body)
  let scheme = call_594113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594113.url(scheme.get, call_594113.host, call_594113.base,
                         call_594113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594113, url, valid)

proc call*(call_594114: Call_InvoicesListByBillingProfile_594105;
          apiVersion: string; billingAccountName: string; periodEndDate: string;
          periodStartDate: string; billingProfileName: string): Recallable =
  ## invoicesListByBillingProfile
  ## List of invoices for a billing profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   periodEndDate: string (required)
  ##                : Invoice period end date.
  ##   periodStartDate: string (required)
  ##                  : Invoice period start date.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594115 = newJObject()
  var query_594116 = newJObject()
  add(query_594116, "api-version", newJString(apiVersion))
  add(path_594115, "billingAccountName", newJString(billingAccountName))
  add(query_594116, "periodEndDate", newJString(periodEndDate))
  add(query_594116, "periodStartDate", newJString(periodStartDate))
  add(path_594115, "billingProfileName", newJString(billingProfileName))
  result = call_594114.call(path_594115, query_594116, nil, nil, nil)

var invoicesListByBillingProfile* = Call_InvoicesListByBillingProfile_594105(
    name: "invoicesListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoices",
    validator: validate_InvoicesListByBillingProfile_594106, base: "",
    url: url_InvoicesListByBillingProfile_594107, schemes: {Scheme.Https})
type
  Call_InvoicesGet_594117 = ref object of OpenApiRestCall_593438
proc url_InvoicesGet_594119(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "invoiceName" in path, "`invoiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/invoices/"),
               (kind: VariableSegment, value: "invoiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoicesGet_594118(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the invoice by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceName: JString (required)
  ##              : Invoice Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594120 = path.getOrDefault("billingAccountName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "billingAccountName", valid_594120
  var valid_594121 = path.getOrDefault("invoiceName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "invoiceName", valid_594121
  var valid_594122 = path.getOrDefault("billingProfileName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "billingProfileName", valid_594122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594123 = query.getOrDefault("api-version")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "api-version", valid_594123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594124: Call_InvoicesGet_594117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the invoice by name.
  ## 
  let valid = call_594124.validator(path, query, header, formData, body)
  let scheme = call_594124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594124.url(scheme.get, call_594124.host, call_594124.base,
                         call_594124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594124, url, valid)

proc call*(call_594125: Call_InvoicesGet_594117; apiVersion: string;
          billingAccountName: string; invoiceName: string;
          billingProfileName: string): Recallable =
  ## invoicesGet
  ## Get the invoice by name.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceName: string (required)
  ##              : Invoice Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594126 = newJObject()
  var query_594127 = newJObject()
  add(query_594127, "api-version", newJString(apiVersion))
  add(path_594126, "billingAccountName", newJString(billingAccountName))
  add(path_594126, "invoiceName", newJString(invoiceName))
  add(path_594126, "billingProfileName", newJString(billingProfileName))
  result = call_594125.call(path_594126, query_594127, nil, nil, nil)

var invoicesGet* = Call_InvoicesGet_594117(name: "invoicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/invoices/{invoiceName}",
                                        validator: validate_InvoicesGet_594118,
                                        base: "", url: url_InvoicesGet_594119,
                                        schemes: {Scheme.Https})
type
  Call_PaymentMethodsListByBillingProfileName_594128 = ref object of OpenApiRestCall_593438
proc url_PaymentMethodsListByBillingProfileName_594130(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/paymentMethods")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PaymentMethodsListByBillingProfileName_594129(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Payment Methods by billing profile Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594131 = path.getOrDefault("billingAccountName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "billingAccountName", valid_594131
  var valid_594132 = path.getOrDefault("billingProfileName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "billingProfileName", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "api-version", valid_594133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594134: Call_PaymentMethodsListByBillingProfileName_594128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Payment Methods by billing profile Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594134.validator(path, query, header, formData, body)
  let scheme = call_594134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594134.url(scheme.get, call_594134.host, call_594134.base,
                         call_594134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594134, url, valid)

proc call*(call_594135: Call_PaymentMethodsListByBillingProfileName_594128;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## paymentMethodsListByBillingProfileName
  ## Lists the Payment Methods by billing profile Id.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594136 = newJObject()
  var query_594137 = newJObject()
  add(query_594137, "api-version", newJString(apiVersion))
  add(path_594136, "billingAccountName", newJString(billingAccountName))
  add(path_594136, "billingProfileName", newJString(billingProfileName))
  result = call_594135.call(path_594136, query_594137, nil, nil, nil)

var paymentMethodsListByBillingProfileName* = Call_PaymentMethodsListByBillingProfileName_594128(
    name: "paymentMethodsListByBillingProfileName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/paymentMethods",
    validator: validate_PaymentMethodsListByBillingProfileName_594129, base: "",
    url: url_PaymentMethodsListByBillingProfileName_594130,
    schemes: {Scheme.Https})
type
  Call_PoliciesUpdate_594148 = ref object of OpenApiRestCall_593438
proc url_PoliciesUpdate_594150(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/policies/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesUpdate_594149(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The operation to update a policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594151 = path.getOrDefault("billingAccountName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "billingAccountName", valid_594151
  var valid_594152 = path.getOrDefault("billingProfileName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "billingProfileName", valid_594152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594153 = query.getOrDefault("api-version")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "api-version", valid_594153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update policy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594155: Call_PoliciesUpdate_594148; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a policy.
  ## 
  let valid = call_594155.validator(path, query, header, formData, body)
  let scheme = call_594155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594155.url(scheme.get, call_594155.host, call_594155.base,
                         call_594155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594155, url, valid)

proc call*(call_594156: Call_PoliciesUpdate_594148; apiVersion: string;
          billingAccountName: string; billingProfileName: string;
          parameters: JsonNode): Recallable =
  ## policiesUpdate
  ## The operation to update a policy.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the update policy operation.
  var path_594157 = newJObject()
  var query_594158 = newJObject()
  var body_594159 = newJObject()
  add(query_594158, "api-version", newJString(apiVersion))
  add(path_594157, "billingAccountName", newJString(billingAccountName))
  add(path_594157, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_594159 = parameters
  result = call_594156.call(path_594157, query_594158, nil, nil, body_594159)

var policiesUpdate* = Call_PoliciesUpdate_594148(name: "policiesUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/policies/default",
    validator: validate_PoliciesUpdate_594149, base: "", url: url_PoliciesUpdate_594150,
    schemes: {Scheme.Https})
type
  Call_PoliciesGetByBillingProfileName_594138 = ref object of OpenApiRestCall_593438
proc url_PoliciesGetByBillingProfileName_594140(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/policies/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PoliciesGetByBillingProfileName_594139(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The policy for a given billing account name and billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594141 = path.getOrDefault("billingAccountName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "billingAccountName", valid_594141
  var valid_594142 = path.getOrDefault("billingProfileName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "billingProfileName", valid_594142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594143 = query.getOrDefault("api-version")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "api-version", valid_594143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594144: Call_PoliciesGetByBillingProfileName_594138;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The policy for a given billing account name and billing profile name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594144.validator(path, query, header, formData, body)
  let scheme = call_594144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594144.url(scheme.get, call_594144.host, call_594144.base,
                         call_594144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594144, url, valid)

proc call*(call_594145: Call_PoliciesGetByBillingProfileName_594138;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## policiesGetByBillingProfileName
  ## The policy for a given billing account name and billing profile name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594146 = newJObject()
  var query_594147 = newJObject()
  add(query_594147, "api-version", newJString(apiVersion))
  add(path_594146, "billingAccountName", newJString(billingAccountName))
  add(path_594146, "billingProfileName", newJString(billingProfileName))
  result = call_594145.call(path_594146, query_594147, nil, nil, nil)

var policiesGetByBillingProfileName* = Call_PoliciesGetByBillingProfileName_594138(
    name: "policiesGetByBillingProfileName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/policies/default",
    validator: validate_PoliciesGetByBillingProfileName_594139, base: "",
    url: url_PoliciesGetByBillingProfileName_594140, schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByBillingProfile_594160 = ref object of OpenApiRestCall_593438
proc url_BillingPermissionsListByBillingProfile_594162(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPermissionsListByBillingProfile_594161(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billingPermissions for the caller has for a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594163 = path.getOrDefault("billingAccountName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "billingAccountName", valid_594163
  var valid_594164 = path.getOrDefault("billingProfileName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "billingProfileName", valid_594164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594165 = query.getOrDefault("api-version")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "api-version", valid_594165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594166: Call_BillingPermissionsListByBillingProfile_594160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billingPermissions for the caller has for a billing account.
  ## 
  let valid = call_594166.validator(path, query, header, formData, body)
  let scheme = call_594166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594166.url(scheme.get, call_594166.host, call_594166.base,
                         call_594166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594166, url, valid)

proc call*(call_594167: Call_BillingPermissionsListByBillingProfile_594160;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingPermissionsListByBillingProfile
  ## Lists all billingPermissions for the caller has for a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594168 = newJObject()
  var query_594169 = newJObject()
  add(query_594169, "api-version", newJString(apiVersion))
  add(path_594168, "billingAccountName", newJString(billingAccountName))
  add(path_594168, "billingProfileName", newJString(billingProfileName))
  result = call_594167.call(path_594168, query_594169, nil, nil, nil)

var billingPermissionsListByBillingProfile* = Call_BillingPermissionsListByBillingProfile_594160(
    name: "billingPermissionsListByBillingProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingPermissions",
    validator: validate_BillingPermissionsListByBillingProfile_594161, base: "",
    url: url_BillingPermissionsListByBillingProfile_594162,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByBillingProfileName_594170 = ref object of OpenApiRestCall_593438
proc url_BillingRoleAssignmentsListByBillingProfileName_594172(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsListByBillingProfileName_594171(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the role assignments on the Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594173 = path.getOrDefault("billingAccountName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "billingAccountName", valid_594173
  var valid_594174 = path.getOrDefault("billingProfileName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "billingProfileName", valid_594174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594175 = query.getOrDefault("api-version")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "api-version", valid_594175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594176: Call_BillingRoleAssignmentsListByBillingProfileName_594170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the Billing Profile
  ## 
  let valid = call_594176.validator(path, query, header, formData, body)
  let scheme = call_594176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594176.url(scheme.get, call_594176.host, call_594176.base,
                         call_594176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594176, url, valid)

proc call*(call_594177: Call_BillingRoleAssignmentsListByBillingProfileName_594170;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsListByBillingProfileName
  ## Get the role assignments on the Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594178 = newJObject()
  var query_594179 = newJObject()
  add(query_594179, "api-version", newJString(apiVersion))
  add(path_594178, "billingAccountName", newJString(billingAccountName))
  add(path_594178, "billingProfileName", newJString(billingProfileName))
  result = call_594177.call(path_594178, query_594179, nil, nil, nil)

var billingRoleAssignmentsListByBillingProfileName* = Call_BillingRoleAssignmentsListByBillingProfileName_594170(
    name: "billingRoleAssignmentsListByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByBillingProfileName_594171,
    base: "", url: url_BillingRoleAssignmentsListByBillingProfileName_594172,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByBillingProfileName_594180 = ref object of OpenApiRestCall_593438
proc url_BillingRoleAssignmentsGetByBillingProfileName_594182(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsGetByBillingProfileName_594181(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the role assignment for the caller on the Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_594183 = path.getOrDefault("billingRoleAssignmentName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "billingRoleAssignmentName", valid_594183
  var valid_594184 = path.getOrDefault("billingAccountName")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "billingAccountName", valid_594184
  var valid_594185 = path.getOrDefault("billingProfileName")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "billingProfileName", valid_594185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594186 = query.getOrDefault("api-version")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "api-version", valid_594186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594187: Call_BillingRoleAssignmentsGetByBillingProfileName_594180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller on the Billing Profile
  ## 
  let valid = call_594187.validator(path, query, header, formData, body)
  let scheme = call_594187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594187.url(scheme.get, call_594187.host, call_594187.base,
                         call_594187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594187, url, valid)

proc call*(call_594188: Call_BillingRoleAssignmentsGetByBillingProfileName_594180;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsGetByBillingProfileName
  ## Get the role assignment for the caller on the Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594189 = newJObject()
  var query_594190 = newJObject()
  add(query_594190, "api-version", newJString(apiVersion))
  add(path_594189, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_594189, "billingAccountName", newJString(billingAccountName))
  add(path_594189, "billingProfileName", newJString(billingProfileName))
  result = call_594188.call(path_594189, query_594190, nil, nil, nil)

var billingRoleAssignmentsGetByBillingProfileName* = Call_BillingRoleAssignmentsGetByBillingProfileName_594180(
    name: "billingRoleAssignmentsGetByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByBillingProfileName_594181,
    base: "", url: url_BillingRoleAssignmentsGetByBillingProfileName_594182,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByBillingProfileName_594191 = ref object of OpenApiRestCall_593438
proc url_BillingRoleAssignmentsDeleteByBillingProfileName_594193(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsDeleteByBillingProfileName_594192(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete the role assignment on this Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_594194 = path.getOrDefault("billingRoleAssignmentName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "billingRoleAssignmentName", valid_594194
  var valid_594195 = path.getOrDefault("billingAccountName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "billingAccountName", valid_594195
  var valid_594196 = path.getOrDefault("billingProfileName")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "billingProfileName", valid_594196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594197 = query.getOrDefault("api-version")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "api-version", valid_594197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594198: Call_BillingRoleAssignmentsDeleteByBillingProfileName_594191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on this Billing Profile
  ## 
  let valid = call_594198.validator(path, query, header, formData, body)
  let scheme = call_594198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594198.url(scheme.get, call_594198.host, call_594198.base,
                         call_594198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594198, url, valid)

proc call*(call_594199: Call_BillingRoleAssignmentsDeleteByBillingProfileName_594191;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleAssignmentsDeleteByBillingProfileName
  ## Delete the role assignment on this Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594200 = newJObject()
  var query_594201 = newJObject()
  add(query_594201, "api-version", newJString(apiVersion))
  add(path_594200, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_594200, "billingAccountName", newJString(billingAccountName))
  add(path_594200, "billingProfileName", newJString(billingProfileName))
  result = call_594199.call(path_594200, query_594201, nil, nil, nil)

var billingRoleAssignmentsDeleteByBillingProfileName* = Call_BillingRoleAssignmentsDeleteByBillingProfileName_594191(
    name: "billingRoleAssignmentsDeleteByBillingProfileName",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByBillingProfileName_594192,
    base: "", url: url_BillingRoleAssignmentsDeleteByBillingProfileName_594193,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByBillingProfileName_594202 = ref object of OpenApiRestCall_593438
proc url_BillingRoleDefinitionsListByBillingProfileName_594204(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsListByBillingProfileName_594203(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the role definition for a Billing Profile
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594205 = path.getOrDefault("billingAccountName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "billingAccountName", valid_594205
  var valid_594206 = path.getOrDefault("billingProfileName")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "billingProfileName", valid_594206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594207 = query.getOrDefault("api-version")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "api-version", valid_594207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594208: Call_BillingRoleDefinitionsListByBillingProfileName_594202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for a Billing Profile
  ## 
  let valid = call_594208.validator(path, query, header, formData, body)
  let scheme = call_594208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594208.url(scheme.get, call_594208.host, call_594208.base,
                         call_594208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594208, url, valid)

proc call*(call_594209: Call_BillingRoleDefinitionsListByBillingProfileName_594202;
          apiVersion: string; billingAccountName: string; billingProfileName: string): Recallable =
  ## billingRoleDefinitionsListByBillingProfileName
  ## Lists the role definition for a Billing Profile
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594210 = newJObject()
  var query_594211 = newJObject()
  add(query_594211, "api-version", newJString(apiVersion))
  add(path_594210, "billingAccountName", newJString(billingAccountName))
  add(path_594210, "billingProfileName", newJString(billingProfileName))
  result = call_594209.call(path_594210, query_594211, nil, nil, nil)

var billingRoleDefinitionsListByBillingProfileName* = Call_BillingRoleDefinitionsListByBillingProfileName_594202(
    name: "billingRoleDefinitionsListByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByBillingProfileName_594203,
    base: "", url: url_BillingRoleDefinitionsListByBillingProfileName_594204,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByBillingProfileName_594212 = ref object of OpenApiRestCall_593438
proc url_BillingRoleDefinitionsGetByBillingProfileName_594214(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  assert "billingRoleDefinitionName" in path,
        "`billingRoleDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleDefinitions/"),
               (kind: VariableSegment, value: "billingRoleDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsGetByBillingProfileName_594213(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the role definition for a role
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingRoleDefinitionName: JString (required)
  ##                            : role definition id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594215 = path.getOrDefault("billingAccountName")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "billingAccountName", valid_594215
  var valid_594216 = path.getOrDefault("billingRoleDefinitionName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "billingRoleDefinitionName", valid_594216
  var valid_594217 = path.getOrDefault("billingProfileName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "billingProfileName", valid_594217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594218 = query.getOrDefault("api-version")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "api-version", valid_594218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594219: Call_BillingRoleDefinitionsGetByBillingProfileName_594212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_BillingRoleDefinitionsGetByBillingProfileName_594212;
          apiVersion: string; billingAccountName: string;
          billingRoleDefinitionName: string; billingProfileName: string): Recallable =
  ## billingRoleDefinitionsGetByBillingProfileName
  ## Gets the role definition for a role
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingRoleDefinitionName: string (required)
  ##                            : role definition id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  add(query_594222, "api-version", newJString(apiVersion))
  add(path_594221, "billingAccountName", newJString(billingAccountName))
  add(path_594221, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  add(path_594221, "billingProfileName", newJString(billingProfileName))
  result = call_594220.call(path_594221, query_594222, nil, nil, nil)

var billingRoleDefinitionsGetByBillingProfileName* = Call_BillingRoleDefinitionsGetByBillingProfileName_594212(
    name: "billingRoleDefinitionsGetByBillingProfileName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByBillingProfileName_594213,
    base: "", url: url_BillingRoleDefinitionsGetByBillingProfileName_594214,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByBillingProfileName_594223 = ref object of OpenApiRestCall_593438
proc url_BillingRoleAssignmentsAddByBillingProfileName_594225(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/createBillingRoleAssignment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsAddByBillingProfileName_594224(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to add a role assignment to a billing profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594226 = path.getOrDefault("billingAccountName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "billingAccountName", valid_594226
  var valid_594227 = path.getOrDefault("billingProfileName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "billingProfileName", valid_594227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594228 = query.getOrDefault("api-version")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "api-version", valid_594228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594230: Call_BillingRoleAssignmentsAddByBillingProfileName_594223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a billing profile.
  ## 
  let valid = call_594230.validator(path, query, header, formData, body)
  let scheme = call_594230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594230.url(scheme.get, call_594230.host, call_594230.base,
                         call_594230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594230, url, valid)

proc call*(call_594231: Call_BillingRoleAssignmentsAddByBillingProfileName_594223;
          apiVersion: string; billingAccountName: string;
          billingProfileName: string; parameters: JsonNode): Recallable =
  ## billingRoleAssignmentsAddByBillingProfileName
  ## The operation to add a role assignment to a billing profile.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  var path_594232 = newJObject()
  var query_594233 = newJObject()
  var body_594234 = newJObject()
  add(query_594233, "api-version", newJString(apiVersion))
  add(path_594232, "billingAccountName", newJString(billingAccountName))
  add(path_594232, "billingProfileName", newJString(billingProfileName))
  if parameters != nil:
    body_594234 = parameters
  result = call_594231.call(path_594232, query_594233, nil, nil, body_594234)

var billingRoleAssignmentsAddByBillingProfileName* = Call_BillingRoleAssignmentsAddByBillingProfileName_594223(
    name: "billingRoleAssignmentsAddByBillingProfileName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/providers/Microsoft.Billing/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByBillingProfileName_594224,
    base: "", url: url_BillingRoleAssignmentsAddByBillingProfileName_594225,
    schemes: {Scheme.Https})
type
  Call_TransactionsListByBillingProfileName_594235 = ref object of OpenApiRestCall_593438
proc url_TransactionsListByBillingProfileName_594237(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingProfileName" in path,
        "`billingProfileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingProfiles/"),
               (kind: VariableSegment, value: "billingProfileName"),
               (kind: ConstantSegment, value: "/transactions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionsListByBillingProfileName_594236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transactions by billing profile name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingProfileName: JString (required)
  ##                     : Billing Profile Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594238 = path.getOrDefault("billingAccountName")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "billingAccountName", valid_594238
  var valid_594239 = path.getOrDefault("billingProfileName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "billingProfileName", valid_594239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594240 = query.getOrDefault("api-version")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "api-version", valid_594240
  var valid_594241 = query.getOrDefault("endDate")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "endDate", valid_594241
  var valid_594242 = query.getOrDefault("startDate")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "startDate", valid_594242
  var valid_594243 = query.getOrDefault("$filter")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "$filter", valid_594243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594244: Call_TransactionsListByBillingProfileName_594235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by billing profile name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594244.validator(path, query, header, formData, body)
  let scheme = call_594244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594244.url(scheme.get, call_594244.host, call_594244.base,
                         call_594244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594244, url, valid)

proc call*(call_594245: Call_TransactionsListByBillingProfileName_594235;
          apiVersion: string; endDate: string; billingAccountName: string;
          startDate: string; billingProfileName: string; Filter: string = ""): Recallable =
  ## transactionsListByBillingProfileName
  ## Lists the transactions by billing profile name for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   startDate: string (required)
  ##            : Start date
  ##   billingProfileName: string (required)
  ##                     : Billing Profile Id.
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_594246 = newJObject()
  var query_594247 = newJObject()
  add(query_594247, "api-version", newJString(apiVersion))
  add(query_594247, "endDate", newJString(endDate))
  add(path_594246, "billingAccountName", newJString(billingAccountName))
  add(query_594247, "startDate", newJString(startDate))
  add(path_594246, "billingProfileName", newJString(billingProfileName))
  add(query_594247, "$filter", newJString(Filter))
  result = call_594245.call(path_594246, query_594247, nil, nil, nil)

var transactionsListByBillingProfileName* = Call_TransactionsListByBillingProfileName_594235(
    name: "transactionsListByBillingProfileName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingProfiles/{billingProfileName}/transactions",
    validator: validate_TransactionsListByBillingProfileName_594236, base: "",
    url: url_TransactionsListByBillingProfileName_594237, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByBillingAccountName_594248 = ref object of OpenApiRestCall_593438
proc url_BillingSubscriptionsListByBillingAccountName_594250(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/billingSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsListByBillingAccountName_594249(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists billing subscriptions by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594251 = path.getOrDefault("billingAccountName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "billingAccountName", valid_594251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594252 = query.getOrDefault("api-version")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "api-version", valid_594252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594253: Call_BillingSubscriptionsListByBillingAccountName_594248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscriptions by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594253.validator(path, query, header, formData, body)
  let scheme = call_594253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594253.url(scheme.get, call_594253.host, call_594253.base,
                         call_594253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594253, url, valid)

proc call*(call_594254: Call_BillingSubscriptionsListByBillingAccountName_594248;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingSubscriptionsListByBillingAccountName
  ## Lists billing subscriptions by billing account name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_594255 = newJObject()
  var query_594256 = newJObject()
  add(query_594256, "api-version", newJString(apiVersion))
  add(path_594255, "billingAccountName", newJString(billingAccountName))
  result = call_594254.call(path_594255, query_594256, nil, nil, nil)

var billingSubscriptionsListByBillingAccountName* = Call_BillingSubscriptionsListByBillingAccountName_594248(
    name: "billingSubscriptionsListByBillingAccountName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByBillingAccountName_594249,
    base: "", url: url_BillingSubscriptionsListByBillingAccountName_594250,
    schemes: {Scheme.Https})
type
  Call_CustomersListByBillingAccountName_594257 = ref object of OpenApiRestCall_593438
proc url_CustomersListByBillingAccountName_594259(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/customers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomersListByBillingAccountName_594258(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all customers which the current user can work with on-behalf of a partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594260 = path.getOrDefault("billingAccountName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "billingAccountName", valid_594260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   $filter: JString
  ##          : May be used to filter using hasPermission('{permissionId}') to only return customers for which the caller has the specified permission.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594261 = query.getOrDefault("api-version")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "api-version", valid_594261
  var valid_594262 = query.getOrDefault("$skiptoken")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "$skiptoken", valid_594262
  var valid_594263 = query.getOrDefault("$filter")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "$filter", valid_594263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594264: Call_CustomersListByBillingAccountName_594257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all customers which the current user can work with on-behalf of a partner.
  ## 
  let valid = call_594264.validator(path, query, header, formData, body)
  let scheme = call_594264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594264.url(scheme.get, call_594264.host, call_594264.base,
                         call_594264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594264, url, valid)

proc call*(call_594265: Call_CustomersListByBillingAccountName_594257;
          apiVersion: string; billingAccountName: string; Skiptoken: string = "";
          Filter: string = ""): Recallable =
  ## customersListByBillingAccountName
  ## Lists all customers which the current user can work with on-behalf of a partner.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   Filter: string
  ##         : May be used to filter using hasPermission('{permissionId}') to only return customers for which the caller has the specified permission.
  var path_594266 = newJObject()
  var query_594267 = newJObject()
  add(query_594267, "api-version", newJString(apiVersion))
  add(path_594266, "billingAccountName", newJString(billingAccountName))
  add(query_594267, "$skiptoken", newJString(Skiptoken))
  add(query_594267, "$filter", newJString(Filter))
  result = call_594265.call(path_594266, query_594267, nil, nil, nil)

var customersListByBillingAccountName* = Call_CustomersListByBillingAccountName_594257(
    name: "customersListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers",
    validator: validate_CustomersListByBillingAccountName_594258, base: "",
    url: url_CustomersListByBillingAccountName_594259, schemes: {Scheme.Https})
type
  Call_CustomersGet_594268 = ref object of OpenApiRestCall_593438
proc url_CustomersGet_594270(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomersGet_594269(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the customer by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594271 = path.getOrDefault("billingAccountName")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "billingAccountName", valid_594271
  var valid_594272 = path.getOrDefault("customerName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "customerName", valid_594272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand enabledAzureSkus, resellers.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594273 = query.getOrDefault("api-version")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "api-version", valid_594273
  var valid_594274 = query.getOrDefault("$expand")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "$expand", valid_594274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594275: Call_CustomersGet_594268; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the customer by id.
  ## 
  let valid = call_594275.validator(path, query, header, formData, body)
  let scheme = call_594275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594275.url(scheme.get, call_594275.host, call_594275.base,
                         call_594275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594275, url, valid)

proc call*(call_594276: Call_CustomersGet_594268; apiVersion: string;
          billingAccountName: string; customerName: string; Expand: string = ""): Recallable =
  ## customersGet
  ## Get the customer by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand enabledAzureSkus, resellers.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   customerName: string (required)
  ##               : Customer Id.
  var path_594277 = newJObject()
  var query_594278 = newJObject()
  add(query_594278, "api-version", newJString(apiVersion))
  add(query_594278, "$expand", newJString(Expand))
  add(path_594277, "billingAccountName", newJString(billingAccountName))
  add(path_594277, "customerName", newJString(customerName))
  result = call_594276.call(path_594277, query_594278, nil, nil, nil)

var customersGet* = Call_CustomersGet_594268(name: "customersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}",
    validator: validate_CustomersGet_594269, base: "", url: url_CustomersGet_594270,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByCustomerName_594279 = ref object of OpenApiRestCall_593438
proc url_BillingSubscriptionsListByCustomerName_594281(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/billingSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsListByCustomerName_594280(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists billing subscription by customer name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594282 = path.getOrDefault("billingAccountName")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "billingAccountName", valid_594282
  var valid_594283 = path.getOrDefault("customerName")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "customerName", valid_594283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594284 = query.getOrDefault("api-version")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "api-version", valid_594284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594285: Call_BillingSubscriptionsListByCustomerName_594279;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscription by customer name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594285.validator(path, query, header, formData, body)
  let scheme = call_594285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594285.url(scheme.get, call_594285.host, call_594285.base,
                         call_594285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594285, url, valid)

proc call*(call_594286: Call_BillingSubscriptionsListByCustomerName_594279;
          apiVersion: string; billingAccountName: string; customerName: string): Recallable =
  ## billingSubscriptionsListByCustomerName
  ## Lists billing subscription by customer name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   customerName: string (required)
  ##               : Customer Id.
  var path_594287 = newJObject()
  var query_594288 = newJObject()
  add(query_594288, "api-version", newJString(apiVersion))
  add(path_594287, "billingAccountName", newJString(billingAccountName))
  add(path_594287, "customerName", newJString(customerName))
  result = call_594286.call(path_594287, query_594288, nil, nil, nil)

var billingSubscriptionsListByCustomerName* = Call_BillingSubscriptionsListByCustomerName_594279(
    name: "billingSubscriptionsListByCustomerName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByCustomerName_594280, base: "",
    url: url_BillingSubscriptionsListByCustomerName_594281,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsGetByCustomerName_594289 = ref object of OpenApiRestCall_593438
proc url_BillingSubscriptionsGetByCustomerName_594291(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  assert "billingSubscriptionName" in path,
        "`billingSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/billingSubscriptions/"),
               (kind: VariableSegment, value: "billingSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsGetByCustomerName_594290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  ##   customerName: JString (required)
  ##               : Customer Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594292 = path.getOrDefault("billingAccountName")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "billingAccountName", valid_594292
  var valid_594293 = path.getOrDefault("billingSubscriptionName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "billingSubscriptionName", valid_594293
  var valid_594294 = path.getOrDefault("customerName")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "customerName", valid_594294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594295 = query.getOrDefault("api-version")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "api-version", valid_594295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594296: Call_BillingSubscriptionsGetByCustomerName_594289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594296.validator(path, query, header, formData, body)
  let scheme = call_594296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594296.url(scheme.get, call_594296.host, call_594296.base,
                         call_594296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594296, url, valid)

proc call*(call_594297: Call_BillingSubscriptionsGetByCustomerName_594289;
          apiVersion: string; billingAccountName: string;
          billingSubscriptionName: string; customerName: string): Recallable =
  ## billingSubscriptionsGetByCustomerName
  ## Get a single billing subscription by name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   customerName: string (required)
  ##               : Customer Id.
  var path_594298 = newJObject()
  var query_594299 = newJObject()
  add(query_594299, "api-version", newJString(apiVersion))
  add(path_594298, "billingAccountName", newJString(billingAccountName))
  add(path_594298, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_594298, "customerName", newJString(customerName))
  result = call_594297.call(path_594298, query_594299, nil, nil, nil)

var billingSubscriptionsGetByCustomerName* = Call_BillingSubscriptionsGetByCustomerName_594289(
    name: "billingSubscriptionsGetByCustomerName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/billingSubscriptions/{billingSubscriptionName}",
    validator: validate_BillingSubscriptionsGetByCustomerName_594290, base: "",
    url: url_BillingSubscriptionsGetByCustomerName_594291, schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByCustomers_594300 = ref object of OpenApiRestCall_593438
proc url_BillingPermissionsListByCustomers_594302(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPermissionsListByCustomers_594301(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing permissions for the caller under customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594303 = path.getOrDefault("billingAccountName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "billingAccountName", valid_594303
  var valid_594304 = path.getOrDefault("customerName")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "customerName", valid_594304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594305 = query.getOrDefault("api-version")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "api-version", valid_594305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594306: Call_BillingPermissionsListByCustomers_594300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions for the caller under customer.
  ## 
  let valid = call_594306.validator(path, query, header, formData, body)
  let scheme = call_594306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594306.url(scheme.get, call_594306.host, call_594306.base,
                         call_594306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594306, url, valid)

proc call*(call_594307: Call_BillingPermissionsListByCustomers_594300;
          apiVersion: string; billingAccountName: string; customerName: string): Recallable =
  ## billingPermissionsListByCustomers
  ## Lists all billing permissions for the caller under customer.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   customerName: string (required)
  ##               : Customer Id.
  var path_594308 = newJObject()
  var query_594309 = newJObject()
  add(query_594309, "api-version", newJString(apiVersion))
  add(path_594308, "billingAccountName", newJString(billingAccountName))
  add(path_594308, "customerName", newJString(customerName))
  result = call_594307.call(path_594308, query_594309, nil, nil, nil)

var billingPermissionsListByCustomers* = Call_BillingPermissionsListByCustomers_594300(
    name: "billingPermissionsListByCustomers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/providers/Microsoft.Billing/billingPermissions",
    validator: validate_BillingPermissionsListByCustomers_594301, base: "",
    url: url_BillingPermissionsListByCustomers_594302, schemes: {Scheme.Https})
type
  Call_TransactionsListByCustomerName_594310 = ref object of OpenApiRestCall_593438
proc url_TransactionsListByCustomerName_594312(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "customerName" in path, "`customerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerName"),
               (kind: ConstantSegment, value: "/transactions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionsListByCustomerName_594311(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   customerName: JString (required)
  ##               : Customer Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594313 = path.getOrDefault("billingAccountName")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "billingAccountName", valid_594313
  var valid_594314 = path.getOrDefault("customerName")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "customerName", valid_594314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594315 = query.getOrDefault("api-version")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "api-version", valid_594315
  var valid_594316 = query.getOrDefault("endDate")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "endDate", valid_594316
  var valid_594317 = query.getOrDefault("startDate")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "startDate", valid_594317
  var valid_594318 = query.getOrDefault("$filter")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "$filter", valid_594318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594319: Call_TransactionsListByCustomerName_594310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594319.validator(path, query, header, formData, body)
  let scheme = call_594319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594319.url(scheme.get, call_594319.host, call_594319.base,
                         call_594319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594319, url, valid)

proc call*(call_594320: Call_TransactionsListByCustomerName_594310;
          apiVersion: string; endDate: string; billingAccountName: string;
          startDate: string; customerName: string; Filter: string = ""): Recallable =
  ## transactionsListByCustomerName
  ## Lists the transactions by invoice section name for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   startDate: string (required)
  ##            : Start date
  ##   customerName: string (required)
  ##               : Customer Id.
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_594321 = newJObject()
  var query_594322 = newJObject()
  add(query_594322, "api-version", newJString(apiVersion))
  add(query_594322, "endDate", newJString(endDate))
  add(path_594321, "billingAccountName", newJString(billingAccountName))
  add(query_594322, "startDate", newJString(startDate))
  add(path_594321, "customerName", newJString(customerName))
  add(query_594322, "$filter", newJString(Filter))
  result = call_594320.call(path_594321, query_594322, nil, nil, nil)

var transactionsListByCustomerName* = Call_TransactionsListByCustomerName_594310(
    name: "transactionsListByCustomerName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/customers/{customerName}/transactions",
    validator: validate_TransactionsListByCustomerName_594311, base: "",
    url: url_TransactionsListByCustomerName_594312, schemes: {Scheme.Https})
type
  Call_DepartmentsListByBillingAccountName_594323 = ref object of OpenApiRestCall_593438
proc url_DepartmentsListByBillingAccountName_594325(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/departments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DepartmentsListByBillingAccountName_594324(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all departments for which a user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594326 = path.getOrDefault("billingAccountName")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "billingAccountName", valid_594326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the enrollmentAccounts.
  ##   $filter: JString
  ##          : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594327 = query.getOrDefault("api-version")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "api-version", valid_594327
  var valid_594328 = query.getOrDefault("$expand")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "$expand", valid_594328
  var valid_594329 = query.getOrDefault("$filter")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = nil)
  if valid_594329 != nil:
    section.add "$filter", valid_594329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594330: Call_DepartmentsListByBillingAccountName_594323;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all departments for which a user has access.
  ## 
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_DepartmentsListByBillingAccountName_594323;
          apiVersion: string; billingAccountName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## departmentsListByBillingAccountName
  ## Lists all departments for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the enrollmentAccounts.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_594332 = newJObject()
  var query_594333 = newJObject()
  add(query_594333, "api-version", newJString(apiVersion))
  add(query_594333, "$expand", newJString(Expand))
  add(path_594332, "billingAccountName", newJString(billingAccountName))
  add(query_594333, "$filter", newJString(Filter))
  result = call_594331.call(path_594332, query_594333, nil, nil, nil)

var departmentsListByBillingAccountName* = Call_DepartmentsListByBillingAccountName_594323(
    name: "departmentsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/departments",
    validator: validate_DepartmentsListByBillingAccountName_594324, base: "",
    url: url_DepartmentsListByBillingAccountName_594325, schemes: {Scheme.Https})
type
  Call_DepartmentsGet_594334 = ref object of OpenApiRestCall_593438
proc url_DepartmentsGet_594336(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "departmentName" in path, "`departmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/departments/"),
               (kind: VariableSegment, value: "departmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DepartmentsGet_594335(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get the department by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   departmentName: JString (required)
  ##                 : Department Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594337 = path.getOrDefault("billingAccountName")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "billingAccountName", valid_594337
  var valid_594338 = path.getOrDefault("departmentName")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "departmentName", valid_594338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the enrollmentAccounts.
  ##   $filter: JString
  ##          : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594339 = query.getOrDefault("api-version")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "api-version", valid_594339
  var valid_594340 = query.getOrDefault("$expand")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "$expand", valid_594340
  var valid_594341 = query.getOrDefault("$filter")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "$filter", valid_594341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594342: Call_DepartmentsGet_594334; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the department by id.
  ## 
  let valid = call_594342.validator(path, query, header, formData, body)
  let scheme = call_594342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594342.url(scheme.get, call_594342.host, call_594342.base,
                         call_594342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594342, url, valid)

proc call*(call_594343: Call_DepartmentsGet_594334; apiVersion: string;
          billingAccountName: string; departmentName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## departmentsGet
  ## Get the department by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the enrollmentAccounts.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   departmentName: string (required)
  ##                 : Department Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_594344 = newJObject()
  var query_594345 = newJObject()
  add(query_594345, "api-version", newJString(apiVersion))
  add(query_594345, "$expand", newJString(Expand))
  add(path_594344, "billingAccountName", newJString(billingAccountName))
  add(path_594344, "departmentName", newJString(departmentName))
  add(query_594345, "$filter", newJString(Filter))
  result = call_594343.call(path_594344, query_594345, nil, nil, nil)

var departmentsGet* = Call_DepartmentsGet_594334(name: "departmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/departments/{departmentName}",
    validator: validate_DepartmentsGet_594335, base: "", url: url_DepartmentsGet_594336,
    schemes: {Scheme.Https})
type
  Call_EnrollmentAccountsListByBillingAccountName_594346 = ref object of OpenApiRestCall_593438
proc url_EnrollmentAccountsListByBillingAccountName_594348(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/enrollmentAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnrollmentAccountsListByBillingAccountName_594347(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Enrollment Accounts for which a user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594349 = path.getOrDefault("billingAccountName")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "billingAccountName", valid_594349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the department.
  ##   $filter: JString
  ##          : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594350 = query.getOrDefault("api-version")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "api-version", valid_594350
  var valid_594351 = query.getOrDefault("$expand")
  valid_594351 = validateParameter(valid_594351, JString, required = false,
                                 default = nil)
  if valid_594351 != nil:
    section.add "$expand", valid_594351
  var valid_594352 = query.getOrDefault("$filter")
  valid_594352 = validateParameter(valid_594352, JString, required = false,
                                 default = nil)
  if valid_594352 != nil:
    section.add "$filter", valid_594352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594353: Call_EnrollmentAccountsListByBillingAccountName_594346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Enrollment Accounts for which a user has access.
  ## 
  let valid = call_594353.validator(path, query, header, formData, body)
  let scheme = call_594353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594353.url(scheme.get, call_594353.host, call_594353.base,
                         call_594353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594353, url, valid)

proc call*(call_594354: Call_EnrollmentAccountsListByBillingAccountName_594346;
          apiVersion: string; billingAccountName: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## enrollmentAccountsListByBillingAccountName
  ## Lists all Enrollment Accounts for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the department.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_594355 = newJObject()
  var query_594356 = newJObject()
  add(query_594356, "api-version", newJString(apiVersion))
  add(query_594356, "$expand", newJString(Expand))
  add(path_594355, "billingAccountName", newJString(billingAccountName))
  add(query_594356, "$filter", newJString(Filter))
  result = call_594354.call(path_594355, query_594356, nil, nil, nil)

var enrollmentAccountsListByBillingAccountName* = Call_EnrollmentAccountsListByBillingAccountName_594346(
    name: "enrollmentAccountsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts",
    validator: validate_EnrollmentAccountsListByBillingAccountName_594347,
    base: "", url: url_EnrollmentAccountsListByBillingAccountName_594348,
    schemes: {Scheme.Https})
type
  Call_EnrollmentAccountsGetByEnrollmentAccountId_594357 = ref object of OpenApiRestCall_593438
proc url_EnrollmentAccountsGetByEnrollmentAccountId_594359(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "enrollmentAccountName" in path,
        "`enrollmentAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/enrollmentAccounts/"),
               (kind: VariableSegment, value: "enrollmentAccountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnrollmentAccountsGetByEnrollmentAccountId_594358(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the enrollment account by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   enrollmentAccountName: JString (required)
  ##                        : Enrollment Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594360 = path.getOrDefault("billingAccountName")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "billingAccountName", valid_594360
  var valid_594361 = path.getOrDefault("enrollmentAccountName")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "enrollmentAccountName", valid_594361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the Department.
  ##   $filter: JString
  ##          : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594362 = query.getOrDefault("api-version")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "api-version", valid_594362
  var valid_594363 = query.getOrDefault("$expand")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "$expand", valid_594363
  var valid_594364 = query.getOrDefault("$filter")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = nil)
  if valid_594364 != nil:
    section.add "$filter", valid_594364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594365: Call_EnrollmentAccountsGetByEnrollmentAccountId_594357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the enrollment account by id.
  ## 
  let valid = call_594365.validator(path, query, header, formData, body)
  let scheme = call_594365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594365.url(scheme.get, call_594365.host, call_594365.base,
                         call_594365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594365, url, valid)

proc call*(call_594366: Call_EnrollmentAccountsGetByEnrollmentAccountId_594357;
          apiVersion: string; billingAccountName: string;
          enrollmentAccountName: string; Expand: string = ""; Filter: string = ""): Recallable =
  ## enrollmentAccountsGetByEnrollmentAccountId
  ## Get the enrollment account by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the Department.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Filter: string
  ##         : The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  ##   enrollmentAccountName: string (required)
  ##                        : Enrollment Account Id.
  var path_594367 = newJObject()
  var query_594368 = newJObject()
  add(query_594368, "api-version", newJString(apiVersion))
  add(query_594368, "$expand", newJString(Expand))
  add(path_594367, "billingAccountName", newJString(billingAccountName))
  add(query_594368, "$filter", newJString(Filter))
  add(path_594367, "enrollmentAccountName", newJString(enrollmentAccountName))
  result = call_594366.call(path_594367, query_594368, nil, nil, nil)

var enrollmentAccountsGetByEnrollmentAccountId* = Call_EnrollmentAccountsGetByEnrollmentAccountId_594357(
    name: "enrollmentAccountsGetByEnrollmentAccountId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts/{enrollmentAccountName}",
    validator: validate_EnrollmentAccountsGetByEnrollmentAccountId_594358,
    base: "", url: url_EnrollmentAccountsGetByEnrollmentAccountId_594359,
    schemes: {Scheme.Https})
type
  Call_InvoiceSectionsCreate_594379 = ref object of OpenApiRestCall_593438
proc url_InvoiceSectionsCreate_594381(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsCreate_594380(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create a InvoiceSection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594382 = path.getOrDefault("billingAccountName")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "billingAccountName", valid_594382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594383 = query.getOrDefault("api-version")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "api-version", valid_594383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create InvoiceSection operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594385: Call_InvoiceSectionsCreate_594379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create a InvoiceSection.
  ## 
  let valid = call_594385.validator(path, query, header, formData, body)
  let scheme = call_594385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594385.url(scheme.get, call_594385.host, call_594385.base,
                         call_594385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594385, url, valid)

proc call*(call_594386: Call_InvoiceSectionsCreate_594379; apiVersion: string;
          billingAccountName: string; parameters: JsonNode): Recallable =
  ## invoiceSectionsCreate
  ## The operation to create a InvoiceSection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create InvoiceSection operation.
  var path_594387 = newJObject()
  var query_594388 = newJObject()
  var body_594389 = newJObject()
  add(query_594388, "api-version", newJString(apiVersion))
  add(path_594387, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_594389 = parameters
  result = call_594386.call(path_594387, query_594388, nil, nil, body_594389)

var invoiceSectionsCreate* = Call_InvoiceSectionsCreate_594379(
    name: "invoiceSectionsCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections",
    validator: validate_InvoiceSectionsCreate_594380, base: "",
    url: url_InvoiceSectionsCreate_594381, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsListByBillingAccountName_594369 = ref object of OpenApiRestCall_593438
proc url_InvoiceSectionsListByBillingAccountName_594371(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsListByBillingAccountName_594370(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all invoice sections for which a user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594372 = path.getOrDefault("billingAccountName")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "billingAccountName", valid_594372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594373 = query.getOrDefault("api-version")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "api-version", valid_594373
  var valid_594374 = query.getOrDefault("$expand")
  valid_594374 = validateParameter(valid_594374, JString, required = false,
                                 default = nil)
  if valid_594374 != nil:
    section.add "$expand", valid_594374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594375: Call_InvoiceSectionsListByBillingAccountName_594369;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all invoice sections for which a user has access.
  ## 
  let valid = call_594375.validator(path, query, header, formData, body)
  let scheme = call_594375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594375.url(scheme.get, call_594375.host, call_594375.base,
                         call_594375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594375, url, valid)

proc call*(call_594376: Call_InvoiceSectionsListByBillingAccountName_594369;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## invoiceSectionsListByBillingAccountName
  ## Lists all invoice sections for which a user has access.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the billingProfiles.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_594377 = newJObject()
  var query_594378 = newJObject()
  add(query_594378, "api-version", newJString(apiVersion))
  add(query_594378, "$expand", newJString(Expand))
  add(path_594377, "billingAccountName", newJString(billingAccountName))
  result = call_594376.call(path_594377, query_594378, nil, nil, nil)

var invoiceSectionsListByBillingAccountName* = Call_InvoiceSectionsListByBillingAccountName_594369(
    name: "invoiceSectionsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections",
    validator: validate_InvoiceSectionsListByBillingAccountName_594370, base: "",
    url: url_InvoiceSectionsListByBillingAccountName_594371,
    schemes: {Scheme.Https})
type
  Call_InvoiceSectionsUpdate_594401 = ref object of OpenApiRestCall_593438
proc url_InvoiceSectionsUpdate_594403(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "invoiceSectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsUpdate_594402(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a InvoiceSection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594404 = path.getOrDefault("billingAccountName")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "billingAccountName", valid_594404
  var valid_594405 = path.getOrDefault("invoiceSectionName")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "invoiceSectionName", valid_594405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594406 = query.getOrDefault("api-version")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = nil)
  if valid_594406 != nil:
    section.add "api-version", valid_594406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create InvoiceSection operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594408: Call_InvoiceSectionsUpdate_594401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a InvoiceSection.
  ## 
  let valid = call_594408.validator(path, query, header, formData, body)
  let scheme = call_594408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594408.url(scheme.get, call_594408.host, call_594408.base,
                         call_594408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594408, url, valid)

proc call*(call_594409: Call_InvoiceSectionsUpdate_594401; apiVersion: string;
          billingAccountName: string; invoiceSectionName: string;
          parameters: JsonNode): Recallable =
  ## invoiceSectionsUpdate
  ## The operation to update a InvoiceSection.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create InvoiceSection operation.
  var path_594410 = newJObject()
  var query_594411 = newJObject()
  var body_594412 = newJObject()
  add(query_594411, "api-version", newJString(apiVersion))
  add(path_594410, "billingAccountName", newJString(billingAccountName))
  add(path_594410, "invoiceSectionName", newJString(invoiceSectionName))
  if parameters != nil:
    body_594412 = parameters
  result = call_594409.call(path_594410, query_594411, nil, nil, body_594412)

var invoiceSectionsUpdate* = Call_InvoiceSectionsUpdate_594401(
    name: "invoiceSectionsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}",
    validator: validate_InvoiceSectionsUpdate_594402, base: "",
    url: url_InvoiceSectionsUpdate_594403, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsGet_594390 = ref object of OpenApiRestCall_593438
proc url_InvoiceSectionsGet_594392(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "invoiceSectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsGet_594391(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the InvoiceSection by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594393 = path.getOrDefault("billingAccountName")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "billingAccountName", valid_594393
  var valid_594394 = path.getOrDefault("invoiceSectionName")
  valid_594394 = validateParameter(valid_594394, JString, required = true,
                                 default = nil)
  if valid_594394 != nil:
    section.add "invoiceSectionName", valid_594394
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594395 = query.getOrDefault("api-version")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "api-version", valid_594395
  var valid_594396 = query.getOrDefault("$expand")
  valid_594396 = validateParameter(valid_594396, JString, required = false,
                                 default = nil)
  if valid_594396 != nil:
    section.add "$expand", valid_594396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594397: Call_InvoiceSectionsGet_594390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the InvoiceSection by id.
  ## 
  let valid = call_594397.validator(path, query, header, formData, body)
  let scheme = call_594397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594397.url(scheme.get, call_594397.host, call_594397.base,
                         call_594397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594397, url, valid)

proc call*(call_594398: Call_InvoiceSectionsGet_594390; apiVersion: string;
          billingAccountName: string; invoiceSectionName: string;
          Expand: string = ""): Recallable =
  ## invoiceSectionsGet
  ## Get the InvoiceSection by id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the billingProfiles.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_594399 = newJObject()
  var query_594400 = newJObject()
  add(query_594400, "api-version", newJString(apiVersion))
  add(query_594400, "$expand", newJString(Expand))
  add(path_594399, "billingAccountName", newJString(billingAccountName))
  add(path_594399, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_594398.call(path_594399, query_594400, nil, nil, nil)

var invoiceSectionsGet* = Call_InvoiceSectionsGet_594390(
    name: "invoiceSectionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}",
    validator: validate_InvoiceSectionsGet_594391, base: "",
    url: url_InvoiceSectionsGet_594392, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsListByInvoiceSectionName_594413 = ref object of OpenApiRestCall_593438
proc url_BillingSubscriptionsListByInvoiceSectionName_594415(protocol: Scheme;
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
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingSubscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsListByInvoiceSectionName_594414(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists billing subscription by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594416 = path.getOrDefault("billingAccountName")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "billingAccountName", valid_594416
  var valid_594417 = path.getOrDefault("invoiceSectionName")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "invoiceSectionName", valid_594417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594418 = query.getOrDefault("api-version")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "api-version", valid_594418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594419: Call_BillingSubscriptionsListByInvoiceSectionName_594413;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists billing subscription by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594419.validator(path, query, header, formData, body)
  let scheme = call_594419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594419.url(scheme.get, call_594419.host, call_594419.base,
                         call_594419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594419, url, valid)

proc call*(call_594420: Call_BillingSubscriptionsListByInvoiceSectionName_594413;
          apiVersion: string; billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingSubscriptionsListByInvoiceSectionName
  ## Lists billing subscription by invoice section name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_594421 = newJObject()
  var query_594422 = newJObject()
  add(query_594422, "api-version", newJString(apiVersion))
  add(path_594421, "billingAccountName", newJString(billingAccountName))
  add(path_594421, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_594420.call(path_594421, query_594422, nil, nil, nil)

var billingSubscriptionsListByInvoiceSectionName* = Call_BillingSubscriptionsListByInvoiceSectionName_594413(
    name: "billingSubscriptionsListByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/billingSubscriptions",
    validator: validate_BillingSubscriptionsListByInvoiceSectionName_594414,
    base: "", url: url_BillingSubscriptionsListByInvoiceSectionName_594415,
    schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsGet_594423 = ref object of OpenApiRestCall_593438
proc url_BillingSubscriptionsGet_594425(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingSubscriptionName" in path,
        "`billingSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingSubscriptions/"),
               (kind: VariableSegment, value: "billingSubscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsGet_594424(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594426 = path.getOrDefault("billingAccountName")
  valid_594426 = validateParameter(valid_594426, JString, required = true,
                                 default = nil)
  if valid_594426 != nil:
    section.add "billingAccountName", valid_594426
  var valid_594427 = path.getOrDefault("billingSubscriptionName")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "billingSubscriptionName", valid_594427
  var valid_594428 = path.getOrDefault("invoiceSectionName")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "invoiceSectionName", valid_594428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594429 = query.getOrDefault("api-version")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "api-version", valid_594429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594430: Call_BillingSubscriptionsGet_594423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single billing subscription by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594430.validator(path, query, header, formData, body)
  let scheme = call_594430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594430.url(scheme.get, call_594430.host, call_594430.base,
                         call_594430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594430, url, valid)

proc call*(call_594431: Call_BillingSubscriptionsGet_594423; apiVersion: string;
          billingAccountName: string; billingSubscriptionName: string;
          invoiceSectionName: string): Recallable =
  ## billingSubscriptionsGet
  ## Get a single billing subscription by name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_594432 = newJObject()
  var query_594433 = newJObject()
  add(query_594433, "api-version", newJString(apiVersion))
  add(path_594432, "billingAccountName", newJString(billingAccountName))
  add(path_594432, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_594432, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_594431.call(path_594432, query_594433, nil, nil, nil)

var billingSubscriptionsGet* = Call_BillingSubscriptionsGet_594423(
    name: "billingSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}",
    validator: validate_BillingSubscriptionsGet_594424, base: "",
    url: url_BillingSubscriptionsGet_594425, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsTransfer_594434 = ref object of OpenApiRestCall_593438
proc url_BillingSubscriptionsTransfer_594436(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingSubscriptionName" in path,
        "`billingSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingSubscriptions/"),
               (kind: VariableSegment, value: "billingSubscriptionName"),
               (kind: ConstantSegment, value: "/transfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsTransfer_594435(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Transfers the subscription from one invoice section to another within a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594437 = path.getOrDefault("billingAccountName")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "billingAccountName", valid_594437
  var valid_594438 = path.getOrDefault("billingSubscriptionName")
  valid_594438 = validateParameter(valid_594438, JString, required = true,
                                 default = nil)
  if valid_594438 != nil:
    section.add "billingSubscriptionName", valid_594438
  var valid_594439 = path.getOrDefault("invoiceSectionName")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "invoiceSectionName", valid_594439
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Billing Subscription operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594441: Call_BillingSubscriptionsTransfer_594434; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Transfers the subscription from one invoice section to another within a billing account.
  ## 
  let valid = call_594441.validator(path, query, header, formData, body)
  let scheme = call_594441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594441.url(scheme.get, call_594441.host, call_594441.base,
                         call_594441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594441, url, valid)

proc call*(call_594442: Call_BillingSubscriptionsTransfer_594434;
          billingAccountName: string; billingSubscriptionName: string;
          invoiceSectionName: string; parameters: JsonNode): Recallable =
  ## billingSubscriptionsTransfer
  ## Transfers the subscription from one invoice section to another within a billing account.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Billing Subscription operation.
  var path_594443 = newJObject()
  var body_594444 = newJObject()
  add(path_594443, "billingAccountName", newJString(billingAccountName))
  add(path_594443, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_594443, "invoiceSectionName", newJString(invoiceSectionName))
  if parameters != nil:
    body_594444 = parameters
  result = call_594442.call(path_594443, nil, nil, nil, body_594444)

var billingSubscriptionsTransfer* = Call_BillingSubscriptionsTransfer_594434(
    name: "billingSubscriptionsTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}/transfer",
    validator: validate_BillingSubscriptionsTransfer_594435, base: "",
    url: url_BillingSubscriptionsTransfer_594436, schemes: {Scheme.Https})
type
  Call_BillingSubscriptionsValidateTransfer_594445 = ref object of OpenApiRestCall_593438
proc url_BillingSubscriptionsValidateTransfer_594447(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingSubscriptionName" in path,
        "`billingSubscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/billingSubscriptions/"),
               (kind: VariableSegment, value: "billingSubscriptionName"),
               (kind: ConstantSegment, value: "/validateTransferEligibility")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingSubscriptionsValidateTransfer_594446(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the transfer of billing subscriptions across invoice sections.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: JString (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594448 = path.getOrDefault("billingAccountName")
  valid_594448 = validateParameter(valid_594448, JString, required = true,
                                 default = nil)
  if valid_594448 != nil:
    section.add "billingAccountName", valid_594448
  var valid_594449 = path.getOrDefault("billingSubscriptionName")
  valid_594449 = validateParameter(valid_594449, JString, required = true,
                                 default = nil)
  if valid_594449 != nil:
    section.add "billingSubscriptionName", valid_594449
  var valid_594450 = path.getOrDefault("invoiceSectionName")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "invoiceSectionName", valid_594450
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Billing Subscription operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594452: Call_BillingSubscriptionsValidateTransfer_594445;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates the transfer of billing subscriptions across invoice sections.
  ## 
  let valid = call_594452.validator(path, query, header, formData, body)
  let scheme = call_594452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594452.url(scheme.get, call_594452.host, call_594452.base,
                         call_594452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594452, url, valid)

proc call*(call_594453: Call_BillingSubscriptionsValidateTransfer_594445;
          billingAccountName: string; billingSubscriptionName: string;
          invoiceSectionName: string; parameters: JsonNode): Recallable =
  ## billingSubscriptionsValidateTransfer
  ## Validates the transfer of billing subscriptions across invoice sections.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingSubscriptionName: string (required)
  ##                          : Billing Subscription Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Billing Subscription operation.
  var path_594454 = newJObject()
  var body_594455 = newJObject()
  add(path_594454, "billingAccountName", newJString(billingAccountName))
  add(path_594454, "billingSubscriptionName", newJString(billingSubscriptionName))
  add(path_594454, "invoiceSectionName", newJString(invoiceSectionName))
  if parameters != nil:
    body_594455 = parameters
  result = call_594453.call(path_594454, nil, nil, nil, body_594455)

var billingSubscriptionsValidateTransfer* = Call_BillingSubscriptionsValidateTransfer_594445(
    name: "billingSubscriptionsValidateTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/billingSubscriptions/{billingSubscriptionName}/validateTransferEligibility",
    validator: validate_BillingSubscriptionsValidateTransfer_594446, base: "",
    url: url_BillingSubscriptionsValidateTransfer_594447, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsElevateToBillingProfile_594456 = ref object of OpenApiRestCall_593438
proc url_InvoiceSectionsElevateToBillingProfile_594458(protocol: Scheme;
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
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/elevate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsElevateToBillingProfile_594457(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Elevates the caller's access to match their billing profile access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594459 = path.getOrDefault("billingAccountName")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "billingAccountName", valid_594459
  var valid_594460 = path.getOrDefault("invoiceSectionName")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "invoiceSectionName", valid_594460
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594461: Call_InvoiceSectionsElevateToBillingProfile_594456;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Elevates the caller's access to match their billing profile access.
  ## 
  let valid = call_594461.validator(path, query, header, formData, body)
  let scheme = call_594461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594461.url(scheme.get, call_594461.host, call_594461.base,
                         call_594461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594461, url, valid)

proc call*(call_594462: Call_InvoiceSectionsElevateToBillingProfile_594456;
          billingAccountName: string; invoiceSectionName: string): Recallable =
  ## invoiceSectionsElevateToBillingProfile
  ## Elevates the caller's access to match their billing profile access.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_594463 = newJObject()
  add(path_594463, "billingAccountName", newJString(billingAccountName))
  add(path_594463, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_594462.call(path_594463, nil, nil, nil, nil)

var invoiceSectionsElevateToBillingProfile* = Call_InvoiceSectionsElevateToBillingProfile_594456(
    name: "invoiceSectionsElevateToBillingProfile", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/elevate",
    validator: validate_InvoiceSectionsElevateToBillingProfile_594457, base: "",
    url: url_InvoiceSectionsElevateToBillingProfile_594458,
    schemes: {Scheme.Https})
type
  Call_TransfersInitiate_594464 = ref object of OpenApiRestCall_593438
proc url_TransfersInitiate_594466(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/initiateTransfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransfersInitiate_594465(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594467 = path.getOrDefault("billingAccountName")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "billingAccountName", valid_594467
  var valid_594468 = path.getOrDefault("invoiceSectionName")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "invoiceSectionName", valid_594468
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Initiate transfer parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594470: Call_TransfersInitiate_594464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ## 
  let valid = call_594470.validator(path, query, header, formData, body)
  let scheme = call_594470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594470.url(scheme.get, call_594470.host, call_594470.base,
                         call_594470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594470, url, valid)

proc call*(call_594471: Call_TransfersInitiate_594464; billingAccountName: string;
          invoiceSectionName: string; body: JsonNode): Recallable =
  ## transfersInitiate
  ## Initiates the request to transfer the legacy subscriptions or RIs.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   body: JObject (required)
  ##       : Initiate transfer parameters.
  var path_594472 = newJObject()
  var body_594473 = newJObject()
  add(path_594472, "billingAccountName", newJString(billingAccountName))
  add(path_594472, "invoiceSectionName", newJString(invoiceSectionName))
  if body != nil:
    body_594473 = body
  result = call_594471.call(path_594472, nil, nil, nil, body_594473)

var transfersInitiate* = Call_TransfersInitiate_594464(name: "transfersInitiate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/initiateTransfer",
    validator: validate_TransfersInitiate_594465, base: "",
    url: url_TransfersInitiate_594466, schemes: {Scheme.Https})
type
  Call_ProductsListByInvoiceSectionName_594474 = ref object of OpenApiRestCall_593438
proc url_ProductsListByInvoiceSectionName_594476(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsListByInvoiceSectionName_594475(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists products by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594477 = path.getOrDefault("billingAccountName")
  valid_594477 = validateParameter(valid_594477, JString, required = true,
                                 default = nil)
  if valid_594477 != nil:
    section.add "billingAccountName", valid_594477
  var valid_594478 = path.getOrDefault("invoiceSectionName")
  valid_594478 = validateParameter(valid_594478, JString, required = true,
                                 default = nil)
  if valid_594478 != nil:
    section.add "invoiceSectionName", valid_594478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $filter: JString
  ##          : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594479 = query.getOrDefault("api-version")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "api-version", valid_594479
  var valid_594480 = query.getOrDefault("$filter")
  valid_594480 = validateParameter(valid_594480, JString, required = false,
                                 default = nil)
  if valid_594480 != nil:
    section.add "$filter", valid_594480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594481: Call_ProductsListByInvoiceSectionName_594474;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists products by invoice section name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594481.validator(path, query, header, formData, body)
  let scheme = call_594481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594481.url(scheme.get, call_594481.host, call_594481.base,
                         call_594481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594481, url, valid)

proc call*(call_594482: Call_ProductsListByInvoiceSectionName_594474;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; Filter: string = ""): Recallable =
  ## productsListByInvoiceSectionName
  ## Lists products by invoice section name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   Filter: string
  ##         : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_594483 = newJObject()
  var query_594484 = newJObject()
  add(query_594484, "api-version", newJString(apiVersion))
  add(path_594483, "billingAccountName", newJString(billingAccountName))
  add(path_594483, "invoiceSectionName", newJString(invoiceSectionName))
  add(query_594484, "$filter", newJString(Filter))
  result = call_594482.call(path_594483, query_594484, nil, nil, nil)

var productsListByInvoiceSectionName* = Call_ProductsListByInvoiceSectionName_594474(
    name: "productsListByInvoiceSectionName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products",
    validator: validate_ProductsListByInvoiceSectionName_594475, base: "",
    url: url_ProductsListByInvoiceSectionName_594476, schemes: {Scheme.Https})
type
  Call_ProductsGet_594485 = ref object of OpenApiRestCall_593438
proc url_ProductsGet_594487(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsGet_594486(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_594488 = path.getOrDefault("productName")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = nil)
  if valid_594488 != nil:
    section.add "productName", valid_594488
  var valid_594489 = path.getOrDefault("billingAccountName")
  valid_594489 = validateParameter(valid_594489, JString, required = true,
                                 default = nil)
  if valid_594489 != nil:
    section.add "billingAccountName", valid_594489
  var valid_594490 = path.getOrDefault("invoiceSectionName")
  valid_594490 = validateParameter(valid_594490, JString, required = true,
                                 default = nil)
  if valid_594490 != nil:
    section.add "invoiceSectionName", valid_594490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594491 = query.getOrDefault("api-version")
  valid_594491 = validateParameter(valid_594491, JString, required = true,
                                 default = nil)
  if valid_594491 != nil:
    section.add "api-version", valid_594491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594492: Call_ProductsGet_594485; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single product by name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594492.validator(path, query, header, formData, body)
  let scheme = call_594492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594492.url(scheme.get, call_594492.host, call_594492.base,
                         call_594492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594492, url, valid)

proc call*(call_594493: Call_ProductsGet_594485; productName: string;
          apiVersion: string; billingAccountName: string; invoiceSectionName: string): Recallable =
  ## productsGet
  ## Get a single product by name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_594494 = newJObject()
  var query_594495 = newJObject()
  add(path_594494, "productName", newJString(productName))
  add(query_594495, "api-version", newJString(apiVersion))
  add(path_594494, "billingAccountName", newJString(billingAccountName))
  add(path_594494, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_594493.call(path_594494, query_594495, nil, nil, nil)

var productsGet* = Call_ProductsGet_594485(name: "productsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products/{productName}",
                                        validator: validate_ProductsGet_594486,
                                        base: "", url: url_ProductsGet_594487,
                                        schemes: {Scheme.Https})
type
  Call_ProductsTransfer_594496 = ref object of OpenApiRestCall_593438
proc url_ProductsTransfer_594498(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName"),
               (kind: ConstantSegment, value: "/transfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsTransfer_594497(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The operation to transfer a Product to another invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_594499 = path.getOrDefault("productName")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "productName", valid_594499
  var valid_594500 = path.getOrDefault("billingAccountName")
  valid_594500 = validateParameter(valid_594500, JString, required = true,
                                 default = nil)
  if valid_594500 != nil:
    section.add "billingAccountName", valid_594500
  var valid_594501 = path.getOrDefault("invoiceSectionName")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "invoiceSectionName", valid_594501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594502 = query.getOrDefault("api-version")
  valid_594502 = validateParameter(valid_594502, JString, required = true,
                                 default = nil)
  if valid_594502 != nil:
    section.add "api-version", valid_594502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Product operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594504: Call_ProductsTransfer_594496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to transfer a Product to another invoice section.
  ## 
  let valid = call_594504.validator(path, query, header, formData, body)
  let scheme = call_594504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594504.url(scheme.get, call_594504.host, call_594504.base,
                         call_594504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594504, url, valid)

proc call*(call_594505: Call_ProductsTransfer_594496; productName: string;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; parameters: JsonNode): Recallable =
  ## productsTransfer
  ## The operation to transfer a Product to another invoice section.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Product operation.
  var path_594506 = newJObject()
  var query_594507 = newJObject()
  var body_594508 = newJObject()
  add(path_594506, "productName", newJString(productName))
  add(query_594507, "api-version", newJString(apiVersion))
  add(path_594506, "billingAccountName", newJString(billingAccountName))
  add(path_594506, "invoiceSectionName", newJString(invoiceSectionName))
  if parameters != nil:
    body_594508 = parameters
  result = call_594505.call(path_594506, query_594507, nil, nil, body_594508)

var productsTransfer* = Call_ProductsTransfer_594496(name: "productsTransfer",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products/{productName}/transfer",
    validator: validate_ProductsTransfer_594497, base: "",
    url: url_ProductsTransfer_594498, schemes: {Scheme.Https})
type
  Call_ProductsUpdateAutoRenewByInvoiceSectionName_594509 = ref object of OpenApiRestCall_593438
proc url_ProductsUpdateAutoRenewByInvoiceSectionName_594511(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName"),
               (kind: ConstantSegment, value: "/updateAutoRenew")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsUpdateAutoRenewByInvoiceSectionName_594510(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel auto renew for product by product id and invoice section name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_594512 = path.getOrDefault("productName")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "productName", valid_594512
  var valid_594513 = path.getOrDefault("billingAccountName")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "billingAccountName", valid_594513
  var valid_594514 = path.getOrDefault("invoiceSectionName")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "invoiceSectionName", valid_594514
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594515 = query.getOrDefault("api-version")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = nil)
  if valid_594515 != nil:
    section.add "api-version", valid_594515
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Update auto renew request parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594517: Call_ProductsUpdateAutoRenewByInvoiceSectionName_594509;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancel auto renew for product by product id and invoice section name
  ## 
  let valid = call_594517.validator(path, query, header, formData, body)
  let scheme = call_594517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594517.url(scheme.get, call_594517.host, call_594517.base,
                         call_594517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594517, url, valid)

proc call*(call_594518: Call_ProductsUpdateAutoRenewByInvoiceSectionName_594509;
          productName: string; apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; body: JsonNode): Recallable =
  ## productsUpdateAutoRenewByInvoiceSectionName
  ## Cancel auto renew for product by product id and invoice section name
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   body: JObject (required)
  ##       : Update auto renew request parameters.
  var path_594519 = newJObject()
  var query_594520 = newJObject()
  var body_594521 = newJObject()
  add(path_594519, "productName", newJString(productName))
  add(query_594520, "api-version", newJString(apiVersion))
  add(path_594519, "billingAccountName", newJString(billingAccountName))
  add(path_594519, "invoiceSectionName", newJString(invoiceSectionName))
  if body != nil:
    body_594521 = body
  result = call_594518.call(path_594519, query_594520, nil, nil, body_594521)

var productsUpdateAutoRenewByInvoiceSectionName* = Call_ProductsUpdateAutoRenewByInvoiceSectionName_594509(
    name: "productsUpdateAutoRenewByInvoiceSectionName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products/{productName}/updateAutoRenew",
    validator: validate_ProductsUpdateAutoRenewByInvoiceSectionName_594510,
    base: "", url: url_ProductsUpdateAutoRenewByInvoiceSectionName_594511,
    schemes: {Scheme.Https})
type
  Call_ProductsValidateTransfer_594522 = ref object of OpenApiRestCall_593438
proc url_ProductsValidateTransfer_594524(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName"),
               (kind: ConstantSegment, value: "/validateTransferEligibility")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsValidateTransfer_594523(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the transfer of products across invoice sections.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_594525 = path.getOrDefault("productName")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "productName", valid_594525
  var valid_594526 = path.getOrDefault("billingAccountName")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "billingAccountName", valid_594526
  var valid_594527 = path.getOrDefault("invoiceSectionName")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "invoiceSectionName", valid_594527
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Products operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594529: Call_ProductsValidateTransfer_594522; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the transfer of products across invoice sections.
  ## 
  let valid = call_594529.validator(path, query, header, formData, body)
  let scheme = call_594529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594529.url(scheme.get, call_594529.host, call_594529.base,
                         call_594529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594529, url, valid)

proc call*(call_594530: Call_ProductsValidateTransfer_594522; productName: string;
          billingAccountName: string; invoiceSectionName: string;
          parameters: JsonNode): Recallable =
  ## productsValidateTransfer
  ## Validates the transfer of products across invoice sections.
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Transfer Products operation.
  var path_594531 = newJObject()
  var body_594532 = newJObject()
  add(path_594531, "productName", newJString(productName))
  add(path_594531, "billingAccountName", newJString(billingAccountName))
  add(path_594531, "invoiceSectionName", newJString(invoiceSectionName))
  if parameters != nil:
    body_594532 = parameters
  result = call_594530.call(path_594531, nil, nil, nil, body_594532)

var productsValidateTransfer* = Call_ProductsValidateTransfer_594522(
    name: "productsValidateTransfer", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/products/{productName}/validateTransferEligibility",
    validator: validate_ProductsValidateTransfer_594523, base: "",
    url: url_ProductsValidateTransfer_594524, schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByInvoiceSections_594533 = ref object of OpenApiRestCall_593438
proc url_BillingPermissionsListByInvoiceSections_594535(protocol: Scheme;
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
        value: "/providers/Microsoft.Billing/billingPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPermissionsListByInvoiceSections_594534(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing permissions for the caller under invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594536 = path.getOrDefault("billingAccountName")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "billingAccountName", valid_594536
  var valid_594537 = path.getOrDefault("invoiceSectionName")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "invoiceSectionName", valid_594537
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594538 = query.getOrDefault("api-version")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "api-version", valid_594538
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594539: Call_BillingPermissionsListByInvoiceSections_594533;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions for the caller under invoice section.
  ## 
  let valid = call_594539.validator(path, query, header, formData, body)
  let scheme = call_594539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594539.url(scheme.get, call_594539.host, call_594539.base,
                         call_594539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594539, url, valid)

proc call*(call_594540: Call_BillingPermissionsListByInvoiceSections_594533;
          apiVersion: string; billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingPermissionsListByInvoiceSections
  ## Lists all billing permissions for the caller under invoice section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_594541 = newJObject()
  var query_594542 = newJObject()
  add(query_594542, "api-version", newJString(apiVersion))
  add(path_594541, "billingAccountName", newJString(billingAccountName))
  add(path_594541, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_594540.call(path_594541, query_594542, nil, nil, nil)

var billingPermissionsListByInvoiceSections* = Call_BillingPermissionsListByInvoiceSections_594533(
    name: "billingPermissionsListByInvoiceSections", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingPermissions",
    validator: validate_BillingPermissionsListByInvoiceSections_594534, base: "",
    url: url_BillingPermissionsListByInvoiceSections_594535,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByInvoiceSectionName_594543 = ref object of OpenApiRestCall_593438
proc url_BillingRoleAssignmentsListByInvoiceSectionName_594545(protocol: Scheme;
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
        value: "/providers/Microsoft.Billing/billingRoleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsListByInvoiceSectionName_594544(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the role assignments on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594546 = path.getOrDefault("billingAccountName")
  valid_594546 = validateParameter(valid_594546, JString, required = true,
                                 default = nil)
  if valid_594546 != nil:
    section.add "billingAccountName", valid_594546
  var valid_594547 = path.getOrDefault("invoiceSectionName")
  valid_594547 = validateParameter(valid_594547, JString, required = true,
                                 default = nil)
  if valid_594547 != nil:
    section.add "invoiceSectionName", valid_594547
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594548 = query.getOrDefault("api-version")
  valid_594548 = validateParameter(valid_594548, JString, required = true,
                                 default = nil)
  if valid_594548 != nil:
    section.add "api-version", valid_594548
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594549: Call_BillingRoleAssignmentsListByInvoiceSectionName_594543;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the invoice Section
  ## 
  let valid = call_594549.validator(path, query, header, formData, body)
  let scheme = call_594549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594549.url(scheme.get, call_594549.host, call_594549.base,
                         call_594549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594549, url, valid)

proc call*(call_594550: Call_BillingRoleAssignmentsListByInvoiceSectionName_594543;
          apiVersion: string; billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsListByInvoiceSectionName
  ## Get the role assignments on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_594551 = newJObject()
  var query_594552 = newJObject()
  add(query_594552, "api-version", newJString(apiVersion))
  add(path_594551, "billingAccountName", newJString(billingAccountName))
  add(path_594551, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_594550.call(path_594551, query_594552, nil, nil, nil)

var billingRoleAssignmentsListByInvoiceSectionName* = Call_BillingRoleAssignmentsListByInvoiceSectionName_594543(
    name: "billingRoleAssignmentsListByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByInvoiceSectionName_594544,
    base: "", url: url_BillingRoleAssignmentsListByInvoiceSectionName_594545,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByInvoiceSectionName_594553 = ref object of OpenApiRestCall_593438
proc url_BillingRoleAssignmentsGetByInvoiceSectionName_594555(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsGetByInvoiceSectionName_594554(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the role assignment for the caller on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_594556 = path.getOrDefault("billingRoleAssignmentName")
  valid_594556 = validateParameter(valid_594556, JString, required = true,
                                 default = nil)
  if valid_594556 != nil:
    section.add "billingRoleAssignmentName", valid_594556
  var valid_594557 = path.getOrDefault("billingAccountName")
  valid_594557 = validateParameter(valid_594557, JString, required = true,
                                 default = nil)
  if valid_594557 != nil:
    section.add "billingAccountName", valid_594557
  var valid_594558 = path.getOrDefault("invoiceSectionName")
  valid_594558 = validateParameter(valid_594558, JString, required = true,
                                 default = nil)
  if valid_594558 != nil:
    section.add "invoiceSectionName", valid_594558
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594559 = query.getOrDefault("api-version")
  valid_594559 = validateParameter(valid_594559, JString, required = true,
                                 default = nil)
  if valid_594559 != nil:
    section.add "api-version", valid_594559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594560: Call_BillingRoleAssignmentsGetByInvoiceSectionName_594553;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller on the invoice Section
  ## 
  let valid = call_594560.validator(path, query, header, formData, body)
  let scheme = call_594560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594560.url(scheme.get, call_594560.host, call_594560.base,
                         call_594560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594560, url, valid)

proc call*(call_594561: Call_BillingRoleAssignmentsGetByInvoiceSectionName_594553;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsGetByInvoiceSectionName
  ## Get the role assignment for the caller on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_594562 = newJObject()
  var query_594563 = newJObject()
  add(query_594563, "api-version", newJString(apiVersion))
  add(path_594562, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_594562, "billingAccountName", newJString(billingAccountName))
  add(path_594562, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_594561.call(path_594562, query_594563, nil, nil, nil)

var billingRoleAssignmentsGetByInvoiceSectionName* = Call_BillingRoleAssignmentsGetByInvoiceSectionName_594553(
    name: "billingRoleAssignmentsGetByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByInvoiceSectionName_594554,
    base: "", url: url_BillingRoleAssignmentsGetByInvoiceSectionName_594555,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByInvoiceSectionName_594564 = ref object of OpenApiRestCall_593438
proc url_BillingRoleAssignmentsDeleteByInvoiceSectionName_594566(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsDeleteByInvoiceSectionName_594565(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete the role assignment on the invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_594567 = path.getOrDefault("billingRoleAssignmentName")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "billingRoleAssignmentName", valid_594567
  var valid_594568 = path.getOrDefault("billingAccountName")
  valid_594568 = validateParameter(valid_594568, JString, required = true,
                                 default = nil)
  if valid_594568 != nil:
    section.add "billingAccountName", valid_594568
  var valid_594569 = path.getOrDefault("invoiceSectionName")
  valid_594569 = validateParameter(valid_594569, JString, required = true,
                                 default = nil)
  if valid_594569 != nil:
    section.add "invoiceSectionName", valid_594569
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594570 = query.getOrDefault("api-version")
  valid_594570 = validateParameter(valid_594570, JString, required = true,
                                 default = nil)
  if valid_594570 != nil:
    section.add "api-version", valid_594570
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594571: Call_BillingRoleAssignmentsDeleteByInvoiceSectionName_594564;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on the invoice Section
  ## 
  let valid = call_594571.validator(path, query, header, formData, body)
  let scheme = call_594571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594571.url(scheme.get, call_594571.host, call_594571.base,
                         call_594571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594571, url, valid)

proc call*(call_594572: Call_BillingRoleAssignmentsDeleteByInvoiceSectionName_594564;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingRoleAssignmentsDeleteByInvoiceSectionName
  ## Delete the role assignment on the invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_594573 = newJObject()
  var query_594574 = newJObject()
  add(query_594574, "api-version", newJString(apiVersion))
  add(path_594573, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_594573, "billingAccountName", newJString(billingAccountName))
  add(path_594573, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_594572.call(path_594573, query_594574, nil, nil, nil)

var billingRoleAssignmentsDeleteByInvoiceSectionName* = Call_BillingRoleAssignmentsDeleteByInvoiceSectionName_594564(
    name: "billingRoleAssignmentsDeleteByInvoiceSectionName",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByInvoiceSectionName_594565,
    base: "", url: url_BillingRoleAssignmentsDeleteByInvoiceSectionName_594566,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByInvoiceSectionName_594575 = ref object of OpenApiRestCall_593438
proc url_BillingRoleDefinitionsListByInvoiceSectionName_594577(protocol: Scheme;
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
        value: "/providers/Microsoft.Billing/billingRoleDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsListByInvoiceSectionName_594576(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the role definition for an invoice Section
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594578 = path.getOrDefault("billingAccountName")
  valid_594578 = validateParameter(valid_594578, JString, required = true,
                                 default = nil)
  if valid_594578 != nil:
    section.add "billingAccountName", valid_594578
  var valid_594579 = path.getOrDefault("invoiceSectionName")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "invoiceSectionName", valid_594579
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594580 = query.getOrDefault("api-version")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "api-version", valid_594580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594581: Call_BillingRoleDefinitionsListByInvoiceSectionName_594575;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for an invoice Section
  ## 
  let valid = call_594581.validator(path, query, header, formData, body)
  let scheme = call_594581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594581.url(scheme.get, call_594581.host, call_594581.base,
                         call_594581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594581, url, valid)

proc call*(call_594582: Call_BillingRoleDefinitionsListByInvoiceSectionName_594575;
          apiVersion: string; billingAccountName: string; invoiceSectionName: string): Recallable =
  ## billingRoleDefinitionsListByInvoiceSectionName
  ## Lists the role definition for an invoice Section
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_594583 = newJObject()
  var query_594584 = newJObject()
  add(query_594584, "api-version", newJString(apiVersion))
  add(path_594583, "billingAccountName", newJString(billingAccountName))
  add(path_594583, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_594582.call(path_594583, query_594584, nil, nil, nil)

var billingRoleDefinitionsListByInvoiceSectionName* = Call_BillingRoleDefinitionsListByInvoiceSectionName_594575(
    name: "billingRoleDefinitionsListByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByInvoiceSectionName_594576,
    base: "", url: url_BillingRoleDefinitionsListByInvoiceSectionName_594577,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByInvoiceSectionName_594585 = ref object of OpenApiRestCall_593438
proc url_BillingRoleDefinitionsGetByInvoiceSectionName_594587(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "billingRoleDefinitionName" in path,
        "`billingRoleDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleDefinitions/"),
               (kind: VariableSegment, value: "billingRoleDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsGetByInvoiceSectionName_594586(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the role definition for a role
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   billingRoleDefinitionName: JString (required)
  ##                            : role definition id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594588 = path.getOrDefault("billingAccountName")
  valid_594588 = validateParameter(valid_594588, JString, required = true,
                                 default = nil)
  if valid_594588 != nil:
    section.add "billingAccountName", valid_594588
  var valid_594589 = path.getOrDefault("invoiceSectionName")
  valid_594589 = validateParameter(valid_594589, JString, required = true,
                                 default = nil)
  if valid_594589 != nil:
    section.add "invoiceSectionName", valid_594589
  var valid_594590 = path.getOrDefault("billingRoleDefinitionName")
  valid_594590 = validateParameter(valid_594590, JString, required = true,
                                 default = nil)
  if valid_594590 != nil:
    section.add "billingRoleDefinitionName", valid_594590
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594591 = query.getOrDefault("api-version")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = nil)
  if valid_594591 != nil:
    section.add "api-version", valid_594591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594592: Call_BillingRoleDefinitionsGetByInvoiceSectionName_594585;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_594592.validator(path, query, header, formData, body)
  let scheme = call_594592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594592.url(scheme.get, call_594592.host, call_594592.base,
                         call_594592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594592, url, valid)

proc call*(call_594593: Call_BillingRoleDefinitionsGetByInvoiceSectionName_594585;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; billingRoleDefinitionName: string): Recallable =
  ## billingRoleDefinitionsGetByInvoiceSectionName
  ## Gets the role definition for a role
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   billingRoleDefinitionName: string (required)
  ##                            : role definition id.
  var path_594594 = newJObject()
  var query_594595 = newJObject()
  add(query_594595, "api-version", newJString(apiVersion))
  add(path_594594, "billingAccountName", newJString(billingAccountName))
  add(path_594594, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_594594, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  result = call_594593.call(path_594594, query_594595, nil, nil, nil)

var billingRoleDefinitionsGetByInvoiceSectionName* = Call_BillingRoleDefinitionsGetByInvoiceSectionName_594585(
    name: "billingRoleDefinitionsGetByInvoiceSectionName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByInvoiceSectionName_594586,
    base: "", url: url_BillingRoleDefinitionsGetByInvoiceSectionName_594587,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByInvoiceSectionName_594596 = ref object of OpenApiRestCall_593438
proc url_BillingRoleAssignmentsAddByInvoiceSectionName_594598(protocol: Scheme;
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
        value: "/providers/Microsoft.Billing/createBillingRoleAssignment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsAddByInvoiceSectionName_594597(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to add a role assignment to a invoice Section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594599 = path.getOrDefault("billingAccountName")
  valid_594599 = validateParameter(valid_594599, JString, required = true,
                                 default = nil)
  if valid_594599 != nil:
    section.add "billingAccountName", valid_594599
  var valid_594600 = path.getOrDefault("invoiceSectionName")
  valid_594600 = validateParameter(valid_594600, JString, required = true,
                                 default = nil)
  if valid_594600 != nil:
    section.add "invoiceSectionName", valid_594600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594601 = query.getOrDefault("api-version")
  valid_594601 = validateParameter(valid_594601, JString, required = true,
                                 default = nil)
  if valid_594601 != nil:
    section.add "api-version", valid_594601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594603: Call_BillingRoleAssignmentsAddByInvoiceSectionName_594596;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a invoice Section.
  ## 
  let valid = call_594603.validator(path, query, header, formData, body)
  let scheme = call_594603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594603.url(scheme.get, call_594603.host, call_594603.base,
                         call_594603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594603, url, valid)

proc call*(call_594604: Call_BillingRoleAssignmentsAddByInvoiceSectionName_594596;
          apiVersion: string; billingAccountName: string;
          invoiceSectionName: string; parameters: JsonNode): Recallable =
  ## billingRoleAssignmentsAddByInvoiceSectionName
  ## The operation to add a role assignment to a invoice Section.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  var path_594605 = newJObject()
  var query_594606 = newJObject()
  var body_594607 = newJObject()
  add(query_594606, "api-version", newJString(apiVersion))
  add(path_594605, "billingAccountName", newJString(billingAccountName))
  add(path_594605, "invoiceSectionName", newJString(invoiceSectionName))
  if parameters != nil:
    body_594607 = parameters
  result = call_594604.call(path_594605, query_594606, nil, nil, body_594607)

var billingRoleAssignmentsAddByInvoiceSectionName* = Call_BillingRoleAssignmentsAddByInvoiceSectionName_594596(
    name: "billingRoleAssignmentsAddByInvoiceSectionName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/providers/Microsoft.Billing/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByInvoiceSectionName_594597,
    base: "", url: url_BillingRoleAssignmentsAddByInvoiceSectionName_594598,
    schemes: {Scheme.Https})
type
  Call_TransactionsListByInvoiceSectionName_594608 = ref object of OpenApiRestCall_593438
proc url_TransactionsListByInvoiceSectionName_594610(protocol: Scheme;
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
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/transactions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionsListByInvoiceSectionName_594609(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594611 = path.getOrDefault("billingAccountName")
  valid_594611 = validateParameter(valid_594611, JString, required = true,
                                 default = nil)
  if valid_594611 != nil:
    section.add "billingAccountName", valid_594611
  var valid_594612 = path.getOrDefault("invoiceSectionName")
  valid_594612 = validateParameter(valid_594612, JString, required = true,
                                 default = nil)
  if valid_594612 != nil:
    section.add "invoiceSectionName", valid_594612
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594613 = query.getOrDefault("api-version")
  valid_594613 = validateParameter(valid_594613, JString, required = true,
                                 default = nil)
  if valid_594613 != nil:
    section.add "api-version", valid_594613
  var valid_594614 = query.getOrDefault("endDate")
  valid_594614 = validateParameter(valid_594614, JString, required = true,
                                 default = nil)
  if valid_594614 != nil:
    section.add "endDate", valid_594614
  var valid_594615 = query.getOrDefault("startDate")
  valid_594615 = validateParameter(valid_594615, JString, required = true,
                                 default = nil)
  if valid_594615 != nil:
    section.add "startDate", valid_594615
  var valid_594616 = query.getOrDefault("$filter")
  valid_594616 = validateParameter(valid_594616, JString, required = false,
                                 default = nil)
  if valid_594616 != nil:
    section.add "$filter", valid_594616
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594617: Call_TransactionsListByInvoiceSectionName_594608;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by invoice section name for given start date and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594617.validator(path, query, header, formData, body)
  let scheme = call_594617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594617.url(scheme.get, call_594617.host, call_594617.base,
                         call_594617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594617, url, valid)

proc call*(call_594618: Call_TransactionsListByInvoiceSectionName_594608;
          apiVersion: string; endDate: string; billingAccountName: string;
          startDate: string; invoiceSectionName: string; Filter: string = ""): Recallable =
  ## transactionsListByInvoiceSectionName
  ## Lists the transactions by invoice section name for given start date and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   startDate: string (required)
  ##            : Start date
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_594619 = newJObject()
  var query_594620 = newJObject()
  add(query_594620, "api-version", newJString(apiVersion))
  add(query_594620, "endDate", newJString(endDate))
  add(path_594619, "billingAccountName", newJString(billingAccountName))
  add(query_594620, "startDate", newJString(startDate))
  add(path_594619, "invoiceSectionName", newJString(invoiceSectionName))
  add(query_594620, "$filter", newJString(Filter))
  result = call_594618.call(path_594619, query_594620, nil, nil, nil)

var transactionsListByInvoiceSectionName* = Call_TransactionsListByInvoiceSectionName_594608(
    name: "transactionsListByInvoiceSectionName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/transactions",
    validator: validate_TransactionsListByInvoiceSectionName_594609, base: "",
    url: url_TransactionsListByInvoiceSectionName_594610, schemes: {Scheme.Https})
type
  Call_TransfersList_594621 = ref object of OpenApiRestCall_593438
proc url_TransfersList_594623(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/transfers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransfersList_594622(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all transfer's details initiated from given invoice section.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594624 = path.getOrDefault("billingAccountName")
  valid_594624 = validateParameter(valid_594624, JString, required = true,
                                 default = nil)
  if valid_594624 != nil:
    section.add "billingAccountName", valid_594624
  var valid_594625 = path.getOrDefault("invoiceSectionName")
  valid_594625 = validateParameter(valid_594625, JString, required = true,
                                 default = nil)
  if valid_594625 != nil:
    section.add "invoiceSectionName", valid_594625
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594626: Call_TransfersList_594621; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all transfer's details initiated from given invoice section.
  ## 
  let valid = call_594626.validator(path, query, header, formData, body)
  let scheme = call_594626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594626.url(scheme.get, call_594626.host, call_594626.base,
                         call_594626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594626, url, valid)

proc call*(call_594627: Call_TransfersList_594621; billingAccountName: string;
          invoiceSectionName: string): Recallable =
  ## transfersList
  ## Lists all transfer's details initiated from given invoice section.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  var path_594628 = newJObject()
  add(path_594628, "billingAccountName", newJString(billingAccountName))
  add(path_594628, "invoiceSectionName", newJString(invoiceSectionName))
  result = call_594627.call(path_594628, nil, nil, nil, nil)

var transfersList* = Call_TransfersList_594621(name: "transfersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/transfers",
    validator: validate_TransfersList_594622, base: "", url: url_TransfersList_594623,
    schemes: {Scheme.Https})
type
  Call_TransfersGet_594629 = ref object of OpenApiRestCall_593438
proc url_TransfersGet_594631(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/transfers/"),
               (kind: VariableSegment, value: "transferName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransfersGet_594630(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the transfer details for given transfer Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594632 = path.getOrDefault("billingAccountName")
  valid_594632 = validateParameter(valid_594632, JString, required = true,
                                 default = nil)
  if valid_594632 != nil:
    section.add "billingAccountName", valid_594632
  var valid_594633 = path.getOrDefault("invoiceSectionName")
  valid_594633 = validateParameter(valid_594633, JString, required = true,
                                 default = nil)
  if valid_594633 != nil:
    section.add "invoiceSectionName", valid_594633
  var valid_594634 = path.getOrDefault("transferName")
  valid_594634 = validateParameter(valid_594634, JString, required = true,
                                 default = nil)
  if valid_594634 != nil:
    section.add "transferName", valid_594634
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594635: Call_TransfersGet_594629; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the transfer details for given transfer Id.
  ## 
  let valid = call_594635.validator(path, query, header, formData, body)
  let scheme = call_594635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594635.url(scheme.get, call_594635.host, call_594635.base,
                         call_594635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594635, url, valid)

proc call*(call_594636: Call_TransfersGet_594629; billingAccountName: string;
          invoiceSectionName: string; transferName: string): Recallable =
  ## transfersGet
  ## Gets the transfer details for given transfer Id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_594637 = newJObject()
  add(path_594637, "billingAccountName", newJString(billingAccountName))
  add(path_594637, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_594637, "transferName", newJString(transferName))
  result = call_594636.call(path_594637, nil, nil, nil, nil)

var transfersGet* = Call_TransfersGet_594629(name: "transfersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/transfers/{transferName}",
    validator: validate_TransfersGet_594630, base: "", url: url_TransfersGet_594631,
    schemes: {Scheme.Https})
type
  Call_TransfersCancel_594638 = ref object of OpenApiRestCall_593438
proc url_TransfersCancel_594640(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceSectionName" in path,
        "`invoiceSectionName` is a required path parameter"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoiceSections/"),
               (kind: VariableSegment, value: "invoiceSectionName"),
               (kind: ConstantSegment, value: "/transfers/"),
               (kind: VariableSegment, value: "transferName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransfersCancel_594639(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Cancels the transfer for given transfer Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: JString (required)
  ##                     : InvoiceSection Id.
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594641 = path.getOrDefault("billingAccountName")
  valid_594641 = validateParameter(valid_594641, JString, required = true,
                                 default = nil)
  if valid_594641 != nil:
    section.add "billingAccountName", valid_594641
  var valid_594642 = path.getOrDefault("invoiceSectionName")
  valid_594642 = validateParameter(valid_594642, JString, required = true,
                                 default = nil)
  if valid_594642 != nil:
    section.add "invoiceSectionName", valid_594642
  var valid_594643 = path.getOrDefault("transferName")
  valid_594643 = validateParameter(valid_594643, JString, required = true,
                                 default = nil)
  if valid_594643 != nil:
    section.add "transferName", valid_594643
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594644: Call_TransfersCancel_594638; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the transfer for given transfer Id.
  ## 
  let valid = call_594644.validator(path, query, header, formData, body)
  let scheme = call_594644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594644.url(scheme.get, call_594644.host, call_594644.base,
                         call_594644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594644, url, valid)

proc call*(call_594645: Call_TransfersCancel_594638; billingAccountName: string;
          invoiceSectionName: string; transferName: string): Recallable =
  ## transfersCancel
  ## Cancels the transfer for given transfer Id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   invoiceSectionName: string (required)
  ##                     : InvoiceSection Id.
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_594646 = newJObject()
  add(path_594646, "billingAccountName", newJString(billingAccountName))
  add(path_594646, "invoiceSectionName", newJString(invoiceSectionName))
  add(path_594646, "transferName", newJString(transferName))
  result = call_594645.call(path_594646, nil, nil, nil, nil)

var transfersCancel* = Call_TransfersCancel_594638(name: "transfersCancel",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoiceSections/{invoiceSectionName}/transfers/{transferName}",
    validator: validate_TransfersCancel_594639, base: "", url: url_TransfersCancel_594640,
    schemes: {Scheme.Https})
type
  Call_InvoicesListByBillingAccountName_594647 = ref object of OpenApiRestCall_593438
proc url_InvoicesListByBillingAccountName_594649(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoicesListByBillingAccountName_594648(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of invoices for a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594650 = path.getOrDefault("billingAccountName")
  valid_594650 = validateParameter(valid_594650, JString, required = true,
                                 default = nil)
  if valid_594650 != nil:
    section.add "billingAccountName", valid_594650
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   periodEndDate: JString (required)
  ##                : Invoice period end date.
  ##   periodStartDate: JString (required)
  ##                  : Invoice period start date.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594651 = query.getOrDefault("api-version")
  valid_594651 = validateParameter(valid_594651, JString, required = true,
                                 default = nil)
  if valid_594651 != nil:
    section.add "api-version", valid_594651
  var valid_594652 = query.getOrDefault("periodEndDate")
  valid_594652 = validateParameter(valid_594652, JString, required = true,
                                 default = nil)
  if valid_594652 != nil:
    section.add "periodEndDate", valid_594652
  var valid_594653 = query.getOrDefault("periodStartDate")
  valid_594653 = validateParameter(valid_594653, JString, required = true,
                                 default = nil)
  if valid_594653 != nil:
    section.add "periodStartDate", valid_594653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594654: Call_InvoicesListByBillingAccountName_594647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List of invoices for a billing account.
  ## 
  let valid = call_594654.validator(path, query, header, formData, body)
  let scheme = call_594654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594654.url(scheme.get, call_594654.host, call_594654.base,
                         call_594654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594654, url, valid)

proc call*(call_594655: Call_InvoicesListByBillingAccountName_594647;
          apiVersion: string; billingAccountName: string; periodEndDate: string;
          periodStartDate: string): Recallable =
  ## invoicesListByBillingAccountName
  ## List of invoices for a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   periodEndDate: string (required)
  ##                : Invoice period end date.
  ##   periodStartDate: string (required)
  ##                  : Invoice period start date.
  var path_594656 = newJObject()
  var query_594657 = newJObject()
  add(query_594657, "api-version", newJString(apiVersion))
  add(path_594656, "billingAccountName", newJString(billingAccountName))
  add(query_594657, "periodEndDate", newJString(periodEndDate))
  add(query_594657, "periodStartDate", newJString(periodStartDate))
  result = call_594655.call(path_594656, query_594657, nil, nil, nil)

var invoicesListByBillingAccountName* = Call_InvoicesListByBillingAccountName_594647(
    name: "invoicesListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoices",
    validator: validate_InvoicesListByBillingAccountName_594648, base: "",
    url: url_InvoicesListByBillingAccountName_594649, schemes: {Scheme.Https})
type
  Call_PriceSheetDownload_594658 = ref object of OpenApiRestCall_593438
proc url_PriceSheetDownload_594660(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "invoiceName" in path, "`invoiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/invoices/"),
               (kind: VariableSegment, value: "invoiceName"),
               (kind: ConstantSegment, value: "/pricesheet/default/download")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PriceSheetDownload_594659(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Download price sheet for an invoice.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Azure Billing Account ID.
  ##   invoiceName: JString (required)
  ##              : The name of an invoice resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594661 = path.getOrDefault("billingAccountName")
  valid_594661 = validateParameter(valid_594661, JString, required = true,
                                 default = nil)
  if valid_594661 != nil:
    section.add "billingAccountName", valid_594661
  var valid_594662 = path.getOrDefault("invoiceName")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = nil)
  if valid_594662 != nil:
    section.add "invoiceName", valid_594662
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594663 = query.getOrDefault("api-version")
  valid_594663 = validateParameter(valid_594663, JString, required = true,
                                 default = nil)
  if valid_594663 != nil:
    section.add "api-version", valid_594663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594664: Call_PriceSheetDownload_594658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Download price sheet for an invoice.
  ## 
  let valid = call_594664.validator(path, query, header, formData, body)
  let scheme = call_594664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594664.url(scheme.get, call_594664.host, call_594664.base,
                         call_594664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594664, url, valid)

proc call*(call_594665: Call_PriceSheetDownload_594658; apiVersion: string;
          billingAccountName: string; invoiceName: string): Recallable =
  ## priceSheetDownload
  ## Download price sheet for an invoice.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Azure Billing Account ID.
  ##   invoiceName: string (required)
  ##              : The name of an invoice resource.
  var path_594666 = newJObject()
  var query_594667 = newJObject()
  add(query_594667, "api-version", newJString(apiVersion))
  add(path_594666, "billingAccountName", newJString(billingAccountName))
  add(path_594666, "invoiceName", newJString(invoiceName))
  result = call_594665.call(path_594666, query_594667, nil, nil, nil)

var priceSheetDownload* = Call_PriceSheetDownload_594658(
    name: "priceSheetDownload", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/invoices/{invoiceName}/pricesheet/default/download",
    validator: validate_PriceSheetDownload_594659, base: "",
    url: url_PriceSheetDownload_594660, schemes: {Scheme.Https})
type
  Call_InvoiceSectionsListByCreateSubscriptionPermission_594668 = ref object of OpenApiRestCall_593438
proc url_InvoiceSectionsListByCreateSubscriptionPermission_594670(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/listInvoiceSectionsWithCreateSubscriptionPermission")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InvoiceSectionsListByCreateSubscriptionPermission_594669(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all invoiceSections with create subscription permission for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594671 = path.getOrDefault("billingAccountName")
  valid_594671 = validateParameter(valid_594671, JString, required = true,
                                 default = nil)
  if valid_594671 != nil:
    section.add "billingAccountName", valid_594671
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $expand: JString
  ##          : May be used to expand the billingProfiles.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594672 = query.getOrDefault("api-version")
  valid_594672 = validateParameter(valid_594672, JString, required = true,
                                 default = nil)
  if valid_594672 != nil:
    section.add "api-version", valid_594672
  var valid_594673 = query.getOrDefault("$expand")
  valid_594673 = validateParameter(valid_594673, JString, required = false,
                                 default = nil)
  if valid_594673 != nil:
    section.add "$expand", valid_594673
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594674: Call_InvoiceSectionsListByCreateSubscriptionPermission_594668;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all invoiceSections with create subscription permission for a user.
  ## 
  let valid = call_594674.validator(path, query, header, formData, body)
  let scheme = call_594674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594674.url(scheme.get, call_594674.host, call_594674.base,
                         call_594674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594674, url, valid)

proc call*(call_594675: Call_InvoiceSectionsListByCreateSubscriptionPermission_594668;
          apiVersion: string; billingAccountName: string; Expand: string = ""): Recallable =
  ## invoiceSectionsListByCreateSubscriptionPermission
  ## Lists all invoiceSections with create subscription permission for a user.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   Expand: string
  ##         : May be used to expand the billingProfiles.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_594676 = newJObject()
  var query_594677 = newJObject()
  add(query_594677, "api-version", newJString(apiVersion))
  add(query_594677, "$expand", newJString(Expand))
  add(path_594676, "billingAccountName", newJString(billingAccountName))
  result = call_594675.call(path_594676, query_594677, nil, nil, nil)

var invoiceSectionsListByCreateSubscriptionPermission* = Call_InvoiceSectionsListByCreateSubscriptionPermission_594668(
    name: "invoiceSectionsListByCreateSubscriptionPermission",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/listInvoiceSectionsWithCreateSubscriptionPermission",
    validator: validate_InvoiceSectionsListByCreateSubscriptionPermission_594669,
    base: "", url: url_InvoiceSectionsListByCreateSubscriptionPermission_594670,
    schemes: {Scheme.Https})
type
  Call_PaymentMethodsListByBillingAccountName_594678 = ref object of OpenApiRestCall_593438
proc url_PaymentMethodsListByBillingAccountName_594680(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/paymentMethods")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PaymentMethodsListByBillingAccountName_594679(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Payment Methods by billing account Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/2018-11-01-preview/paymentmethods
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594681 = path.getOrDefault("billingAccountName")
  valid_594681 = validateParameter(valid_594681, JString, required = true,
                                 default = nil)
  if valid_594681 != nil:
    section.add "billingAccountName", valid_594681
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594682 = query.getOrDefault("api-version")
  valid_594682 = validateParameter(valid_594682, JString, required = true,
                                 default = nil)
  if valid_594682 != nil:
    section.add "api-version", valid_594682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594683: Call_PaymentMethodsListByBillingAccountName_594678;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Payment Methods by billing account Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/billing/2018-11-01-preview/paymentmethods
  let valid = call_594683.validator(path, query, header, formData, body)
  let scheme = call_594683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594683.url(scheme.get, call_594683.host, call_594683.base,
                         call_594683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594683, url, valid)

proc call*(call_594684: Call_PaymentMethodsListByBillingAccountName_594678;
          apiVersion: string; billingAccountName: string): Recallable =
  ## paymentMethodsListByBillingAccountName
  ## Lists the Payment Methods by billing account Id.
  ## https://docs.microsoft.com/en-us/rest/api/billing/2018-11-01-preview/paymentmethods
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_594685 = newJObject()
  var query_594686 = newJObject()
  add(query_594686, "api-version", newJString(apiVersion))
  add(path_594685, "billingAccountName", newJString(billingAccountName))
  result = call_594684.call(path_594685, query_594686, nil, nil, nil)

var paymentMethodsListByBillingAccountName* = Call_PaymentMethodsListByBillingAccountName_594678(
    name: "paymentMethodsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/paymentMethods",
    validator: validate_PaymentMethodsListByBillingAccountName_594679, base: "",
    url: url_PaymentMethodsListByBillingAccountName_594680,
    schemes: {Scheme.Https})
type
  Call_ProductsListByBillingAccountName_594687 = ref object of OpenApiRestCall_593438
proc url_ProductsListByBillingAccountName_594689(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsListByBillingAccountName_594688(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists products by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594690 = path.getOrDefault("billingAccountName")
  valid_594690 = validateParameter(valid_594690, JString, required = true,
                                 default = nil)
  if valid_594690 != nil:
    section.add "billingAccountName", valid_594690
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   $filter: JString
  ##          : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594691 = query.getOrDefault("api-version")
  valid_594691 = validateParameter(valid_594691, JString, required = true,
                                 default = nil)
  if valid_594691 != nil:
    section.add "api-version", valid_594691
  var valid_594692 = query.getOrDefault("$filter")
  valid_594692 = validateParameter(valid_594692, JString, required = false,
                                 default = nil)
  if valid_594692 != nil:
    section.add "$filter", valid_594692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594693: Call_ProductsListByBillingAccountName_594687;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists products by billing account name.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594693.validator(path, query, header, formData, body)
  let scheme = call_594693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594693.url(scheme.get, call_594693.host, call_594693.base,
                         call_594693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594693, url, valid)

proc call*(call_594694: Call_ProductsListByBillingAccountName_594687;
          apiVersion: string; billingAccountName: string; Filter: string = ""): Recallable =
  ## productsListByBillingAccountName
  ## Lists products by billing account name.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   Filter: string
  ##         : May be used to filter by product type. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_594695 = newJObject()
  var query_594696 = newJObject()
  add(query_594696, "api-version", newJString(apiVersion))
  add(path_594695, "billingAccountName", newJString(billingAccountName))
  add(query_594696, "$filter", newJString(Filter))
  result = call_594694.call(path_594695, query_594696, nil, nil, nil)

var productsListByBillingAccountName* = Call_ProductsListByBillingAccountName_594687(
    name: "productsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/products",
    validator: validate_ProductsListByBillingAccountName_594688, base: "",
    url: url_ProductsListByBillingAccountName_594689, schemes: {Scheme.Https})
type
  Call_ProductsUpdateAutoRenewByBillingAccountName_594697 = ref object of OpenApiRestCall_593438
proc url_ProductsUpdateAutoRenewByBillingAccountName_594699(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productName"),
               (kind: ConstantSegment, value: "/updateAutoRenew")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductsUpdateAutoRenewByBillingAccountName_594698(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel auto renew for product by product id and billing account name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Invoice Id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_594700 = path.getOrDefault("productName")
  valid_594700 = validateParameter(valid_594700, JString, required = true,
                                 default = nil)
  if valid_594700 != nil:
    section.add "productName", valid_594700
  var valid_594701 = path.getOrDefault("billingAccountName")
  valid_594701 = validateParameter(valid_594701, JString, required = true,
                                 default = nil)
  if valid_594701 != nil:
    section.add "billingAccountName", valid_594701
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594702 = query.getOrDefault("api-version")
  valid_594702 = validateParameter(valid_594702, JString, required = true,
                                 default = nil)
  if valid_594702 != nil:
    section.add "api-version", valid_594702
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Update auto renew request parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594704: Call_ProductsUpdateAutoRenewByBillingAccountName_594697;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancel auto renew for product by product id and billing account name
  ## 
  let valid = call_594704.validator(path, query, header, formData, body)
  let scheme = call_594704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594704.url(scheme.get, call_594704.host, call_594704.base,
                         call_594704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594704, url, valid)

proc call*(call_594705: Call_ProductsUpdateAutoRenewByBillingAccountName_594697;
          productName: string; apiVersion: string; billingAccountName: string;
          body: JsonNode): Recallable =
  ## productsUpdateAutoRenewByBillingAccountName
  ## Cancel auto renew for product by product id and billing account name
  ##   productName: string (required)
  ##              : Invoice Id.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   body: JObject (required)
  ##       : Update auto renew request parameters.
  var path_594706 = newJObject()
  var query_594707 = newJObject()
  var body_594708 = newJObject()
  add(path_594706, "productName", newJString(productName))
  add(query_594707, "api-version", newJString(apiVersion))
  add(path_594706, "billingAccountName", newJString(billingAccountName))
  if body != nil:
    body_594708 = body
  result = call_594705.call(path_594706, query_594707, nil, nil, body_594708)

var productsUpdateAutoRenewByBillingAccountName* = Call_ProductsUpdateAutoRenewByBillingAccountName_594697(
    name: "productsUpdateAutoRenewByBillingAccountName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/products/{productName}/updateAutoRenew",
    validator: validate_ProductsUpdateAutoRenewByBillingAccountName_594698,
    base: "", url: url_ProductsUpdateAutoRenewByBillingAccountName_594699,
    schemes: {Scheme.Https})
type
  Call_BillingPermissionsListByBillingAccount_594709 = ref object of OpenApiRestCall_593438
proc url_BillingPermissionsListByBillingAccount_594711(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPermissionsListByBillingAccount_594710(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all billing permissions for the caller under a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594712 = path.getOrDefault("billingAccountName")
  valid_594712 = validateParameter(valid_594712, JString, required = true,
                                 default = nil)
  if valid_594712 != nil:
    section.add "billingAccountName", valid_594712
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594713 = query.getOrDefault("api-version")
  valid_594713 = validateParameter(valid_594713, JString, required = true,
                                 default = nil)
  if valid_594713 != nil:
    section.add "api-version", valid_594713
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594714: Call_BillingPermissionsListByBillingAccount_594709;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all billing permissions for the caller under a billing account.
  ## 
  let valid = call_594714.validator(path, query, header, formData, body)
  let scheme = call_594714.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594714.url(scheme.get, call_594714.host, call_594714.base,
                         call_594714.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594714, url, valid)

proc call*(call_594715: Call_BillingPermissionsListByBillingAccount_594709;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingPermissionsListByBillingAccount
  ## Lists all billing permissions for the caller under a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_594716 = newJObject()
  var query_594717 = newJObject()
  add(query_594717, "api-version", newJString(apiVersion))
  add(path_594716, "billingAccountName", newJString(billingAccountName))
  result = call_594715.call(path_594716, query_594717, nil, nil, nil)

var billingPermissionsListByBillingAccount* = Call_BillingPermissionsListByBillingAccount_594709(
    name: "billingPermissionsListByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingPermissions",
    validator: validate_BillingPermissionsListByBillingAccount_594710, base: "",
    url: url_BillingPermissionsListByBillingAccount_594711,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsListByBillingAccountName_594718 = ref object of OpenApiRestCall_593438
proc url_BillingRoleAssignmentsListByBillingAccountName_594720(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsListByBillingAccountName_594719(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the role assignments on the Billing Account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594721 = path.getOrDefault("billingAccountName")
  valid_594721 = validateParameter(valid_594721, JString, required = true,
                                 default = nil)
  if valid_594721 != nil:
    section.add "billingAccountName", valid_594721
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594722 = query.getOrDefault("api-version")
  valid_594722 = validateParameter(valid_594722, JString, required = true,
                                 default = nil)
  if valid_594722 != nil:
    section.add "api-version", valid_594722
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594723: Call_BillingRoleAssignmentsListByBillingAccountName_594718;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignments on the Billing Account
  ## 
  let valid = call_594723.validator(path, query, header, formData, body)
  let scheme = call_594723.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594723.url(scheme.get, call_594723.host, call_594723.base,
                         call_594723.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594723, url, valid)

proc call*(call_594724: Call_BillingRoleAssignmentsListByBillingAccountName_594718;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingRoleAssignmentsListByBillingAccountName
  ## Get the role assignments on the Billing Account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_594725 = newJObject()
  var query_594726 = newJObject()
  add(query_594726, "api-version", newJString(apiVersion))
  add(path_594725, "billingAccountName", newJString(billingAccountName))
  result = call_594724.call(path_594725, query_594726, nil, nil, nil)

var billingRoleAssignmentsListByBillingAccountName* = Call_BillingRoleAssignmentsListByBillingAccountName_594718(
    name: "billingRoleAssignmentsListByBillingAccountName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleAssignments",
    validator: validate_BillingRoleAssignmentsListByBillingAccountName_594719,
    base: "", url: url_BillingRoleAssignmentsListByBillingAccountName_594720,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsGetByBillingAccount_594727 = ref object of OpenApiRestCall_593438
proc url_BillingRoleAssignmentsGetByBillingAccount_594729(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsGetByBillingAccount_594728(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the role assignment for the caller
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_594730 = path.getOrDefault("billingRoleAssignmentName")
  valid_594730 = validateParameter(valid_594730, JString, required = true,
                                 default = nil)
  if valid_594730 != nil:
    section.add "billingRoleAssignmentName", valid_594730
  var valid_594731 = path.getOrDefault("billingAccountName")
  valid_594731 = validateParameter(valid_594731, JString, required = true,
                                 default = nil)
  if valid_594731 != nil:
    section.add "billingAccountName", valid_594731
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594732 = query.getOrDefault("api-version")
  valid_594732 = validateParameter(valid_594732, JString, required = true,
                                 default = nil)
  if valid_594732 != nil:
    section.add "api-version", valid_594732
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594733: Call_BillingRoleAssignmentsGetByBillingAccount_594727;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the role assignment for the caller
  ## 
  let valid = call_594733.validator(path, query, header, formData, body)
  let scheme = call_594733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594733.url(scheme.get, call_594733.host, call_594733.base,
                         call_594733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594733, url, valid)

proc call*(call_594734: Call_BillingRoleAssignmentsGetByBillingAccount_594727;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string): Recallable =
  ## billingRoleAssignmentsGetByBillingAccount
  ## Get the role assignment for the caller
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_594735 = newJObject()
  var query_594736 = newJObject()
  add(query_594736, "api-version", newJString(apiVersion))
  add(path_594735, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_594735, "billingAccountName", newJString(billingAccountName))
  result = call_594734.call(path_594735, query_594736, nil, nil, nil)

var billingRoleAssignmentsGetByBillingAccount* = Call_BillingRoleAssignmentsGetByBillingAccount_594727(
    name: "billingRoleAssignmentsGetByBillingAccount", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsGetByBillingAccount_594728,
    base: "", url: url_BillingRoleAssignmentsGetByBillingAccount_594729,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsDeleteByBillingAccountName_594737 = ref object of OpenApiRestCall_593438
proc url_BillingRoleAssignmentsDeleteByBillingAccountName_594739(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingRoleAssignmentName" in path,
        "`billingRoleAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleAssignments/"),
               (kind: VariableSegment, value: "billingRoleAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsDeleteByBillingAccountName_594738(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete the role assignment on this billing account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingRoleAssignmentName: JString (required)
  ##                            : role assignment id.
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `billingRoleAssignmentName` field"
  var valid_594740 = path.getOrDefault("billingRoleAssignmentName")
  valid_594740 = validateParameter(valid_594740, JString, required = true,
                                 default = nil)
  if valid_594740 != nil:
    section.add "billingRoleAssignmentName", valid_594740
  var valid_594741 = path.getOrDefault("billingAccountName")
  valid_594741 = validateParameter(valid_594741, JString, required = true,
                                 default = nil)
  if valid_594741 != nil:
    section.add "billingAccountName", valid_594741
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594742 = query.getOrDefault("api-version")
  valid_594742 = validateParameter(valid_594742, JString, required = true,
                                 default = nil)
  if valid_594742 != nil:
    section.add "api-version", valid_594742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594743: Call_BillingRoleAssignmentsDeleteByBillingAccountName_594737;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the role assignment on this billing account
  ## 
  let valid = call_594743.validator(path, query, header, formData, body)
  let scheme = call_594743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594743.url(scheme.get, call_594743.host, call_594743.base,
                         call_594743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594743, url, valid)

proc call*(call_594744: Call_BillingRoleAssignmentsDeleteByBillingAccountName_594737;
          apiVersion: string; billingRoleAssignmentName: string;
          billingAccountName: string): Recallable =
  ## billingRoleAssignmentsDeleteByBillingAccountName
  ## Delete the role assignment on this billing account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingRoleAssignmentName: string (required)
  ##                            : role assignment id.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_594745 = newJObject()
  var query_594746 = newJObject()
  add(query_594746, "api-version", newJString(apiVersion))
  add(path_594745, "billingRoleAssignmentName",
      newJString(billingRoleAssignmentName))
  add(path_594745, "billingAccountName", newJString(billingAccountName))
  result = call_594744.call(path_594745, query_594746, nil, nil, nil)

var billingRoleAssignmentsDeleteByBillingAccountName* = Call_BillingRoleAssignmentsDeleteByBillingAccountName_594737(
    name: "billingRoleAssignmentsDeleteByBillingAccountName",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleAssignments/{billingRoleAssignmentName}",
    validator: validate_BillingRoleAssignmentsDeleteByBillingAccountName_594738,
    base: "", url: url_BillingRoleAssignmentsDeleteByBillingAccountName_594739,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsListByBillingAccountName_594747 = ref object of OpenApiRestCall_593438
proc url_BillingRoleDefinitionsListByBillingAccountName_594749(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleDefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsListByBillingAccountName_594748(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the role definition for a billing account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594750 = path.getOrDefault("billingAccountName")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "billingAccountName", valid_594750
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594751 = query.getOrDefault("api-version")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = nil)
  if valid_594751 != nil:
    section.add "api-version", valid_594751
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594752: Call_BillingRoleDefinitionsListByBillingAccountName_594747;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the role definition for a billing account
  ## 
  let valid = call_594752.validator(path, query, header, formData, body)
  let scheme = call_594752.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594752.url(scheme.get, call_594752.host, call_594752.base,
                         call_594752.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594752, url, valid)

proc call*(call_594753: Call_BillingRoleDefinitionsListByBillingAccountName_594747;
          apiVersion: string; billingAccountName: string): Recallable =
  ## billingRoleDefinitionsListByBillingAccountName
  ## Lists the role definition for a billing account
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  var path_594754 = newJObject()
  var query_594755 = newJObject()
  add(query_594755, "api-version", newJString(apiVersion))
  add(path_594754, "billingAccountName", newJString(billingAccountName))
  result = call_594753.call(path_594754, query_594755, nil, nil, nil)

var billingRoleDefinitionsListByBillingAccountName* = Call_BillingRoleDefinitionsListByBillingAccountName_594747(
    name: "billingRoleDefinitionsListByBillingAccountName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleDefinitions",
    validator: validate_BillingRoleDefinitionsListByBillingAccountName_594748,
    base: "", url: url_BillingRoleDefinitionsListByBillingAccountName_594749,
    schemes: {Scheme.Https})
type
  Call_BillingRoleDefinitionsGetByBillingAccountName_594756 = ref object of OpenApiRestCall_593438
proc url_BillingRoleDefinitionsGetByBillingAccountName_594758(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  assert "billingRoleDefinitionName" in path,
        "`billingRoleDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/billingRoleDefinitions/"),
               (kind: VariableSegment, value: "billingRoleDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleDefinitionsGetByBillingAccountName_594757(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the role definition for a role
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  ##   billingRoleDefinitionName: JString (required)
  ##                            : role definition id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594759 = path.getOrDefault("billingAccountName")
  valid_594759 = validateParameter(valid_594759, JString, required = true,
                                 default = nil)
  if valid_594759 != nil:
    section.add "billingAccountName", valid_594759
  var valid_594760 = path.getOrDefault("billingRoleDefinitionName")
  valid_594760 = validateParameter(valid_594760, JString, required = true,
                                 default = nil)
  if valid_594760 != nil:
    section.add "billingRoleDefinitionName", valid_594760
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594761 = query.getOrDefault("api-version")
  valid_594761 = validateParameter(valid_594761, JString, required = true,
                                 default = nil)
  if valid_594761 != nil:
    section.add "api-version", valid_594761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594762: Call_BillingRoleDefinitionsGetByBillingAccountName_594756;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the role definition for a role
  ## 
  let valid = call_594762.validator(path, query, header, formData, body)
  let scheme = call_594762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594762.url(scheme.get, call_594762.host, call_594762.base,
                         call_594762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594762, url, valid)

proc call*(call_594763: Call_BillingRoleDefinitionsGetByBillingAccountName_594756;
          apiVersion: string; billingAccountName: string;
          billingRoleDefinitionName: string): Recallable =
  ## billingRoleDefinitionsGetByBillingAccountName
  ## Gets the role definition for a role
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   billingRoleDefinitionName: string (required)
  ##                            : role definition id.
  var path_594764 = newJObject()
  var query_594765 = newJObject()
  add(query_594765, "api-version", newJString(apiVersion))
  add(path_594764, "billingAccountName", newJString(billingAccountName))
  add(path_594764, "billingRoleDefinitionName",
      newJString(billingRoleDefinitionName))
  result = call_594763.call(path_594764, query_594765, nil, nil, nil)

var billingRoleDefinitionsGetByBillingAccountName* = Call_BillingRoleDefinitionsGetByBillingAccountName_594756(
    name: "billingRoleDefinitionsGetByBillingAccountName",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/billingRoleDefinitions/{billingRoleDefinitionName}",
    validator: validate_BillingRoleDefinitionsGetByBillingAccountName_594757,
    base: "", url: url_BillingRoleDefinitionsGetByBillingAccountName_594758,
    schemes: {Scheme.Https})
type
  Call_BillingRoleAssignmentsAddByBillingAccountName_594766 = ref object of OpenApiRestCall_593438
proc url_BillingRoleAssignmentsAddByBillingAccountName_594768(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Billing/createBillingRoleAssignment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingRoleAssignmentsAddByBillingAccountName_594767(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to add a role assignment to a billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594769 = path.getOrDefault("billingAccountName")
  valid_594769 = validateParameter(valid_594769, JString, required = true,
                                 default = nil)
  if valid_594769 != nil:
    section.add "billingAccountName", valid_594769
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594770 = query.getOrDefault("api-version")
  valid_594770 = validateParameter(valid_594770, JString, required = true,
                                 default = nil)
  if valid_594770 != nil:
    section.add "api-version", valid_594770
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594772: Call_BillingRoleAssignmentsAddByBillingAccountName_594766;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to add a role assignment to a billing account.
  ## 
  let valid = call_594772.validator(path, query, header, formData, body)
  let scheme = call_594772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594772.url(scheme.get, call_594772.host, call_594772.base,
                         call_594772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594772, url, valid)

proc call*(call_594773: Call_BillingRoleAssignmentsAddByBillingAccountName_594766;
          apiVersion: string; billingAccountName: string; parameters: JsonNode): Recallable =
  ## billingRoleAssignmentsAddByBillingAccountName
  ## The operation to add a role assignment to a billing account.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to add a role assignment.
  var path_594774 = newJObject()
  var query_594775 = newJObject()
  var body_594776 = newJObject()
  add(query_594775, "api-version", newJString(apiVersion))
  add(path_594774, "billingAccountName", newJString(billingAccountName))
  if parameters != nil:
    body_594776 = parameters
  result = call_594773.call(path_594774, query_594775, nil, nil, body_594776)

var billingRoleAssignmentsAddByBillingAccountName* = Call_BillingRoleAssignmentsAddByBillingAccountName_594766(
    name: "billingRoleAssignmentsAddByBillingAccountName",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/providers/Microsoft.Billing/createBillingRoleAssignment",
    validator: validate_BillingRoleAssignmentsAddByBillingAccountName_594767,
    base: "", url: url_BillingRoleAssignmentsAddByBillingAccountName_594768,
    schemes: {Scheme.Https})
type
  Call_TransactionsListByBillingAccountName_594777 = ref object of OpenApiRestCall_593438
proc url_TransactionsListByBillingAccountName_594779(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "billingAccountName" in path,
        "`billingAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/billingAccounts/"),
               (kind: VariableSegment, value: "billingAccountName"),
               (kind: ConstantSegment, value: "/transactions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TransactionsListByBillingAccountName_594778(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the transactions by billing account name for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   billingAccountName: JString (required)
  ##                     : Billing Account Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `billingAccountName` field"
  var valid_594780 = path.getOrDefault("billingAccountName")
  valid_594780 = validateParameter(valid_594780, JString, required = true,
                                 default = nil)
  if valid_594780 != nil:
    section.add "billingAccountName", valid_594780
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: JString (required)
  ##          : End date
  ##   startDate: JString (required)
  ##            : Start date
  ##   $filter: JString
  ##          : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594781 = query.getOrDefault("api-version")
  valid_594781 = validateParameter(valid_594781, JString, required = true,
                                 default = nil)
  if valid_594781 != nil:
    section.add "api-version", valid_594781
  var valid_594782 = query.getOrDefault("endDate")
  valid_594782 = validateParameter(valid_594782, JString, required = true,
                                 default = nil)
  if valid_594782 != nil:
    section.add "endDate", valid_594782
  var valid_594783 = query.getOrDefault("startDate")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "startDate", valid_594783
  var valid_594784 = query.getOrDefault("$filter")
  valid_594784 = validateParameter(valid_594784, JString, required = false,
                                 default = nil)
  if valid_594784 != nil:
    section.add "$filter", valid_594784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594785: Call_TransactionsListByBillingAccountName_594777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the transactions by billing account name for given start and end date.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594785.validator(path, query, header, formData, body)
  let scheme = call_594785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594785.url(scheme.get, call_594785.host, call_594785.base,
                         call_594785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594785, url, valid)

proc call*(call_594786: Call_TransactionsListByBillingAccountName_594777;
          apiVersion: string; endDate: string; billingAccountName: string;
          startDate: string; Filter: string = ""): Recallable =
  ## transactionsListByBillingAccountName
  ## Lists the transactions by billing account name for given start and end date.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   endDate: string (required)
  ##          : End date
  ##   billingAccountName: string (required)
  ##                     : Billing Account Id.
  ##   startDate: string (required)
  ##            : Start date
  ##   Filter: string
  ##         : May be used to filter by transaction kind. The filter supports 'eq', 'lt', 'gt', 'le', 'ge', and 'and'. It does not currently support 'ne', 'or', or 'not'. Tag filter is a key value pair string where key and value is separated by a colon (:).
  var path_594787 = newJObject()
  var query_594788 = newJObject()
  add(query_594788, "api-version", newJString(apiVersion))
  add(query_594788, "endDate", newJString(endDate))
  add(path_594787, "billingAccountName", newJString(billingAccountName))
  add(query_594788, "startDate", newJString(startDate))
  add(query_594788, "$filter", newJString(Filter))
  result = call_594786.call(path_594787, query_594788, nil, nil, nil)

var transactionsListByBillingAccountName* = Call_TransactionsListByBillingAccountName_594777(
    name: "transactionsListByBillingAccountName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/transactions",
    validator: validate_TransactionsListByBillingAccountName_594778, base: "",
    url: url_TransactionsListByBillingAccountName_594779, schemes: {Scheme.Https})
type
  Call_OperationsList_594789 = ref object of OpenApiRestCall_593438
proc url_OperationsList_594791(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_594790(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available billing REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594792 = query.getOrDefault("api-version")
  valid_594792 = validateParameter(valid_594792, JString, required = true,
                                 default = nil)
  if valid_594792 != nil:
    section.add "api-version", valid_594792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594793: Call_OperationsList_594789; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available billing REST API operations.
  ## 
  let valid = call_594793.validator(path, query, header, formData, body)
  let scheme = call_594793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594793.url(scheme.get, call_594793.host, call_594793.base,
                         call_594793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594793, url, valid)

proc call*(call_594794: Call_OperationsList_594789; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available billing REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  var query_594795 = newJObject()
  add(query_594795, "api-version", newJString(apiVersion))
  result = call_594794.call(nil, query_594795, nil, nil, nil)

var operationsList* = Call_OperationsList_594789(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Billing/operations",
    validator: validate_OperationsList_594790, base: "", url: url_OperationsList_594791,
    schemes: {Scheme.Https})
type
  Call_RecipientTransfersList_594796 = ref object of OpenApiRestCall_593438
proc url_RecipientTransfersList_594798(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecipientTransfersList_594797(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594799: Call_RecipientTransfersList_594796; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594799.validator(path, query, header, formData, body)
  let scheme = call_594799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594799.url(scheme.get, call_594799.host, call_594799.base,
                         call_594799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594799, url, valid)

proc call*(call_594800: Call_RecipientTransfersList_594796): Recallable =
  ## recipientTransfersList
  result = call_594800.call(nil, nil, nil, nil, nil)

var recipientTransfersList* = Call_RecipientTransfersList_594796(
    name: "recipientTransfersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers",
    validator: validate_RecipientTransfersList_594797, base: "",
    url: url_RecipientTransfersList_594798, schemes: {Scheme.Https})
type
  Call_RecipientTransfersGet_594801 = ref object of OpenApiRestCall_593438
proc url_RecipientTransfersGet_594803(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/transfers/"),
               (kind: VariableSegment, value: "transferName"),
               (kind: ConstantSegment, value: "/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecipientTransfersGet_594802(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_594804 = path.getOrDefault("transferName")
  valid_594804 = validateParameter(valid_594804, JString, required = true,
                                 default = nil)
  if valid_594804 != nil:
    section.add "transferName", valid_594804
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594805: Call_RecipientTransfersGet_594801; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594805.validator(path, query, header, formData, body)
  let scheme = call_594805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594805.url(scheme.get, call_594805.host, call_594805.base,
                         call_594805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594805, url, valid)

proc call*(call_594806: Call_RecipientTransfersGet_594801; transferName: string): Recallable =
  ## recipientTransfersGet
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_594807 = newJObject()
  add(path_594807, "transferName", newJString(transferName))
  result = call_594806.call(path_594807, nil, nil, nil, nil)

var recipientTransfersGet* = Call_RecipientTransfersGet_594801(
    name: "recipientTransfersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Billing/transfers/{transferName}/",
    validator: validate_RecipientTransfersGet_594802, base: "",
    url: url_RecipientTransfersGet_594803, schemes: {Scheme.Https})
type
  Call_RecipientTransfersAccept_594808 = ref object of OpenApiRestCall_593438
proc url_RecipientTransfersAccept_594810(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/transfers/"),
               (kind: VariableSegment, value: "transferName"),
               (kind: ConstantSegment, value: "/acceptTransfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecipientTransfersAccept_594809(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_594811 = path.getOrDefault("transferName")
  valid_594811 = validateParameter(valid_594811, JString, required = true,
                                 default = nil)
  if valid_594811 != nil:
    section.add "transferName", valid_594811
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Accept transfer parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594813: Call_RecipientTransfersAccept_594808; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594813.validator(path, query, header, formData, body)
  let scheme = call_594813.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594813.url(scheme.get, call_594813.host, call_594813.base,
                         call_594813.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594813, url, valid)

proc call*(call_594814: Call_RecipientTransfersAccept_594808; body: JsonNode;
          transferName: string): Recallable =
  ## recipientTransfersAccept
  ##   body: JObject (required)
  ##       : Accept transfer parameters.
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_594815 = newJObject()
  var body_594816 = newJObject()
  if body != nil:
    body_594816 = body
  add(path_594815, "transferName", newJString(transferName))
  result = call_594814.call(path_594815, nil, nil, nil, body_594816)

var recipientTransfersAccept* = Call_RecipientTransfersAccept_594808(
    name: "recipientTransfersAccept", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers/{transferName}/acceptTransfer",
    validator: validate_RecipientTransfersAccept_594809, base: "",
    url: url_RecipientTransfersAccept_594810, schemes: {Scheme.Https})
type
  Call_RecipientTransfersDecline_594817 = ref object of OpenApiRestCall_593438
proc url_RecipientTransfersDecline_594819(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "transferName" in path, "`transferName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Billing/transfers/"),
               (kind: VariableSegment, value: "transferName"),
               (kind: ConstantSegment, value: "/declineTransfer")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecipientTransfersDecline_594818(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   transferName: JString (required)
  ##               : Transfer Name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `transferName` field"
  var valid_594820 = path.getOrDefault("transferName")
  valid_594820 = validateParameter(valid_594820, JString, required = true,
                                 default = nil)
  if valid_594820 != nil:
    section.add "transferName", valid_594820
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594821: Call_RecipientTransfersDecline_594817; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594821.validator(path, query, header, formData, body)
  let scheme = call_594821.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594821.url(scheme.get, call_594821.host, call_594821.base,
                         call_594821.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594821, url, valid)

proc call*(call_594822: Call_RecipientTransfersDecline_594817; transferName: string): Recallable =
  ## recipientTransfersDecline
  ##   transferName: string (required)
  ##               : Transfer Name.
  var path_594823 = newJObject()
  add(path_594823, "transferName", newJString(transferName))
  result = call_594822.call(path_594823, nil, nil, nil, nil)

var recipientTransfersDecline* = Call_RecipientTransfersDecline_594817(
    name: "recipientTransfersDecline", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Billing/transfers/{transferName}/declineTransfer",
    validator: validate_RecipientTransfersDecline_594818, base: "",
    url: url_RecipientTransfersDecline_594819, schemes: {Scheme.Https})
type
  Call_AddressesValidate_594824 = ref object of OpenApiRestCall_593438
proc url_AddressesValidate_594826(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AddressesValidate_594825(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Validates the address.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594827 = query.getOrDefault("api-version")
  valid_594827 = validateParameter(valid_594827, JString, required = true,
                                 default = nil)
  if valid_594827 != nil:
    section.add "api-version", valid_594827
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   address: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594829: Call_AddressesValidate_594824; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the address.
  ## 
  let valid = call_594829.validator(path, query, header, formData, body)
  let scheme = call_594829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594829.url(scheme.get, call_594829.host, call_594829.base,
                         call_594829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594829, url, valid)

proc call*(call_594830: Call_AddressesValidate_594824; apiVersion: string;
          address: JsonNode): Recallable =
  ## addressesValidate
  ## Validates the address.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   address: JObject (required)
  var query_594831 = newJObject()
  var body_594832 = newJObject()
  add(query_594831, "api-version", newJString(apiVersion))
  if address != nil:
    body_594832 = address
  result = call_594830.call(nil, query_594831, nil, nil, body_594832)

var addressesValidate* = Call_AddressesValidate_594824(name: "addressesValidate",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.Billing/validateAddress",
    validator: validate_AddressesValidate_594825, base: "",
    url: url_AddressesValidate_594826, schemes: {Scheme.Https})
type
  Call_LineOfCreditsUpdate_594842 = ref object of OpenApiRestCall_593438
proc url_LineOfCreditsUpdate_594844(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LineOfCreditsUpdate_594843(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Increase the current line of credit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594845 = path.getOrDefault("subscriptionId")
  valid_594845 = validateParameter(valid_594845, JString, required = true,
                                 default = nil)
  if valid_594845 != nil:
    section.add "subscriptionId", valid_594845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594846 = query.getOrDefault("api-version")
  valid_594846 = validateParameter(valid_594846, JString, required = true,
                                 default = nil)
  if valid_594846 != nil:
    section.add "api-version", valid_594846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the increase line of credit operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594848: Call_LineOfCreditsUpdate_594842; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Increase the current line of credit.
  ## 
  let valid = call_594848.validator(path, query, header, formData, body)
  let scheme = call_594848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594848.url(scheme.get, call_594848.host, call_594848.base,
                         call_594848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594848, url, valid)

proc call*(call_594849: Call_LineOfCreditsUpdate_594842; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## lineOfCreditsUpdate
  ## Increase the current line of credit.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the increase line of credit operation.
  var path_594850 = newJObject()
  var query_594851 = newJObject()
  var body_594852 = newJObject()
  add(query_594851, "api-version", newJString(apiVersion))
  add(path_594850, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594852 = parameters
  result = call_594849.call(path_594850, query_594851, nil, nil, body_594852)

var lineOfCreditsUpdate* = Call_LineOfCreditsUpdate_594842(
    name: "lineOfCreditsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default",
    validator: validate_LineOfCreditsUpdate_594843, base: "",
    url: url_LineOfCreditsUpdate_594844, schemes: {Scheme.Https})
type
  Call_LineOfCreditsGet_594833 = ref object of OpenApiRestCall_593438
proc url_LineOfCreditsGet_594835(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LineOfCreditsGet_594834(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the current line of credit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594836 = path.getOrDefault("subscriptionId")
  valid_594836 = validateParameter(valid_594836, JString, required = true,
                                 default = nil)
  if valid_594836 != nil:
    section.add "subscriptionId", valid_594836
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594837 = query.getOrDefault("api-version")
  valid_594837 = validateParameter(valid_594837, JString, required = true,
                                 default = nil)
  if valid_594837 != nil:
    section.add "api-version", valid_594837
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594838: Call_LineOfCreditsGet_594833; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the current line of credit.
  ## 
  let valid = call_594838.validator(path, query, header, formData, body)
  let scheme = call_594838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594838.url(scheme.get, call_594838.host, call_594838.base,
                         call_594838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594838, url, valid)

proc call*(call_594839: Call_LineOfCreditsGet_594833; apiVersion: string;
          subscriptionId: string): Recallable =
  ## lineOfCreditsGet
  ## Get the current line of credit.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id.
  var path_594840 = newJObject()
  var query_594841 = newJObject()
  add(query_594841, "api-version", newJString(apiVersion))
  add(path_594840, "subscriptionId", newJString(subscriptionId))
  result = call_594839.call(path_594840, query_594841, nil, nil, nil)

var lineOfCreditsGet* = Call_LineOfCreditsGet_594833(name: "lineOfCreditsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingAccounts/default/lineOfCredit/default",
    validator: validate_LineOfCreditsGet_594834, base: "",
    url: url_LineOfCreditsGet_594835, schemes: {Scheme.Https})
type
  Call_BillingPropertyGet_594853 = ref object of OpenApiRestCall_593438
proc url_BillingPropertyGet_594855(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Billing/billingProperty")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BillingPropertyGet_594854(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get billing property by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594856 = path.getOrDefault("subscriptionId")
  valid_594856 = validateParameter(valid_594856, JString, required = true,
                                 default = nil)
  if valid_594856 != nil:
    section.add "subscriptionId", valid_594856
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594857 = query.getOrDefault("api-version")
  valid_594857 = validateParameter(valid_594857, JString, required = true,
                                 default = nil)
  if valid_594857 != nil:
    section.add "api-version", valid_594857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594858: Call_BillingPropertyGet_594853; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get billing property by subscription Id.
  ## 
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  let valid = call_594858.validator(path, query, header, formData, body)
  let scheme = call_594858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594858.url(scheme.get, call_594858.host, call_594858.base,
                         call_594858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594858, url, valid)

proc call*(call_594859: Call_BillingPropertyGet_594853; apiVersion: string;
          subscriptionId: string): Recallable =
  ## billingPropertyGet
  ## Get billing property by subscription Id.
  ## https://docs.microsoft.com/en-us/rest/api/consumption/
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-11-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id.
  var path_594860 = newJObject()
  var query_594861 = newJObject()
  add(query_594861, "api-version", newJString(apiVersion))
  add(path_594860, "subscriptionId", newJString(subscriptionId))
  result = call_594859.call(path_594860, query_594861, nil, nil, nil)

var billingPropertyGet* = Call_BillingPropertyGet_594853(
    name: "billingPropertyGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Billing/billingProperty",
    validator: validate_BillingPropertyGet_594854, base: "",
    url: url_BillingPropertyGet_594855, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
