
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AzureBridgeAdminClient
## version: 2016-01-01
## termsOfService: (not provided)
## license: (not provided)
## 
## AzureBridge Admin Client.
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
  macServiceName = "azsadmin-DownloadedProduct"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DownloadedProductsList_593646 = ref object of OpenApiRestCall_593424
proc url_DownloadedProductsList_593648(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "activationName" in path, "`activationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureBridge.Admin/activations/"),
               (kind: VariableSegment, value: "activationName"),
               (kind: ConstantSegment, value: "/downloadedProducts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DownloadedProductsList_593647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of downloaded products.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   activationName: JString (required)
  ##                 : Name of the activation.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : The resource group the resource is located under.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `activationName` field"
  var valid_593808 = path.getOrDefault("activationName")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "activationName", valid_593808
  var valid_593809 = path.getOrDefault("subscriptionId")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "subscriptionId", valid_593809
  var valid_593810 = path.getOrDefault("resourceGroup")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "resourceGroup", valid_593810
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593824 = query.getOrDefault("api-version")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = newJString("2016-01-01"))
  if valid_593824 != nil:
    section.add "api-version", valid_593824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593851: Call_DownloadedProductsList_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of downloaded products.
  ## 
  let valid = call_593851.validator(path, query, header, formData, body)
  let scheme = call_593851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593851.url(scheme.get, call_593851.host, call_593851.base,
                         call_593851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593851, url, valid)

proc call*(call_593922: Call_DownloadedProductsList_593646; activationName: string;
          subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2016-01-01"): Recallable =
  ## downloadedProductsList
  ## Get a list of downloaded products.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   activationName: string (required)
  ##                 : Name of the activation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : The resource group the resource is located under.
  var path_593923 = newJObject()
  var query_593925 = newJObject()
  add(query_593925, "api-version", newJString(apiVersion))
  add(path_593923, "activationName", newJString(activationName))
  add(path_593923, "subscriptionId", newJString(subscriptionId))
  add(path_593923, "resourceGroup", newJString(resourceGroup))
  result = call_593922.call(path_593923, query_593925, nil, nil, nil)

var downloadedProductsList* = Call_DownloadedProductsList_593646(
    name: "downloadedProductsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroup}/providers/Microsoft.AzureBridge.Admin/activations/{activationName}/downloadedProducts",
    validator: validate_DownloadedProductsList_593647, base: "",
    url: url_DownloadedProductsList_593648, schemes: {Scheme.Https})
type
  Call_DownloadedProductsGet_593964 = ref object of OpenApiRestCall_593424
proc url_DownloadedProductsGet_593966(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "activationName" in path, "`activationName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureBridge.Admin/activations/"),
               (kind: VariableSegment, value: "activationName"),
               (kind: ConstantSegment, value: "/downloadedProducts/"),
               (kind: VariableSegment, value: "productName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DownloadedProductsGet_593965(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a downloaded product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Name of the product.
  ##   activationName: JString (required)
  ##                 : Name of the activation.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : The resource group the resource is located under.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_593967 = path.getOrDefault("productName")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "productName", valid_593967
  var valid_593968 = path.getOrDefault("activationName")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "activationName", valid_593968
  var valid_593969 = path.getOrDefault("subscriptionId")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "subscriptionId", valid_593969
  var valid_593970 = path.getOrDefault("resourceGroup")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "resourceGroup", valid_593970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = newJString("2016-01-01"))
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_DownloadedProductsGet_593964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a downloaded product.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_DownloadedProductsGet_593964; productName: string;
          activationName: string; subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2016-01-01"): Recallable =
  ## downloadedProductsGet
  ## Get a downloaded product.
  ##   productName: string (required)
  ##              : Name of the product.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   activationName: string (required)
  ##                 : Name of the activation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : The resource group the resource is located under.
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  add(path_593974, "productName", newJString(productName))
  add(query_593975, "api-version", newJString(apiVersion))
  add(path_593974, "activationName", newJString(activationName))
  add(path_593974, "subscriptionId", newJString(subscriptionId))
  add(path_593974, "resourceGroup", newJString(resourceGroup))
  result = call_593973.call(path_593974, query_593975, nil, nil, nil)

var downloadedProductsGet* = Call_DownloadedProductsGet_593964(
    name: "downloadedProductsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroup}/providers/Microsoft.AzureBridge.Admin/activations/{activationName}/downloadedProducts/{productName}",
    validator: validate_DownloadedProductsGet_593965, base: "",
    url: url_DownloadedProductsGet_593966, schemes: {Scheme.Https})
type
  Call_DownloadedProductsDelete_593976 = ref object of OpenApiRestCall_593424
proc url_DownloadedProductsDelete_593978(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "activationName" in path, "`activationName` is a required path parameter"
  assert "productName" in path, "`productName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureBridge.Admin/activations/"),
               (kind: VariableSegment, value: "activationName"),
               (kind: ConstantSegment, value: "/downloadedProducts/"),
               (kind: VariableSegment, value: "productName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DownloadedProductsDelete_593977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a downloaded product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   productName: JString (required)
  ##              : Name of the product.
  ##   activationName: JString (required)
  ##                 : Name of the activation.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : The resource group the resource is located under.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `productName` field"
  var valid_593979 = path.getOrDefault("productName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "productName", valid_593979
  var valid_593980 = path.getOrDefault("activationName")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "activationName", valid_593980
  var valid_593981 = path.getOrDefault("subscriptionId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "subscriptionId", valid_593981
  var valid_593982 = path.getOrDefault("resourceGroup")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "resourceGroup", valid_593982
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593983 = query.getOrDefault("api-version")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = newJString("2016-01-01"))
  if valid_593983 != nil:
    section.add "api-version", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_DownloadedProductsDelete_593976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a downloaded product.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_DownloadedProductsDelete_593976; productName: string;
          activationName: string; subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2016-01-01"): Recallable =
  ## downloadedProductsDelete
  ## Delete a downloaded product.
  ##   productName: string (required)
  ##              : Name of the product.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   activationName: string (required)
  ##                 : Name of the activation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : The resource group the resource is located under.
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  add(path_593986, "productName", newJString(productName))
  add(query_593987, "api-version", newJString(apiVersion))
  add(path_593986, "activationName", newJString(activationName))
  add(path_593986, "subscriptionId", newJString(subscriptionId))
  add(path_593986, "resourceGroup", newJString(resourceGroup))
  result = call_593985.call(path_593986, query_593987, nil, nil, nil)

var downloadedProductsDelete* = Call_DownloadedProductsDelete_593976(
    name: "downloadedProductsDelete", meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroup}/providers/Microsoft.AzureBridge.Admin/activations/{activationName}/downloadedProducts/{productName}",
    validator: validate_DownloadedProductsDelete_593977, base: "",
    url: url_DownloadedProductsDelete_593978, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
